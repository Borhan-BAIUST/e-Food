import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,

        ), child:const Center(
          child: Text("ok",style: TextStyle(
            color: Colors.white
          ),),
        ),
        )
      ],
    );
  }
}
class LoadingDialog extends StatelessWidget {
  final String message;
  const LoadingDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content:Container(
        height: 200,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.red),

                ),
              ),
            ) ,
            SizedBox(height: 16,),
            Text(message!+' Please Wait ...')
          ],
        ),
      )
    );
  }
}
