import 'package:flutter/material.dart';


class RoundedWidget extends StatelessWidget {
  
  final double height;
  final Widget child;
  final double marginTop;
  final double marginBottom;
  final double marginRight;
  final double marginLeft;
  final Color color;
  final double margin;
  RoundedWidget({this.margin,this.color,this.height,this.child,this.marginBottom,this.marginLeft,this.marginRight,this.marginTop});
  
  @override
  Widget build(BuildContext context) {

    EdgeInsetsGeometry mainMargin ;

    if(margin!=null){
      mainMargin = EdgeInsets.all(margin);
    }else{
      mainMargin = EdgeInsets.only(
                top: marginTop,
                right: marginRight,
                bottom: marginBottom,
                left: marginLeft,
              );
    }
    
    return Container(
              margin: mainMargin,
              
              height: height,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: Container(
                  color: color,
                  child: child,
                ),
              ),
            );
  }
}