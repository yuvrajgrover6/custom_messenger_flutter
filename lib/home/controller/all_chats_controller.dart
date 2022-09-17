import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AllChatController extends GetxController {
  List<UserModel> users = [];
  AuthController authController = Get.find();
  List<List> bothNumbers = [];
  List<UserModel> matchedContacts = [];
  @override
  void onInit() async {
    await getChatRooms();
    update();
    print(bothNumbers);
    super.onInit();
  }

  Future getChatRooms() async {
    List list = [];
    List temp = [];
    var box = await Hive.openBox('matchedContacts');
    List<dynamic>? getContacts = await box.get('contacts');

    if (getContacts?.isNotEmpty ?? false) {
      temp = getContacts!;
    }
    matchedContacts = temp.cast<UserModel>();

    for (var contact in matchedContacts) {
      if (contact.mobileNumber == authController.myUser.value!.mobileNumber) {
        matchedContacts.remove(contact);
      }
      list.add(authController.myUser.value!.mobileNumber);
      list.add(contact.mobileNumber);

      list.sort((a, b) => a.compareTo(b));
      print(list);
      bothNumbers.add(list);
    }
  }
}
