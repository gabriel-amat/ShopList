import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomNotification{

  void showFCMNotifications({required BuildContext context, required String body, required String title}){
    asuka.showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        title: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor
          ),
        ),
        content: Text(body,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              primary: AppColors.textColor,
            ),
            onPressed: (){
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text("Fechar",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ],
      )
    );
  }

  void showDialogWaring({required BuildContext context, required String text, Widget? page, required String buttonText}){
    asuka.showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        title: Icon(Icons.error, color: Colors.yellow, size: 45,),
        content: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300
          ), 
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            onPressed: (){
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text("Fechar"),
          ),
          page != null ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue
            ),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder:(context)=>page)
              );
            },
            child: Text(buttonText,
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ) : Container()
        ],
      )
    );
  }

  void showSnackErrorWithIcon({required String text, IconData? icon, int? durationInSeconds}){

    asuka.removeCurrentSnackBar();
    
    asuka.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: durationInSeconds ?? 3),
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon ?? Icons.error, size: 30, color: Colors.white,),
          SizedBox(width: 8,),
          Flexible(
            child: Text(text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void showSnackSuccessWithIcon({required String text, IconData? icon}){
    
    asuka.removeCurrentSnackBar();

    asuka.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon ?? Icons.check_circle, size: 30, color: Colors.white,),
          SizedBox(width: 8,),
          Flexible(
            child: Text(text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void showLoadingSnack({required String text}){
    
    asuka.removeCurrentSnackBar();

    asuka.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.yellow[800],
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(width: 8,),
          Flexible(
            child: Text(text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void showSnackWarning({required String text}){
    
    asuka.removeCurrentSnackBar();

    asuka.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      backgroundColor: AppColors.textColor,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.error, size: 30, color: Colors.white,),
          SizedBox(width: 8,),
          Flexible(
            child: Text(text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    ));
  }

}