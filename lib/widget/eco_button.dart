import 'package:flutter/material.dart';

class EcoButton extends StatelessWidget {
  EcoButton(
      {super.key,
      this.title,
      this.isloginButton = false,
      this.onPress,
      this.isloding = false});
  String? title;
  bool? isloginButton;
  VoidCallback? onPress;
  bool? isloding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isloginButton == false ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isloginButton == false ? Colors.black : Colors.black),
        ),
        child: Stack(
          children: [
            Visibility(
              visible: isloding! ? false : true,
              child: Center(
                child: Text(
                  title ?? "button",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color:
                          isloginButton == false ? Colors.black : Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
            Visibility(
              visible: isloding!,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
