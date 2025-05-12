import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData getMyTheme(
  ColorScheme colorScheme,
  BuildContext context,
) =>
    ThemeData(
      useMaterial3: true,
      fontFamily: FontConstants.fontFamily,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          // fixedSize: WidgetStatePropertyAll(
          // Size(
          // MediaQuery.sizeOf(context).width / 2,
          // 65,
          // ),
          // ),

          elevation: WidgetStatePropertyAll(7),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelStyle: getArabLightTextStyle(
          context: context,
          fontSize: 12,
        ),
        hintStyle: getArabLightTextStyle(
          context: context,
          fontSize: 12,
        ),
        isDense: true,
        filled: true,
        suffixIconColor: colorScheme.primary,
        fillColor: colorScheme.onTertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
          borderSide: BorderSide(
            color: colorScheme.secondary,
            width: 1.3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.3,
          ),
        ),
        errorStyle: getArabRegulerTextStyle(
          context: context,
          color: Colors.red,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      canvasColor: colorScheme.surface,
    );
