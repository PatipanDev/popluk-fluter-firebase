import 'package:flutter/material.dart';
import 'package:popluk/auth.dart';
import 'package:popluk/pages/home_page.dart';
import 'package:popluk/pages/login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({ Key? key }) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return HomePage();
        }else{
          return const LoginRegisterPage();
        }
      },
      
    );
  }
}