import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';

class NavigationService extends ChangeNotifier{
  
  Future<dynamic> navigateTo(Widget screen){
    return navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => screen));
  }

  Future<dynamic> navigateToReplace(Widget screen){
    return navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  void goBack(){
    return navigatorKey.currentState!.pop();
  }

  void popUntil(Widget screen){
    return navigatorKey.currentState!.popUntil(ModalRoute.withName(screen.toString()));
  }

  Future<void> pushAndRemoveUntil(Widget screen){
    return navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => screen), (route) => false);
  }
}