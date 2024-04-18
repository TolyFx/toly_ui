import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';

class Toast {
  static toast(String msg,
      {duration = const Duration(milliseconds: 600),
        Color? color}) {

    // showToast(msg,position: ToastPosition.bottom,
    //     textPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
    //     backgroundColor: Color(0xfff0f9eb),textStyle: TextStyle(fontSize: 14,color: color));

// // position and second have default value, is optional
    showToastWidget(

        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
              color: Color(0xfff0f9eb)
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16,vertical: 6),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
                  children: [
            Icon(Icons.check,size: 18,color: color,),
            Text(msg,style: TextStyle(fontSize: 14,color: color)),
                  ],
                ),
          ),
        ),position:ToastPosition.bottom);

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(msg),
    //   duration: duration,
    //
    //   backgroundColor: color??Theme.of(context).primaryColor,
    // ));
  }

  static void error(BuildContext context,String msg){
    toast(msg,  color:Colors.red, );
  }

  static  void warning(BuildContext context,String msg){
    toast(msg, color:Colors.orange, );
  }

  static  void success(BuildContext context,String msg){
    toast(msg, color:Colors.green, );
  }

  static  void green(BuildContext context,String msg){
    toast(msg, color:Colors.green, );
  }
}
