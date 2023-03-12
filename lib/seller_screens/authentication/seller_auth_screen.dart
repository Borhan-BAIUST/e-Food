import 'package:flutter/material.dart';
import 'package:flutter_professional_project/seller_screens/authentication/seller_login_screen.dart';
import 'package:flutter_professional_project/seller_screens/authentication/seller_registration_screen.dart';

class SellerAuthScreen extends StatefulWidget {
  const SellerAuthScreen({Key? key}) : super(key: key);

  @override
  State<SellerAuthScreen> createState() => _SellerAuthScreenState();
}

class _SellerAuthScreenState extends State<SellerAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        //for gradient color combination
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.orange,
              ],
              begin: FractionalOffset(0.0,0.0),
              end: FractionalOffset(1.0,0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.mirror
            )
          ),
        ),

        title: const Text("eFood",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: "Lobster"
          ),
        ),
        centerTitle: true,
        bottom: const TabBar(
            tabs: [
              Tab(
                iconMargin: EdgeInsets.only(bottom: 4),
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: "Log In",
              ),
              Tab(
                iconMargin: EdgeInsets.only(bottom: 4),
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                text: "Registration",
              )

        ],
        indicatorColor: Colors.white,
          indicatorWeight: 4,
        ),
      ) ,
      body:Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient:LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.red,
              Colors.orange,
            ]
          )
        ),
        child:  const TabBarView(
          children: [
            SellerLogInScreen(),
            SellerRegistrationScreen()
          ],
        ),
      ) ,
    ));
  }
}
