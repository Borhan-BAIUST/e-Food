import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController ? controller;
  final IconData? iconData;
  final String hintText;
  final String levelText;
  bool isObscure = true;
//this is for give access to user to texfield or not
  bool ? enabled = true;
 CustomTextFormField({Key? key,
   required this.controller,
   required this.iconData,
   required this.hintText,
   required this.levelText,
 required this.isObscure,
 required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObscure,
        cursorColor:Theme.of(context).primaryColor ,
        decoration: InputDecoration(
        //  contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          prefixIcon: Icon(
            iconData,
            color: Colors.red,
          ),
          hintText: hintText,
          hintStyle:TextStyle(color: Colors.black,fontSize: 16),
          labelText: levelText,
          labelStyle:TextStyle(color: Colors.black,fontSize: 16),
          focusColor: Theme.of(context).primaryColor
        ),
      ),
    );
  }
}


