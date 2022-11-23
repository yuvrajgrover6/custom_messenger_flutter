import 'dart:developer';

import 'package:custom_messenger/call/model/color_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ThemeController extends GetxController {
  Future<Box> openHiveBox(String boxName) async {
    if (!kIsWeb && !Hive.isBoxOpen(boxName)) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }

    return await Hive.openBox(boxName);
  }

  int? primaryColor;
  int? secondaryColor;
  @override
  onInit() async {
    final box = await openHiveBox('theme');
    final color1 = await box.get('primaryColor');
    final color2 = await box.get('secondaryColor');
    primaryColor = int.parse(color1);
    secondaryColor = int.parse(color2);
    update();
    await box.close();
    log('primaryColor: ${primaryColor.toString()}');
    super.onInit();
  }

  Rx<int> selectedIndex = 0.obs;
  ThemeData primaryTheme() {
    final theme = ThemeData(
        primaryColor: Color(primaryColor!),
        colorScheme: ColorScheme.light(primary: Color(primaryColor!)));
    update();
    return theme;
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
  handleOnTap(int index) async {
    final box = await openHiveBox('theme');
    await box.deleteAll(['primaryColor', 'secondaryColor']);
    await box.clear();
    log(themes[index].primaryColor.toString());
    await box.put('primaryColor', themes[index].primaryColor);
    await box.put('secondaryColor', themes[index].secondaryColor);
    await box.close();
    log('done');
    selectedIndex.value = index;
  }
}
