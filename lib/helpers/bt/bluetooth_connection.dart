import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:path_provider/path_provider.dart';

class BleServiceReader {
  late BluetoothDevice device;
  late StreamSubscription<BluetoothDeviceState> deviceConnection;
  late StreamSubscription<List<int>> characteristicSubscription;
  late Timer timer;

  late int heartValue;
  late int tempValue;
  late int service3Value;
  late int service4Value;

  late String _selectedService;

  String getSelectedService() {
    return _selectedService;
  }

  void setSelectedService(String? value) {
    _selectedService = value!;
  }

  late Function() onServiceValuesUpdated;

  ValueNotifier<int> heartValueNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> tempValueNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> service3ValueNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> service4ValueNotifier = ValueNotifier<int>(0);

  Future<void> start() async {
    device = await _findDevice();
    // ignore: unnecessary_null_comparison
    if (device == null) {
      throw Exception('Device not found');
    }

    await device.connect();
    deviceConnection = device.state.listen(_onDeviceStateChanged);

    await _readPersistedValues();

    timer = Timer.periodic(const Duration(minutes: 15), (_) {
      _readServices();
      onServiceValuesUpdated();
    });
  }

  Future<BluetoothDevice> findDevice() async {
    BluetoothDevice device = await _findDevice();
    if (device == null) {
      throw Exception('Device not found');
    }

    await device.connect();
    deviceConnection = device.state.listen(_onDeviceStateChanged);

    await _readPersistedValues();

    timer = Timer.periodic(const Duration(minutes: 15), (_) {
      _readServices();
      onServiceValuesUpdated();
    });

    return device;
  }

  Future<BluetoothDevice> _findDevice() async {
    // Replace with your own logic to find and connect to the BLE device
    // For example:
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
    List<ScanResult> scanResults =
        await flutterBlue.startScan(timeout: const Duration(seconds: 10));
    ScanResult desiredResult = scanResults.firstWhere((result) =>
        result.device.name == '0x4536362B2042443836' &&
        result.device.type == BluetoothDeviceType.le);

    return desiredResult.device;
  }

  Future<void> _readPersistedValues() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/ble_values.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonMap = jsonDecode(jsonString);
        final dynamic heartValueJson = jsonMap['heart'];
        heartValue = heartValueJson != null
            ? int.parse(heartValueJson.toString(), radix: 16)
            : 0;
        final dynamic tempValueJson = jsonMap['temp'];
        tempValue = tempValueJson != null
            ? int.parse(tempValueJson.toString(), radix: 16)
            : 0;
        final dynamic service3ValueJson = jsonMap['service3'];
        service3Value = service3ValueJson != null
            ? int.parse(service3ValueJson.toString(), radix: 16)
            : 0;
        final dynamic service4ValueJson = jsonMap['service4'];
        service4Value = service4ValueJson != null
            ? int.parse(service4ValueJson.toString(), radix: 16)
            : 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading persisted values: $e');
      }
    }
  }

  Future<void> _savePersistedValues() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/ble_values.json');
      final jsonMap = {
        'heart': heartValue.toRadixString(16),
        'temp': tempValue.toRadixString(16),
        'service3': service3Value.toRadixString(16),
        'service4': service4Value.toRadixString(16),
      };
      final jsonString = jsonEncode(jsonMap);

      await file.writeAsString(jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving persisted values: $e');
      }
    }
  }

  void _onDeviceStateChanged(BluetoothDeviceState state) {
    if (state == BluetoothDeviceState.disconnected) {
      timer.cancel();
      deviceConnection.cancel();
      characteristicSubscription.cancel();
    }
  }

  Future<void> _readServices() async {
    var heart =
        await _findService(device, '0000180d-0000-1000-8000-00805f9b34fb');
    var characteristic1 = await _findCharacteristic(
        heart, '00002a37-0000-1000-8000-00805f9b34fb');
    // Enable notifications for heart
    await characteristic1.setNotifyValue(true);

    // Read the value of heart
    await characteristic1.read();
    heartValueNotifier.value = int.parse(
        String.fromCharCodes(characteristic1.value as Iterable<int>),
        radix: 16);

    await _savePersistedValues();

    var temp =
        await _findService(device, '6E4000002-B5A3-f393-E0A9-E50E24DCCA9E');
    var characteristic2 = await _findCharacteristic(
        temp, '6E4000003-B5A3-f393-E0A9-E50E24DCCA9E');
    await characteristic2.read();
    tempValueNotifier.value = int.parse(
        String.fromCharCodes(characteristic2.value as Iterable<int>),
        radix: 16);
    await _savePersistedValues();

    var service3 =
        await _findService(device, '0000fee7-0000-1000-8000-00805f9b34fb');
    var characteristic3 = await _findCharacteristic(
        service3, '0000fea1-0000-1000-8000-00805f9b34fb');
    await characteristic3.read();
    service3ValueNotifier.value = int.parse(
        String.fromCharCodes(characteristic3.value as Iterable<int>),
        radix: 16);
    await _savePersistedValues();

    var service4 =
        await _findService(device, '0000fee7-0000-1000-8000-00805f9b34fb');
    var characteristic4 = await _findCharacteristic(
        service4, '0000fea2-0000-1000-8000-00805f9b34fb');
    await characteristic4.read();
    service4ValueNotifier.value = int.parse(
        String.fromCharCodes(characteristic4.value as Iterable<int>),
        radix: 16);
    await _savePersistedValues();
  }

  Future<BluetoothService> _findService(
      BluetoothDevice device, String serviceUuid) async {
    List<BluetoothService> services = await device.discoverServices();
    return services
        .firstWhere((service) => service.uuid.toString() == serviceUuid);
  }

  Future<BluetoothCharacteristic> _findCharacteristic(
      BluetoothService service, String characteristicUuid) async {
    return service.characteristics.firstWhere((characteristic) =>
        characteristic.uuid.toString() == characteristicUuid);
  }
}
