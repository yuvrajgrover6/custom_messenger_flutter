import 'package:flutter/material.dart';

class AllCalls extends StatelessWidget {
  const AllCalls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return const ListTile(
            leading: CircleAvatar(radius: 30),
          );
        },
      ),
    );
  }
}
