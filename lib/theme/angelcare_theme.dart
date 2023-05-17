import 'package:flutter/material.dart';

extension CustomThemeData on ColorScheme {
  Color get grey1 => const Color(0xffF9F8F9);
  Color get grey2 => const Color(0xffF8F6F5);
  Color get grey3 => const Color(0xffEAEAEA);
  Color get grey4 => const Color(0xffcccccc);
  Color get grey5 => const Color(0xff8B8C8C);
  Color get grey6 => const Color(0xff4F4F4F);
  Color get grey7 => const Color(0xff2D2F30);
  Color get grey8 => const Color(0xff151617);

  Color get info => const Color(0xff0172CB);
  Color get success => const Color(0xff28A138);
  Color get error => const Color(0xffD21C1C);
  Color get warning => const Color(0xffF9971E);
  static double doubleElevation1 = 1.5;
  static double doubleElevation2 = 2;
  static double doubleElevation3 = 2.5;
  Shadow get elevation1 => Shadow(
        color: const Color(0xffB6B6B6).withOpacity(doubleElevation1),
        offset: const Offset(0, 2),
        blurRadius: 4,
      );
  Shadow get elevation2 => Shadow(
        color: const Color(0xffB6B6B6).withOpacity(doubleElevation2),
        offset: const Offset(0, 4),
        blurRadius: 6,
      );
  Shadow get elevation3 => Shadow(
        color: const Color(0xffB6B6B6).withOpacity(doubleElevation3),
        offset: const Offset(0, 8),
        blurRadius: 10,
      );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
// exemplo de uso
// ActionButtonComponent(
//     color: Theme.of(context).colorScheme.grey1,
// );

ThemeData theme = ThemeData(
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color.fromRGBO(45, 46, 131, 1),
    secondary: const Color.fromRGBO(29, 113, 184, 1),
    tertiary: const Color.fromRGBO(243, 245, 249, 1),
  ),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Color.fromRGBO(29, 113, 184, 1),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: Colors.black,
      fontSize: 96,
      letterSpacing: -1.5,
      fontWeight: FontWeight.w300,
      // height: 112.5,
    ),
    headline2: TextStyle(
      color: Color(0xff151617),
      fontSize: 60,
      letterSpacing: -0.5,
      fontWeight: FontWeight.w300,
      // height: 70.31,
    ),
    headline3: TextStyle(
      color: Color(0xff151617),
      fontSize: 48,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
      // height: 56.25,
    ),
    headline4: TextStyle(
      color: Color(0xff151617),
      fontSize: 34,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w400,
      // height: 39.84,
    ),
    headline5: TextStyle(
      color: Color(0xff151617),
      fontSize: 24,
      letterSpacing: 0,
      fontWeight: FontWeight.w300,
      // height: 28.13,
    ),
    headline6: TextStyle(
      color: Color(0xff151617),
      fontSize: 20,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w500,
      // height: 23.44,
    ),
    subtitle1: TextStyle(
      color: Color(0xff151617),
      fontSize: 16,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w400,
      // height: 23.44,
    ),
    subtitle2: TextStyle(
      color: Color(0xff151617),
      fontSize: 14,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w500,
      // height: 23.44,
    ),
    bodyText1: TextStyle(
      color: Color(0xff151617),
      fontSize: 16,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w400,
      // height: 23.44,
    ),
    bodyText2: TextStyle(
      color: Color(0xff151617),
      fontSize: 14,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w400,
      // height: 23.44,
    ),
    button: TextStyle(
      color: Color(0xff151617),
      fontSize: 14,
      letterSpacing: 1.25,
      fontWeight: FontWeight.w500,
      // height: 23.44,
    ),
    caption: TextStyle(
      color: Color(0xff151617),
      fontSize: 12,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
      // height: 23.44,
    ),
    overline: TextStyle(
      color: Color(0xff151617),
      fontSize: 10,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w400,

      // height: 23.44,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    suffixStyle: TextStyle(
      color: Color(0xff959595),
    ),
    prefixStyle: TextStyle(
      color: Color(0xff959595),
    ),
    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.54)),
    filled: true,
    fillColor: Color(0xffF3F5F9),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(0, 0, 0, 0.23),
        style: BorderStyle.solid,
        // color: Colors.blue,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(0, 0, 0, 0.5),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0.0),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.fromLTRB(22, 16, 22, 16),
      ),
      backgroundColor:
          MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> state) {
        if (state.contains(MaterialState.disabled)) {
          return const Color(0xff8B8C8C);
        }
        return const Color.fromRGBO(29, 113, 184, 1);
      }),
      foregroundColor: //text color
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> state) {
        if (state.contains(MaterialState.disabled)) {
          return Colors.white;
        }
        return Colors.white;
      }),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0.0),
      side: MaterialStateProperty.resolveWith<BorderSide?>(
          (Set<MaterialState> state) {
        if (state.contains(MaterialState.disabled)) {
          return const BorderSide(
            color: Color(0xff8B8C8C),
          );
        }
        return const BorderSide(
          color: Color.fromRGBO(29, 113, 184, 1),
        );
      }),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.fromLTRB(22, 16, 22, 16),
      ),
      backgroundColor:
          MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> state) {
        if (state.contains(MaterialState.disabled)) {
          return Colors.transparent;
        }
        return Colors.transparent;
      }),
      foregroundColor: //text color
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> state) {
        if (state.contains(MaterialState.disabled)) {
          return const Color(0xff8B8C8C);
        }
        return const Color.fromRGBO(29, 113, 184, 1);
      }),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0.0),
      foregroundColor: //text color
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> state) {
        if (state.contains(MaterialState.disabled)) {
          return Colors.grey[300]!;
        }
        return const Color.fromRGBO(29, 113, 184, 1);
      }),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(29, 113, 184, 1),
    foregroundColor: Colors.white,
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: CustomThemeData.doubleElevation1,
  ),
  tabBarTheme: const TabBarTheme(
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        width: 2,
        color: Colors.white,
      ),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: CustomThemeData.doubleElevation1,
    selectedItemColor: const Color.fromRGBO(29, 113, 184, 1),
    unselectedItemColor: const Color(0xff959595),
    showUnselectedLabels: true,
    unselectedLabelStyle: const TextStyle(
      color: Color(0xff959595),
    ),
  ),
  toggleButtonsTheme: const ToggleButtonsThemeData(
    fillColor: Color.fromRGBO(29, 113, 184, 1),
    focusColor: Color.fromRGBO(29, 113, 184, 1),
    selectedColor: Colors.white,
    borderColor: Color(0xff8B8C8C),
  ),
  dialogTheme: const DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
    ),
  ),
);

// final Color iconColor = _getIconColor();

Color getIconColor(bool focused) {
  if (focused) {
    return const Color(0xff959595);
  } else {
    return const Color.fromRGBO(29, 113, 184, 1);
  }
}
