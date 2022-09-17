import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';

class ContactController extends GetxController {
  List<Contact>? contacts = [];
  List<UserModel>? matchedContacts = [];
  bool isLoading = false;
  List<UserModel>? users = [];
  @override
  onInit() async {
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
      contacts = await FlutterContacts.getContacts(
          withProperties: true, deduplicateProperties: true);
      update();
    }
  }

  getMarker() async {
    final firebaseUsers =
        await FirebaseFirestore.instance.collection('users').get();
    final allData = firebaseUsers.docs.map((doc) => doc.data()).toList();
    users = allData.map((e) => UserModel.fromMap(e)).toList();
    update();
  }

  Future<void> matchContact() async {
    matchedContacts!.clear();
    var box = await Hive.openBox('matchedContacts');
    await box.delete('contacts');
    await box.clear();
    print(await box.get('contacts'));
    isLoading = true;
    update();
    await getMarker();
    for (var contact in contacts!) {
      for (var user in users!) {
        if (contact.phones.isNotEmpty &&
            contact.phones[0].normalizedNumber.isNotEmpty) {
          if (contact.phones[0].normalizedNumber == user.mobileNumber) {
            matchedContacts!.add(user);
            print(matchedContacts![0].name);
          }
        }
      }
    }
    update();
    if (matchedContacts!.isNotEmpty) {
      var box = await Hive.openBox('matchedContacts');
      await box.put('contacts', matchedContacts);
    }

    isLoading = false;
    update();
  }
}
