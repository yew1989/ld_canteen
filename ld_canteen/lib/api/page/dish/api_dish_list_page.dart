import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/edit_delete_button.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/api/page/category/api_category_edit_page.dart';
import 'package:ld_canteen/api/page/dish/api_dish_edit_page.dart';
import 'package:ld_canteen/model/dish.dart';

class ApiDishListPage extends StatefulWidget {

  final String categoryId;

  const ApiDishListPage({Key key, this.categoryId}) : super(key: key);
  @override
  _ApiDishListPageState createState() => _ApiDishListPageState();
}

class _ApiDishListPageState extends State<ApiDishListPage> {

  List<Dish> dishes = [];
  String categoryId = '';

  @override
  void initState() {

    this.categoryId = widget.categoryId;

    getDishesList(categoryId);
    // 监听 ‘REFRESH’ 刷新页面通知
    EventBus().on('REFRESH', (_){
      getDishesList(categoryId);
    });
    super.initState();
  }

  @override
  void dispose() {
    // 取消监听 ‘REFRESH’ 刷新页面通知
    EventBus().off('REFRESH');
    super.dispose();
  }

  // 请求菜品分类数据
  void getDishesList(String categoryObjectId) {
    
    API.getDishList((List<Dish> dishes,String msg){

      setState(() {
        this.dishes = dishes;
      });

      debugPrint(msg);

    }, (String msg){

      debugPrint(msg);

    },objectId:categoryObjectId);
  }

  // 删除菜品
  void deleteDish(Dish dish) {

    // 删除菜品
    API.deleteDish(dish.objectId, (String msg){

      debugPrint(msg);
      // 刷新列表
      getDishesList(categoryId);

    }, (String msg) {

      debugPrint(msg);

    });
  }

  // 更新菜品状态
  void updateDishWithShowState(Dish dish,bool isShow) {

    dish.isShow = isShow;

    API.updateDish(dish.objectId, dish, (_,msg){

      getDishesList(categoryId);

    }, (_){

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: dishes?.length ?? 0,
          itemBuilder: (BuildContext context,int index) => dishesTile(context,index),
        )
      ),
    );
  }

  Widget dishesTile(BuildContext context,int index) {
    
    var dish  = dishes[index];
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
      height: 60,
      // color: Colors.white,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(child: Text('${dish.name}',style: TextStyle(color: Colors.black,fontSize: 20))),
                  Center(child: Text('${dish.price}',style: TextStyle(color: Colors.black,fontSize: 20))),
                  Center(child: CupertinoSwitch(
                    value: dish.isShow,
                    onChanged: (bool value){
                      updateDishWithShowState(dish,value);
                    },
                  )),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: EditAndDeleteButton(
              // 删除菜品
              onDeletePressed: (){
                deleteDish(dish);
              },
              // 编辑菜品
              onEditPressed: (){
                 pushToPage(context, ApiDishEditPage(dish: dish));
              }),
            )
          ],
        ),
      ),
    );
  }
}

