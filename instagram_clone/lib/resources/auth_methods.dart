import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';

    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file != null){
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics',file,false);
        //add user to our database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });

        //if you do not want to use uid (the unique id) anywhere then directly add the user to our database
        // await _firestore.collection('users').add({
        //   'username': username,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });
        res = 'Success';
        displayToastText('Successfully registered user');
      }
    } on FirebaseAuthException catch(err){
      if(err.code == 'invalid-email'){
        res = 'The email is badly formatted';
      } else if(err.code == 'weak-password'){
        res = 'Password should be at least 6 characters';
      }
    }
    
    catch(err){
      res = err.toString();
    }
    return res;
  }

  //logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  })async{
    String res = 'Some error occured';

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        UserCredential _cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'Success';
      }else{
        displayToastText('Please enter all the fields');
      }
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        displayToastText('User not found');
      } else if(e.code == 'wrong-password'){
        displayToastText('Wrong password');
      }
    }
    
    catch(err){
      res = err.toString();
    }
    return res; 
  }
}
