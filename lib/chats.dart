import 'package:flutter/material.dart';
class Chats extends StatelessWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => Container(
          width: 200,
          height: 200,
          color: Colors.black,
        ),
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
        itemCount: 20);
  }
}
