import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/res/toly_icon.dart';

class HomeNavBar extends StatelessWidget implements PreferredSizeWidget{
  const HomeNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("指南"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("组件"),
        ),
        Switch(value: false, onChanged: (v){}),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.translate),
        ),
        GestureDetector(
          onTap: (){

          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(TolyIcon.iconGithub),
          ),
        )
      ],
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset('assets/images/logo.png')),
      ),
      titleSpacing: 0,
      // TRY THIS: Try changing the color here to a specific color (to
      // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      // change color while the other colors stay the same.
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text("TolyUI",style: TextStyle(color: Theme.of(context).primaryColor),),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
