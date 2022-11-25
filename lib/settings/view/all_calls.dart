import 'package:flutter/material.dart';

class AllCalls extends StatelessWidget {
  const AllCalls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {},
            leading: const CircleAvatar(radius: 30),
            title: const Text('Yuvraj Grover'),
            subtitle: const Text('(3) August 12, 13:26'),
            trailing: const Icon(Icons.call),
          );
        },
      ),
    );
  }
}
