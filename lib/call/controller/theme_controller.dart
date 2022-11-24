import 'dart:developer';

import 'package:custom_messenger/call/model/color_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';

import '../view/restart_widget.dart';
import 'local_db_controller.dart';

enum colors {
  primaryColor,
  secondaryColor,
}

class ThemeController extends GetxController {
  static Map defaultSettings = {
    colors.primaryColor: '0xFF2196F3',
    colors.secondaryColor: '0xFFFFFFFF',
  };
  final Map<colors, Rx<Object>> settings =
      defaultSettings.map((key, value) => MapEntry(key, Rx(value)));
  String get primaryColor => settings[colors.primaryColor]!.value as String;
  String get secondaryColor => settings[colors.secondaryColor]!.value as String;
  Box get colorsLocalDB => LocalDBController.instance.colorsLocalDB;
  ThemeController();

  @override
  onInit() async {
    // colorsLocalDB.clear();
    // colorsLocalDB
    //     .deleteAll([colors.primaryColor.name, colors.secondaryColor.name]);
    super.onInit();
    await initializeSettings();
    getSelectedIndex();
  }

  Rx<int> selectedIndex = 0.obs;
  getSelectedIndex() {
    switch (primaryColor) {
      case '0xFF2196F3':
        selectedIndex.value = 0;
        break;
      case '0xff000000':
        selectedIndex.value = 1;
        break;
      case '0xff0000ff':
        selectedIndex.value = 2;
        break;
      case '0xffff0000':
        selectedIndex.value = 3;
        break;
      case '0xFF1B5E20':
        selectedIndex.value = 4;
        break;
      case '0xFFCFD8DC':
        selectedIndex.value = 5;
        break;
      default:
        break;
    }
  }

  ThemeData primaryTheme() {
    final theme = ThemeData(
        primaryColor: Color(int.parse(primaryColor)),
        colorScheme:
            ColorScheme.light(primary: Color(int.parse(primaryColor))));
    update();
    return theme;
  }

  initializeColor(colors setting) {
    final color = colorsLocalDB.get(setting.name);
    if (color != null) {
      settings[setting]!.value = color;
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
        themeName: 'Primary-Theme',
        primaryColor: '0xFF2196F3',
        secondaryColor: '0xFFFFFFFF'),
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
  Future<void> handleOnTap(
      {required int index,
      required colors primary,
      required colors secondary}) async {
    selectedIndex.value = index;
    settings[primary]!.value = themes[index].primaryColor;
    settings[secondary]!.value = themes[index].secondaryColor;
    await colorsLocalDB.put(primary.name, settings[primary]!.value);
    await colorsLocalDB.put(secondary.name, settings[secondary]!.value);
    update();
  }

  reset() async {
    await colorsLocalDB.clear();
    initializeSettings();
  }

  List<String> iconNames = [
    "icon_1",
    "icon_2",
    "icon_3",
    "icon_4",
    "icon_5",
    "icon_6",
    "MainActivity",
  ];

  Future<void> changeAppIcon(int index) async {
    try {
      if (await DynamicIconFlutter.supportsAlternateIcons) {
        await DynamicIconFlutter.setAlternateIconName("icon_${index + 1}");
        print("App icon change successful");
        return;
      }
    } on PlatformException catch (e) {
      if (await DynamicIconFlutter.supportsAlternateIcons) {
        await DynamicIconFlutter.setAlternateIconName(null);
        print("Change app icon back to default");
        return;
      } else {
        print("Failed to change app icon");
      }
    }
  }
}
