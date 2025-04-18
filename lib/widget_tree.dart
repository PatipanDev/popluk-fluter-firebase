import 'package:flutter/material.dart';
import 'package:popluk/services/auth.dart';
import 'package:popluk/screens/index_page.dart';
import 'package:popluk/screens/login_or_signup_page.dart';
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
          return IndexPage();
        }else{
          return const LogInOrSignUpPage();
        }
      },
      
    );
  }
}