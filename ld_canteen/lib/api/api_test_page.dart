import 'package:flutter/material.dart';

class ApiTestPage extends StatefulWidget {
  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {

  List<String> itemTitles = ['菜品列表','新增菜品','修改菜品','删除菜品'];
  List<Color> itemColors = [Colors.blue,Colors.green,Colors.orange,Colors.red];

  Widget listTitle(int index) {
    var itemTitle = itemTitles[index]; 
    var itemColor = itemColors[index];
    return ListTile(
      title: FlatButton(
        color: itemColor,
        child: Text('$itemTitle',style: TextStyle(color:Colors.white,fontSize: 15)),
        onPressed: (){

        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API测试页'),
      ),
      body: ListView.builder(
        itemCount: itemTitles.length,
        itemBuilder: (_,index) => listTitle(index),
      ),
    );
  }
}