import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_professional_project/global/global.dart';
import 'package:flutter_professional_project/seller_screens/mainScreens/seller_home_screen.dart';
import 'package:flutter_professional_project/utilis/alert_messages.dart';
import 'package:flutter_professional_project/utilis/constants.dart';
import 'package:flutter_professional_project/utilis/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerLogInScreen extends StatefulWidget {
  const SellerLogInScreen({Key? key}) : super(key: key);

  @override
  State<SellerLogInScreen> createState() => _SellerLogInScreenState();
}

class _SellerLogInScreenState extends State<SellerLogInScreen> {
  late final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //form vcalidation  for log in screen

  logInFormValidation() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      logInNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "Please Write email/passweord");
          });
    }
  }

//log in
  logInNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingDialog(message: "Checking Cridential");
        });

    User? currentUser;

    await firebaseAuth
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: error.message.toString());
          });
    });
    //now checking currentuser to log in and go to home screen
    if (currentUser != null) {
      readDataandSetDataLocally(currentUser!).then((value) {
        Navigator.pop(context);//to disepear loading data

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SellersHomeScreen()));

      });
    }
  }

  //read data or retieve data from firebase database and save this data to locally
  Future readDataandSetDataLocally(User currentUser) async {
    //here reteriving the data and we can use this data untill seller log out
    await FirebaseFirestore.instance
        .collection("sellers" /*samename as register*/)
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      await sharedPreferences!.setString("sellerUId", currentUser.uid);
      await sharedPreferences!
          .setString("sellerEmail", snapshot.data()!["sellerEmail"]);
      await sharedPreferences!.setString(
          "sellerName",
          snapshot.data()![
              "sellerName"]); //sellerName receiving this firestor database
      await sharedPreferences!
          .setString("sellerImageUrl", snapshot.data()!["sellerImageUrl"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            const SizedBox(
              height: 22,
            ),
            SizedBox(
                height: 200,
                width: double.maxFinite,
                child: SvgPicture.asset(
                  "assets/images/seller_images/login.svg",
                  color: Colors.white,
                )),
            const SizedBox(
              height: 22,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                        controller: _emailController,
                        iconData: Icons.mail,
                        hintText: "Enter Your Email",
                        levelText: "Email",
                        isObscure: false,
                        enabled: true),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextFormField(
                        hintText: "Enter Your Password",
                        levelText: "Password",
                        controller: _passwordController,
                        iconData: Icons.lock,
                        enabled: true,
                        isObscure: true),
                    const SizedBox(
                      height: 22,
                    ),
                    Container(
                      height: 60,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: ElevatedButton(
                        onPressed: () {
                          logInNow();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink),
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            //fontFamily:Constants.primaryTextFont
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                        onPressed: (){
                          //implement forget password
                        },
                        child:const Text("Forget Password ?",
                        style: TextStyle(
                          color: Colors.white
                        ),
                        ) ),
                    const Text(
                      "By Log In you are agree to our Privacy and policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: Constants.primaryTextFont),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
