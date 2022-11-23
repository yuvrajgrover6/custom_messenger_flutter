import 'dart:developer';

import 'package:custom_messenger/call/model/color_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'local_db_controller.dart';

enum colors {
  primaryColor,
  secondaryColor,
}

class ThemeController extends GetxController {
  static Map defaultSettings = {
    colors.primaryColor: Colors.blue,
    colors.secondaryColor: Colors.white,
  };
  final Map<colors, Rx<Object>> settings =
      defaultSettings.map((key, value) => MapEntry(key, Rx(value)));
  Color get primaryColor => settings[colors.primaryColor]!.value as Color;
  Box get colorsLocalDB => LocalDBController.instance.colorsLocalDB;
  ThemeController();

  @override
  onInit() async {
    super.onInit();
    initializeSettings();
  }

  Rx<int> selectedIndex = 0.obs;
  ThemeData primaryTheme() {
    final theme = ThemeData(
        primaryColor: Color(primaryColor.value),
        colorScheme: ColorScheme.light(primary: Color(primaryColor.value)));
    update();
    return theme;
  }

  initializeColor(colors setting) {
    final color = colorsLocalDB.get(setting.name);
    if (color != null) {
      settings[setting]!.value = Color(color);
    } else {
      settings[setting]!.value = defaultSettings[setting];
    }
  }

  initializeSettings() {
    initializeColor(colors.primaryColor);
    initializeColor(colors.secondaryColor);
  }

  final List<ThemeModel> themes = [
    ThemeModel(
        themeName: 'Black-White',
        primaryColor: '0xff000000',
        secondaryColor: '0xffffffff'),
    ThemeModel(
        themeName: 'Blue-White',
        primaryColor: '0xff0000ff',
        secondaryColor: '0xffffffff'),
    ThemeModel(
        themeName: 'Red-White',
        primaryColor: '0xffff0000',
        secondaryColor: '0xffffffff'),
    ThemeModel(
        themeName: 'Green-White',
        primaryColor: '0xFF1B5E20',
        secondaryColor: '0xffffffff'),
    ThemeModel(
        themeName: 'Sky-Black',
        primaryColor: '0xFFCFD8DC',
        secondaryColor: '0xFF000000')
  ];
  handleOnTap(
      {required int index,
      required colors primary,
      required colors secondary}) async {
    selectedIndex.value = index;
    settings[primary]!.value = int.parse(themes[index].primaryColor);
    settings[secondary]!.value = int.parse(themes[index].secondaryColor);
    await colorsLocalDB.put(primary.name, settings[primary]!.value);
    await colorsLocalDB.put(secondary.name, settings[secondary]!.value );
    update();
  }

  reset() async {
    await colorsLocalDB.clear();
    initializeSettings();
  }
}
