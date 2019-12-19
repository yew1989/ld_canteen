import 'package:flutter/material.dart';
import 'package:ld_canteen/api/page/api_demo_page.dart';
import 'package:ld_canteen/api/page/api_test_page.dart';
import 'package:ld_canteen/page/dishmanage/dish_manage_page.dart';
import 'package:ld_canteen/page/main.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '食堂开发入口',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('食堂测试页入口')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(child: Text('测试页面1'),onPressed: () => pushToPage(context,null)),
            FlatButton(child: Text('测试页面2'),onPressed: () => pushToPage(context,null)),
            FlatButton(child: Text('测试API'),onPressed: () => pushToPage(context,ApiTestPage())),
            FlatButton(child: Text('测试界面'),onPressed: () => pushToPage(context,ApiDemoPage())),
            FlatButton(child: Text('前端 TV 端'),onPressed: () => pushToPage(context,MainPage())),
            FlatButton(child: Text('后台 PC 端'),onPressed: () => pushToPage(context,DishManagePage())),
          ],
        ),
      ),
    );
  }

  // 跳转到相应页面
  void pushToPage(BuildContext context,StatefulWidget page) {
    if(page == null) return;
    final MaterialPageRoute route = MaterialPageRoute(builder: (BuildContext context) => page);
    Navigator.of(context).push(route);
  }
}
