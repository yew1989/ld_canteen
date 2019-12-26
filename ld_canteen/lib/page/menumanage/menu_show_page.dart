import 'package:flutter/material.dart';

class MenuShowPage extends StatefulWidget {
  @override
  _MenuShowPageState createState() => _MenuShowPageState();
}

class _MenuShowPageState extends State<MenuShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('今日菜品'),
      ),
      
      body:Container(
        decoration: BoxDecoration(
          image:DecorationImage(
            image: NetworkImage('http://www.fjlead.com/temp/pro_1.jpg'),
            fit: BoxFit.cover
          )
        ),
        child:GridView.count(
          crossAxisCount: 3,
          padding: EdgeInsets.all(20),
          children: <Widget>[

            
          ],
        )
      )
    );
  }

  // Widget _menuShow() {
  //   return     ;
  // }
}