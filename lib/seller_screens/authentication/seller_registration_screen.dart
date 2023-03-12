import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_professional_project/seller_screens/mainScreens/seller_home_screen.dart';
import 'package:flutter_professional_project/utilis/alert_messages.dart';
import 'package:flutter_professional_project/utilis/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/global.dart';

class SellerRegistrationScreen extends StatefulWidget {
  const SellerRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<SellerRegistrationScreen> createState() =>
      _SellerRegistrationScreenState();
}

class _SellerRegistrationScreenState extends State<SellerRegistrationScreen> {

  ///to pick image
  final ImagePicker _imagePicker = ImagePicker();
  XFile? imageFile;

  ///create variable for seller message url
  String sellerImageUrl = '';
  String completeAddress ='';


  ///for registration formfield
  late final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  //reference for firebaseStorage
  fStorage.Reference? reference;
  //late final FirebaseAuth? firebaseAuth; it has declared globally

  //create instance for location
  Position? position;
  List<Placemark>? placeMarks;
  LocationPermission? permission;

  //to get image from gallery for registration
  Future<void> getGalleryImage() async {
    imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile;
    });
  }

  //method for get location
  getCurrentLocation() async {
    permission = await Geolocator
        .requestPermission(); //this is for permission to get location

    Position newPosition = await Geolocator.getCurrentPosition(
      //to get exact location for user
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark pMark = placeMarks![0];

    //to get textual address like kandirpar,monohorpur
     completeAddress = '${pMark.subThoroughfare},'
        '${pMark.thoroughfare},'
        '${pMark.subLocality},'
        '${pMark.locality},'
        '${pMark.subAdministrativeArea},${pMark.administrativeArea},${pMark.postalCode}';
    //passing complete address to location controller so that it show in location text field
    _locationController.text = completeAddress;
  }

  //this function is form validation manually
  Future<void> formValidation() async {

    if (imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "Please Select an Image");
          });
    }
    else
      {

      if (_passwordController.text == _confirmPasswordController.text)

      {
        //may be both field can be empty the it will match for this reason empty check
        if (
        _confirmPasswordController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty &&
            _nameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _locationController.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) {
                return const LoadingDialog(message: "Registering your account");
              });


          //giving some unique name foe every photos
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          //creating firebase refeences
          reference = fStorage.FirebaseStorage.instance
              .ref()
              .child("sellers")
              .child(fileName);

          //uploading images
          fStorage.UploadTask uploadTask =
              reference!.putFile(File(imageFile!.path));
         // to get download url
          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() => {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url ;
            //save information to firebase storage

            authenticateSellersAndSignUp();
          });


        }

        else {
          showDialog(
              context: context,
              builder: (c) {
                return const ErrorDialog(message: "Input required info");
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(message: "Confirm your Password");
            });
      }
    }
  }
//seller authentication in sign up
  void authenticateSellersAndSignUp()async
  {
    User? currentUser;

firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),).then((auth){
          currentUser=auth.user;
    } ).catchError((error){

      Navigator.pop(context);
      showDialog(context: context, builder: (c){
        return ErrorDialog(message: error.mssage.toString());
      });

    });
//check user is created or not
  if(currentUser != null){

    saveDataToFIrestore(currentUser!).then((value) {
      Navigator.pop(context);
      //navigate user to home page
      Route newRoute = MaterialPageRoute(builder: (c)=>const SellersHomeScreen());
      Navigator.pushReplacement(context, newRoute);

    });
  }


  }


  //TO save data in firestore
  Future saveDataToFIrestore(User currentUser) async{
    //for unique id and set information to direStore
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      //it can be any name
      "sellerUId":currentUser.uid,
      "sellerEmail":currentUser.email,
      "sellerName":_nameController.text.trim(),
      "sellerImageUrl":sellerImageUrl,
      "sellerPhoneNumber":_phoneController.text.trim(),
      "sellerAdress": completeAddress,
      "status":"approved",
      "earnings":"0.0",
      "latitude":position!.latitude,
      "longitude":position!.longitude
    });

    //save data locally using shared preferences
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString( "sellerUId",currentUser.uid);
    await sharedPreferences!.setString( "sellerEmail",currentUser.email.toString());
    await sharedPreferences!.setString("sellerName",_nameController.text.trim(),);
    await sharedPreferences!.setString("sellerImageUrl",sellerImageUrl);



  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.00, right: 8.00),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage: imageFile == null
                      ? null
                      : FileImage(File(imageFile!.path)),
                  child: imageFile == null
                      ? Center(
                          child: Icon(
                            Icons.add_photo_alternate_sharp,
                            color: Colors.grey,
                            size: MediaQuery.of(context).size.width * 0.10,
                          ),
                        )
                      : null),
            ),
            const SizedBox(
              height: 8,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    hintText: "Enter Your Name",
                    levelText: "Name",
                    controller: _nameController,
                    iconData: Icons.person,
                    enabled: true,
                    isObscure: false,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextFormField(
                    hintText: "Enter Your Email",
                    levelText: "Email",
                    controller: _emailController,
                    iconData: Icons.email,
                    enabled: true,
                    isObscure: false,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextFormField(
                    hintText: "Enter Your Mobile Number",
                    levelText: "Mobile Number",
                    controller: _phoneController,
                    iconData: Icons.phone,
                    enabled: true,
                    isObscure: false,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextFormField(
                      hintText: "Enter Your Password",
                      levelText: "Password",
                      controller: _passwordController,
                      iconData: Icons.lock,
                      enabled: true,
                      isObscure: true),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextFormField(
                    hintText: "Confirm Your Password",
                    levelText: "Confirm password",
                    controller: _confirmPasswordController,
                    iconData: Icons.lock,
                    enabled: true,
                    isObscure: true,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextFormField(
                    hintText: "Resturant Location",
                    levelText: "Location",
                    controller: _locationController,
                    iconData: Icons.my_location,
                    enabled: true,
                    isObscure: false,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 40,
                    width: double.maxFinite,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        getCurrentLocation();
                      },
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Get My Current Location",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 60,
              width: double.maxFinite,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: ElevatedButton(
                onPressed: () {
                  formValidation();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
