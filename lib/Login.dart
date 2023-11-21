import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horse/Home.dart';
import 'package:horse/helper/My_Button.dart';
import 'package:horse/helper/My_Methods.dart';
import 'package:horse/helper/my_helper.dart';
import 'package:horse/model/User_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  DatabaseReference databaseReference=FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: my_helper.backgroundColor,
      body: Center(
        child: My_Btn(txt: 'Login with google', btn_color: my_helper.btn_color, btn_size: 200, gestureDetector: GestureDetector(onTap: () {
          googleSignIn();
        },)),
      ),
    );
  }


  googleSignIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential= await FirebaseAuth.instance.signInWithCredential(credential);

    if(userCredential==null)
    {
      EasyLoading.showError('loging failed');
    }
    else{
      User_model? model=await my_Methods.getUserModel();
      if(model!=null) {
        EasyLoading.showSuccess('login success');
        Get.to(Home(),transition: Transition.circularReveal,duration: Duration(seconds: 1));

      }
      else{
        EasyLoading.showSuccess('login success');
        User_model model=User_model(id: FirebaseAuth.instance.currentUser!.uid, name: userCredential.user!.displayName.toString(), phone: userCredential.user!.phoneNumber.toString(),
             email: userCredential.user!.email.toString(), address: '',);
        databaseReference.child(my_helper.users_table).child(model.id).set(model.toJson());


        Get.to(Home(),transition: Transition.circularReveal,duration: Duration(seconds: 1));
      }
    }
  }

}
