import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/home/controller/all_chat_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';

class ContactController extends GetxController {
  List<Contact>? contacts = [];
  List<UserModel>? matchedContacts = [];
  bool isLoading = false;
  @override
  onInit() async {
    // await getContacts();
    // await getLocalContacts();
    super.onInit();
  }

  Future getLocalContacts() async {
    var box = await Hive.openBox('matchedContacts');
    List<dynamic>? getContacts = await box.get('contacts');
    if (getContacts?.isNotEmpty ?? false) {
      matchedContacts = getContacts!.cast<UserModel>();
      update();
    } else {
      await matchContact();
    }
  }

  Future<void> getContacts() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
      update();
    }
  }

  Future<void> matchContact() async {
    matchedContacts!.clear();
    var box = await Hive.openBox('matchedContacts');
    await box.delete('contacts');
    await box.clear();
    print(await box.get('contacts'));
    isLoading = true;
    update();
    // for (var contact in contacts!) {
    //   if (contact.phones.isNotEmpty &&
    //       contact.phones[0].normalizedNumber.isNotEmpty) {
    //     final matchedContact = await FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(contact.phones[0].normalizedNumber)
    //         .get();
    //     if (matchedContact.exists) {
    //       matchedContacts?.add(UserModel.fromMap(matchedContact.data()!));
    //     }
    //   }
    //   update();
    //   if (matchedContacts!.isNotEmpty) {
    //     var box = await Hive.openBox('matchedContacts');
    //     await box.put('contacts', matchedContacts);
    //   }
    // }
    matchedContacts = [
      // TODO: remove
      UserModel(
          name: "name",
          email: "email",
          profilePicUrl: "profilePicUrl",
          uid: "uid",
          mobileNumber: "+918557043313")
    ];
    isLoading = false;
    update();
    // TODO: remove
    Get.put(AllChatController());
  }
}
