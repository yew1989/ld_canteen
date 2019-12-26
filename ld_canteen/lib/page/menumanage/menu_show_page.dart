import 'package:flutter/material.dart';

class MenuShowPage extends StatefulWidget {
  @override
  _MenuShowPageState createState() => _MenuShowPageState();
}

class _MenuShowPageState extends State<MenuShowPage> {

  //选取分类
  var types = [{'name':'选择展示框内容分类','value':'xxxx'},{'name':'菜品类型','value':'category'},{'name':'广告图片','value':'banner'}];

  String _typeValue = 'xxxx';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  

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
            _card(),

          ],
        )
      )
    );
  }

  Widget _card(){
    return Card(
      child: 
      Row(
        children: <Widget>[
          DropdownButton<String>(
            items: types.map((type) {
              return DropdownMenuItem<String>(
                child: Text(
                  type['name'],
                  style: TextStyle(fontSize: 30),
                ),
                value: type['value'],
              );
            }).toList(),
            onChanged: (String category) {
              setState(() {
                _typeValue = category;
              });
            },
            value: _typeValue,
            iconSize: 50,
          ),
          // DropdownButton<String>(
          //   items: categories.map((category) {
          //     return DropdownMenuItem<String>(
          //       child: Text(
          //         '${category.name}',
          //         style: TextStyle(fontSize: 30),
          //       ),
          //       value: category.objectId,
          //     );
          //   }).toList(),
          //   onChanged: (String category) {
          //     setState(() {
          //       categoryObjectId = category;
          //     });
          //   },
          //   value: categoryObjectId,
          //   iconSize: 50,
          // ),
        ],
      )
      

    );

  }
}