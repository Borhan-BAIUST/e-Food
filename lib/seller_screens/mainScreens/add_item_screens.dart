import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_professional_project/utilis/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../global/global.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  //Pick Food image
  File? _foodImage;
  final picker = ImagePicker();
  //firebasreferenc

  final postRef = FirebaseDatabase.instance.ref().child("sellerUid");
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  bool isLoading = false;

  //create controller for foodstextformfield
  final TextEditingController _foodTitleController = TextEditingController();
  final TextEditingController _foodDescriptionController = TextEditingController();
  final TextEditingController _foodPriceController = TextEditingController();

  //get Image from gallery
  Future getGalleryImage ()async{

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _foodImage = File(pickedFile.path);
      } else {
      }
    });
  }

  //get image from Camera
  Future getCameraImage ()async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _foodImage = File(pickedFile.path);
      } else {
      }
    });
  }
  //create dialog for get image
  void dialog(context){
    showDialog(context: context, builder: (c){
      return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: SizedBox(
          height: 120,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  getCameraImage();
                  Navigator.pop(context);
                },
                child: const ListTile(
                    leading: Icon(Icons.camera), title: Text("Camera")),
              ),
              InkWell(
                onTap: () {
                  getGalleryImage();
                  Navigator.pop(context);
                },
                child: const ListTile(
                    leading: Icon(Icons.photo_library_outlined),
                    title: Text("Gallery")),
              )
            ],
          ),
        ),
      );

    });

  }
  //get data

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
       appBar: AppBar(
         title: Text(
           "${sharedPreferences!.getString("sellerName")!} Items",
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
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8,right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8,),
                InkWell(
                  onTap: (){
                    dialog(context);
                  },
                  child: Center(
                    child: SizedBox(
                      child: _foodImage !=null?
                      ClipRRect(
                        child: Image.file(
                          _foodImage!.absolute,
                          //to get image path
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                          :
                      Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width:MediaQuery.of(context).size.width,
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
                            ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),

                        ),
                        child: const Center(
                          child: Icon(Icons.camera_alt,
                          color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22,),
                CustomTextFormField(
                    controller: _foodTitleController,
                    hintText:"Enter Your Food Name",
                    levelText:"Title",
                    isObscure: false,
                    enabled:true,
                  iconData: null,),
                const SizedBox(height: 8,),
                CustomTextFormField(
                  controller: _foodDescriptionController,
                  hintText:"Enter Your Food Description",
                  levelText:"Description" ,
                  isObscure: false,
                  enabled:true,
                  iconData: null,),
                const SizedBox(height: 8,),
                CustomTextFormField(
                  controller: _foodPriceController,
                  hintText:"Enter Your Food Price",
                  levelText:"Price" ,
                  isObscure: false,
                  enabled:true,
                  iconData: null,),
                const SizedBox(height: 22,),
                Container(
                  height: 60,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30)),
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink),
                    child: const Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        //fontFamily:Constants.primaryTextFont
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) ,
      ),
    );
  }
}
