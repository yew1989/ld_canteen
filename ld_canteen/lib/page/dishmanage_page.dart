import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/page/dishlistpage.dart';
import 'package:ld_canteen/page/main.dart';
import 'package:ld_canteen/page/updatedishpage.dart';
import 'package:ld_canteen/page/dart.dart';

class DishManagePage extends StatefulWidget {
  @override
  _DishManagePageState createState() => _DishManagePageState();
}

class _DishManagePageState extends State<DishManagePage> {

  List<Dish> dishList = [];
  
  List<Widget> _tabs() {
    List<Widget> tiles = [];
    //var name = typeTest[index].name;
    for(var item in typeTest){
      var name = item.name;
      tiles.add(
        Tab(child: Text('$name',style: TextStyle(color: Colors.white),),)
      );
    }
    return tiles;
  }

  List<Widget> _tabBarView(){
    List<Widget> tiles = [];
    for (var item in typeTest) {
      // List<Dish> dishList = [];
      API.getDishList((List<Dish> dishes,String msg){
            setState(() {
              dishList = dishes;
            });
          debugPrint(msg);
          debugPrint(dishes.map((f)=>f.toJson()).toList().toString());
          dishList = dishes;
        }, (String msg){
          debugPrint(msg);
        },order:'sort',//limit: limit,skip: skip
      );
      tiles.add(DishListPage(dishList:dishList));
    }
    return tiles;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('菜品管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box,size: 30),
            onPressed: () {

            }
          )
        ],
      ),
      body: DefaultTabController(
        length: typeTest.length,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: _tabs(),
            ),
          actions: <Widget>[
            Padding(padding:  EdgeInsets.all(20.0)),
            IconButton(
              icon: Icon(Icons.settings_applications,size: 30,),
              onPressed: () {
                
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            TabBarView(
              children: _tabBarView(),
            )
            
          ],
        ),
        ),
        
        ), 
        
      
    );
  }
}
