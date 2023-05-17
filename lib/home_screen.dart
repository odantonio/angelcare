import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/bt/bluetooth_connection.dart';

class HomeScreenn extends StatefulWidget {
  const HomeScreenn({Key? key, required this.bleServiceReader})
      : super(key: key);

  final BleServiceReader bleServiceReader;

  @override
  State<HomeScreenn> createState() => _HomeScreennState();
}

class _HomeScreennState extends State<HomeScreenn> {
  String selectedService = '';
  List<Result> storedResults = [];
  List<charts.Series<Result, DateTime>> chartData = [];
  bool isDeviceConnected = false;

  late final heartValue;
  late final tempValue;
  late final service3Value;
  late final service4Value;

  @override
  void initState() {
    super.initState();
    loadStoredResults();
    startBleService();

    // Listen to service value changes and update the UI
    widget.bleServiceReader.heartValueNotifier.addListener(_updateUI);
    widget.bleServiceReader.tempValueNotifier.addListener(_updateUI);
    widget.bleServiceReader.service3ValueNotifier.addListener(_updateUI);
    widget.bleServiceReader.service4ValueNotifier.addListener(_updateUI);
  }

  @override
  void dispose() {
    // Clean up listeners
    widget.bleServiceReader.heartValueNotifier.removeListener(_updateUI);
    widget.bleServiceReader.tempValueNotifier.removeListener(_updateUI);
    widget.bleServiceReader.service3ValueNotifier.removeListener(_updateUI);
    widget.bleServiceReader.service4ValueNotifier.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    setState(() {
      // Update the UI when service values change
      heartValue = int.parse(
              widget.bleServiceReader.heartValueNotifier.value as String,
              radix: 16)
          .toDouble();
      tempValue = int.parse(
              widget.bleServiceReader.tempValueNotifier.value as String,
              radix: 16)
          .toDouble();
      service3Value = int.parse(
              widget.bleServiceReader.service3ValueNotifier.value as String,
              radix: 16)
          .toDouble();
      service4Value = int.parse(
              widget.bleServiceReader.service4ValueNotifier.value as String,
              radix: 16)
          .toDouble();
    });
  }

  Future<void> loadStoredResults() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/stored_results.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        final results = jsonList
            .map((e) => Result.fromJson(e as Map<String, dynamic>))
            .toList();
        setState(() {
          storedResults = results;
          chartData = [
            charts.Series<Result, DateTime>(
              id: 'Stored Results',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (result, _) => result.timestamp,
              measureFn: (result, _) => result.value,
              data: storedResults,
            ),
          ];
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading stored results: $e');
      }
    }
  }

  Future<void> startBleService() async {
    try {
      await widget.bleServiceReader.start();
      widget.bleServiceReader.onServiceValuesUpdated = () {
        setState(() {
          selectedService = widget.bleServiceReader.getSelectedService();
        });
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error starting BLE service: $e');
      }
    }
  }

  Future<void> connectToDevice() async {
    try {
      final BluetoothDevice myDevice =
          await widget.bleServiceReader.findDevice();

      await myDevice.connect();

      setState(() {
        isDeviceConnected = true;
      });

      // Read data from the device and save it
      final int heartValue = widget.bleServiceReader.heartValueNotifier.value;
      final int tempValue = widget.bleServiceReader.tempValueNotifier.value;
      final int service3Value =
          widget.bleServiceReader.service3ValueNotifier.value;
      final int service4Value =
          widget.bleServiceReader.service4ValueNotifier.value;

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/device_data.txt');

      final data =
          'Heart Value: $heartValue\nTemp Value: $tempValue\nService 3 Value: $service3Value\nService 4 Value: $service4Value';

      await file.writeAsString(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Device data saved to file.'),
        ),
      );
    } catch (e) {
      // Handle any errors that occur during the connection or data reading process
      if (kDebugMode) {
        print('Error connecting to device: $e');
      }
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error connecting to device: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              connectToDevice();
            },
            icon: const Icon(Icons.bluetooth),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selected Service: ${widget.bleServiceReader.getSelectedService()}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Container(
            height: 300,
            padding: const EdgeInsets.all(16.0),
            child: charts.TimeSeriesChart(
              chartData,
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openServiceMenu();
        },
        child: const Icon(Icons.menu),
      ),
    );
  }

  void openServiceMenu() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Service'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Heart'),
                  onTap: () {
                    setState(() {
                      widget.bleServiceReader.setSelectedService('Heart');
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Temperature'),
                  onTap: () {
                    setState(() {
                      widget.bleServiceReader.setSelectedService('Temperature');
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Service 3'),
                  onTap: () {
                    setState(() {
                      widget.bleServiceReader.setSelectedService('Service 3');
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Service 4'),
                  onTap: () {
                    setState(() {
                      widget.bleServiceReader.setSelectedService('Service 4');
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Result {
  final DateTime timestamp;
  final double value;

  Result({required this.timestamp, required this.value});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      timestamp: DateTime.parse(json['timestamp'] as String),
      value: json['value'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
    };
  }
}
