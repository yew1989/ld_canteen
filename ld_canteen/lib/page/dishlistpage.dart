import 'package:flutter/material.dart';
import 'package:ld_canteen/model/dish.dart';



class DishListPage extends StatefulWidget {
  final List<Dish> dishList;
  DishListPage({Key key,@required this.dishList}) : super(key: key);
  @override
  _DishListPageState createState() => _DishListPageState();
}

class _DishListPageState extends State<DishListPage>  with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  int currentPage = 0;
  bool lastPage = false;
  int totalPage;
  int skip = 0;
  int limit = 10;
  List<Dish> dishList ;

  @override
  void initState() {
    _animationController =AnimationController(
        duration: Duration(microseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    try {
      totalPage = (widget.dishList.length + limit - 1)~/limit;
    } catch (e) {
      //debugPrint(e);
    }
    void _pageChanged(int index){
      setState(() {
        if (index == skip~/limit + 1) {
          _animationController?.forward();
          lastPage = true;
        } else {
          _animationController?.reset();
          lastPage = false;
        }
      });
    }

    Widget _itemBuilder(BuildContext context,int index){
      if ((index+1)*limit <= widget.dishList.length) {
        dishList = widget.dishList.sublist(index*limit,(index+1)*limit);
      }else{
        dishList = widget.dishList.sublist(index*limit);
      }
      
      
      List<Widget> tiles = [];//先建一个数组用于存放循环生成的widget
      Widget content;
      tiles.add(
        new Row(
          children: <Widget>[
            new Text('菜品名称',style: TextStyle(fontSize: 30),),
            new Text('价格（元）',style: TextStyle(fontSize: 30),),
            new Text('操作',style: TextStyle(fontSize: 30),),
          ],
        )
      );
      for(var i = 0; i < dishList.length; i++) {
        var item = dishList[i];
        while (i%2 == 0) {
          
        }
        tiles.add(
          new Container(
            color: Colors.grey,
            child: new Row(
            children: <Widget>[
                new Text(item.name,style: TextStyle(fontSize: 30),),
                new Text(item.price,style: TextStyle(fontSize: 30),),
                RaisedButton.icon(
                  icon: Icon(Icons.gps_fixed,color: Colors.white),
                  onPressed: (){}, 
                  label:Text('修改',style: TextStyle(color: Colors.white),),
                  color: Colors.blue,
                ),
                Padding(padding:  EdgeInsets.all(20.0)),
                RaisedButton.icon(
                  icon: Icon(Icons.delete,color: Colors.white),
                  onPressed: (){}, 
                  label: Text('删除',style: TextStyle(color: Colors.white),),
                  color: Colors.red,
                ),
              ]
            ),
          ),
        );
      }
      content = new Column(
        children: tiles 
      );
      return content;
      
    }


    return 
    // Container(
    //   child: Scaffold(
    //     appBar: new AppBar(
    //       title: new Text("食堂菜单"),
    //       centerTitle: true,
    //     ),
    //     body: 
        Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              itemCount: totalPage,
              onPageChanged: _pageChanged, 
              itemBuilder: _itemBuilder,
              
            )
          ],
      //   ),
      // ),
    );
  }
}