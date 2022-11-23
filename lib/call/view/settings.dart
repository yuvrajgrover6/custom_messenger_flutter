import 'package:custom_messenger/call/controller/theme_controller.dart';
import 'package:custom_messenger/call/model/color_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ThemeController());
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.025),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            Text('Select Primary Theme',
                style: TextStyle(fontSize: width * 0.055)),
            SizedBox(height: height * 0.02),
            Container(
              width: width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.themes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: width,
                    child: Obx(
                      () => ListTile(
                        onTap: () => controller.handleOnTap(
                            index: index,
                            primary: colors.primaryColor,
                            secondary: colors.secondaryColor),
                        selected: controller.selectedIndex.value == index,
                        selectedTileColor: Colors.green,
                        selectedColor: Colors.white,
                        tileColor: Colors.grey[200],
                        title: Text(controller.themes[index].themeName),
                        subtitle: Text('Theme #${index + 1}'),
                        trailing: CircleAvatar(
                          backgroundColor: Color(
                              int.parse(controller.themes[index].primaryColor)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
