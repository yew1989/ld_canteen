import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/edit_delete_button.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/page/dishmanage/dish_edit_page.dart';
import 'package:ld_canteen/page/static_style.dart';


class DishListPage extends StatefulWidget {
  final String categoryObjectId;
  DishListPage({Key key,@required this.categoryObjectId}) : super(key: key);
  @override
  _DishListPageState createState() => _DishListPageState();
}

class _DishListPageState extends State<DishListPage>  with SingleTickerProviderStateMixin{
  
  List<Dish> dishList = [];
  String categoryId = '';
  
  @override
  void initState() {
    this.categoryId = widget.categoryObjectId;

    getDishList(categoryId);
    // 监听 ‘REFRESH’ 刷新页面通知
    EventBus().on('REFRESH', (_) {
      getDishList(categoryId);
    });

    EventBus().on('REFRESH_CATEGORYID',(id){
      if(id is String) {
        final categoryId = id;
        getDishList(categoryId);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // 取消监听 ‘REFRESH’ 刷新页面通知
    EventBus().off('REFRESH');
    EventBus().off('REFRESH_CATEGORYID');
    super.dispose();
  }

  // 删除菜品
  void deleteDish(Dish dish) {
    // 删除分类
    API.deleteDish(dish.objectId, (String msg){
      debugPrint(msg);
      // 刷新列表
      getDishList(categoryId);
    }, (String msg) {
      debugPrint(msg);
    });
  }

  // 更新菜品状态
  void updateDishWithShowState(Dish dish, bool isShow) {
    dish.isShow = isShow;

    API.updateDish(dish.objectId, dish, (_, msg) {
      getDishList(categoryId);
    }, (_) {});
  }

  // 请求菜品数据
  void getDishList(String categoryObjectId) {
    API.getDishList((List<Dish> dishes,String msg){
      setState(() {
        this.dishList = dishes;
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    },objectId: categoryObjectId);
  }

  int  _getListCount(){
    int dishListCount = dishList?.length ?? 0;
    return dishListCount + 1;
  }          

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
        child: ListView.builder(
          itemCount: _getListCount(),
          itemBuilder: (BuildContext context,int index) => dishTile(context,index),
        )
      ),
    );
  }

  
  Widget dishTile(BuildContext context,int index) {
    
    if (index == 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
        height: 60,
        color: Color.fromRGBO(241, 241, 241, 1.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Expanded(
                flex: 1,
                child: Center(child: Text('菜品名称',style: STATIC_STYLE.listView)),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('价格',style: STATIC_STYLE.listView)),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('是否展示',style: STATIC_STYLE.listView)),
              ),
            ],
          ),
        ),
      );
    } else if (index.isEven) {
      var dish  = dishList[index-1];
      var valueb = dish.isShow;
      return Slidable(
        child:GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
            height: 60,
            color: Color.fromRGBO(241, 241, 241, 1.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('${dish.name}',style: STATIC_STYLE.listView)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('${dish.price}',style: STATIC_STYLE.listView)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child:Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: valueb,
                      activeColor: STATIC_STYLE.backgroundColor,
                      inactiveTrackColor: Colors.black12,
                      onChanged: (bool v) { 
                        updateDishWithShowState(dish,v);
                      },
                    ),),
                  ),
                ],
              ),
            ),
          ),
          onTap: (){
            pushToPage(context, DishEditPage(categoryId: categoryId,dish: dish));
          },
        ),
        actionPane: SlidableScrollActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete,
            closeOnTap: false,
            onTap: (){
              showDialog(
                context:context,
                child: CupertinoAlertDialog(
                  title:Text('提示'),
                  content:Center(
                    child: Text('是否确定删除该项'),
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(isDestructiveAction: true,child: Text('确定'),onPressed: (){
                      deleteDish(dish);
                      Navigator.of(context).pop();
                    }),
                    CupertinoDialogAction(child: Text('取消'),onPressed: (){
                      Navigator.of(context).pop();
                    }),
                  ],
                )
              );
            },
          ),
        ],
      );
    }else{
      var dish  = dishList[index-1];
      var valueb = dish.isShow;
      return Slidable(
        child:GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
            height: 60,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('${dish.name}',style: STATIC_STYLE.listView)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child: Text('${dish.price}',style: STATIC_STYLE.listView)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(child:Switch(
                      value: valueb,
                      activeColor: STATIC_STYLE.backgroundColor,
                      inactiveTrackColor: Colors.black12,
                      onChanged: (bool v) { 
                        updateDishWithShowState(dish,v);
                      },
                    ),),
                  ),
                ],
              ),
            ),
          ),
          onTap: (){
            pushToPage(context, DishEditPage(categoryId: categoryId,dish: dish));
          },
        ),
        actionPane: SlidableScrollActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete,
            closeOnTap: false,
            onTap: (){
              showDialog(
                context:context,
                child: CupertinoAlertDialog(
                  title:Text('提示'),
                  content:Center(
                    child: Text('是否确定删除该项'),
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(isDestructiveAction: true,child: Text('确定'),onPressed: (){
                      deleteDish(dish);
                      Navigator.of(context).pop();
                    }),
                    CupertinoDialogAction(child: Text('取消'),onPressed: (){
                      Navigator.of(context).pop();
                    }),
                  ],
                )
              );
            },
          ),
        ],
      );
    }
  }

}

