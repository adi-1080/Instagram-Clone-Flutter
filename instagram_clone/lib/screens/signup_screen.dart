import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart'; //note: import flutter_svg and not only svg package

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage()async{
    Uint8List? imageGottenFromUser = await pickImage(ImageSource.gallery);
    setState(() {
      _image = imageGottenFromUser;
    });
  }

  void signupuser()async{
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().signupUser(
    email: _emailController.text,
    password: _passwordController.text,
    username: _usernameController.text,
    bio: _bioController.text,
    file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if(result != 'Success'){
      showSnackBar(result, context);
    }
    print(result);
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              Stack(
                children: [
                  _image != null ?
                  CircleAvatar(
                    backgroundImage: MemoryImage(_image!),
                    radius: 70,
                  )
                  : CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://th.bing.com/th/id/OIP.CG70mC-flvJIYFRVmR9FZwAAAA?rs=1&pid=ImgDetMain'),
                    radius: 70,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo_rounded),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter a username',
                  textInputType: TextInputType.text),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Enter your bio',
                  textInputType: TextInputType.text),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPassword: true,
              ),
              SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signupuser,
                child: Container(
                  child: _isLoading ? Center(child: CircularProgressIndicator(color: primaryColor,),)  
                  :Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              Flexible(child: Container(), flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('Dont\'t have an account?'),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
