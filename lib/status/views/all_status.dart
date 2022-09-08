import 'package:flutter/material.dart';

class AllStatus extends StatelessWidget {
  const AllStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            mini: true,
            child: const Icon(Icons.edit),
          ),
          SizedBox(height: height * 0.02),
          FloatingActionButton(
            onPressed: () {},
            isExtended: true,
            child: const Icon(Icons.camera),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Stack(
              children: const [
                CircleAvatar(radius: 30),
                Positioned(
                  right: 4,
                  bottom: 2,
                  child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 10,
                      child: Icon(
                        Icons.add,
                        size: 15,
                      )),
                )
              ],
            ),
            title: const Text('My Status'),
            subtitle: const Text('Tap to add status update'),
          ),
          SizedBox(height: height * 0.02),
          Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: const Text('Recent updates')),
          SizedBox(height: height * 0.02),
          ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return const ListTile(
                leading: CircleAvatar(radius: 30),
                title: Text('Ram Lal'),
                subtitle: Text('30 minutes ago'),
              );
            },
          )
        ],
      ),
    );
  }
}
