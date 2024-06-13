import 'package:flutter/material.dart';
import 'package:todo_list/widget/eco_button.dart';

class EcoDialoag extends StatelessWidget {
  final String? title;
  const EcoDialoag({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title!),
      actions: [
        EcoButton(
          title: "CLOSE",
          onPress: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
