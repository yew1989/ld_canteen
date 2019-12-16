import 'package:flutter/material.dart';
import 'package:ld_canteen/api/page/api_category_page.dart';

class ApiDemoPage extends StatefulWidget {
  @override
  _ApiDemoPageState createState() => _ApiDemoPageState();
}

class _ApiDemoPageState extends State<ApiDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试页'),
      ),
      body: ListView(
        children:[
          buttonTile('菜品分类管理'),
          buttonTile('广告栏管理'),
          buttonTile('菜品管理'),
          buttonTile('展览位管理'),
        ],
      ),
    );
  }

  Widget buttonTile(String title) {
    return ListTile(
      title: FlatButton(
      padding: EdgeInsets.all(40),
      child: Text(title,style: TextStyle(color: Colors.white,fontSize: 40)),
      color: Colors.blueAccent,
      onPressed: (){
        if(title == '菜品分类管理'){
          pushToPage(context,ApiCategoryPage());
        }
        else if(title == '广告栏管理') {

        }
        else if (title == '菜品管理') { 

        }
        else if(title == '展览位管理') {

        }
      },
    ));
  }

  void pushToPage(BuildContext context,StatefulWidget page) {
    if(page == null) return;
    final MaterialPageRoute route = MaterialPageRoute(builder: (BuildContext context) => page);
    Navigator.of(context).push(route);
  }

}