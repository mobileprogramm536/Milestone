import 'package:flutter/material.dart';
import 'package:milestone/textfields/custom_textfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class UsernameTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Kullanıcı Adı',
      icon: EvaIcons.personOutline,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    );
  }
}
