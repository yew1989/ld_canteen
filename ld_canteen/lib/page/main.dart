import 'package:flutter/material.dart';
import 'package:ld_canteen/page/dishmanage_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<String> itemTitles = ['食堂菜单','菜单管理'];

  Widget _itemBuilder(BuildContext context, int index){
    var itemTitle = itemTitles[index];

    return ListTile(
      title: FlatButton(
        padding: EdgeInsets.all(0),
        color: Colors.blue,
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: 
            Text(
              '$itemTitle',
              style: 
                TextStyle(color: Colors.white,fontSize: 100),
            ),
        ),
        onPressed: (){},
      )
    );
      
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('力得食堂'),
        ),
        body: ListView.builder(
          itemCount:itemTitles.length,
          itemBuilder: (_,index) => _itemBuilder(context,index),
        ),
      ),
    );
  }

  void pageHandle(int index,BuildContext context){
    switch(index){

      case 0 :
        {
          
        }break;
      case 1 :
        {
          Navigator.push(context,
                MaterialPageRoute(builder: (context) 
                => DishManagePage()));
          

        }break;
    }
  }

}