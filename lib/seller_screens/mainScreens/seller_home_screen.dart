import 'package:flutter/material.dart';
import 'package:flutter_professional_project/global/global.dart';
import 'package:flutter_professional_project/seller_screens/authentication/seller_auth_screen.dart';
import 'package:flutter_professional_project/seller_screens/mainScreens/add_item_screens.dart';
class SellersHomeScreen extends StatefulWidget {
  const SellersHomeScreen({Key? key}) : super(key: key);

  @override
  State<SellersHomeScreen> createState() => _SellersHomeScreenState();
}

class _SellersHomeScreenState extends State<SellersHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          sharedPreferences!.getString("sellerName")!,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                firebaseAuth.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SellerAuthScreen()));
              },
              child: Text("Log Out"),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemScreen()));
              },
              child: Text("Create  Food"),
            ),
          ],
        ),
      ),
    );
  }
}
