import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_professional_project/global/global.dart';
import 'package:flutter_professional_project/seller_screens/authentication/seller_auth_screen.dart';
import 'package:flutter_professional_project/seller_screens/mainScreens/seller_home_screen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer()
  {
    Timer(
        const Duration(seconds: 2),
        () async{

          if(firebaseAuth.currentUser != null)
          {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => const SellersHomeScreen())));
          }
          else
            {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: ((context) => const SellerAuthScreen())));

          }

         }
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          height: 300,
          width: 300,
          child: Image(
            image: AssetImage(
              "assets/images/seller_images/splash_screen.jpg",
            ),
            fit: BoxFit.cover,
            // color: Colors.transparent,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Sell Food in Online",
          style: TextStyle(
              fontFamily:"Lobster", fontSize: 40),
        )
      ],
    ));
  }
}
