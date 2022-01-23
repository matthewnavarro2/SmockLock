import 'package:flutter/cupertino.dart';

class DeviceInfo{
  static double width = 0;
  static double height = 0;

  DeviceInfo (BuildContext context){
    width = getWidth(context);
    height = getHeight(context);

  }

  double getWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  double getHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }


}