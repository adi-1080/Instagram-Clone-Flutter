import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

pickImage(ImageSource mySource)async{
  final ImagePicker myimagePicker = ImagePicker(); // we have instantiated and got the instance of imagepicker class

  XFile? _file = await myimagePicker.pickImage(source: mySource);

  if(_file != null){
    return await _file.readAsBytes();
  } // return File(_file.path); // we are not using this as it is not very accessible on internet
  else{
    print('No image selected');
  }
}

showSnackBar(String content, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content),),
  );
}

displayToastText(String msg){
  Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15,
        );
}