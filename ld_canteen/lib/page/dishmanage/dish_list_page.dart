import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/edit_delete_button.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/dish.dart';



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
    super.initState();
  }

  @override
  void dispose() {
    // 取消监听 ‘REFRESH’ 刷新页面通知
    EventBus().off('REFRESH');
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


  // 请求菜品数据
  void getDishList(String categoryObjectId) {
    
    API.getDishList((List<Dish> dishes,String msg){

      setState(() {
        this.dishList = dishes;
      });

      debugPrint(msg);

    }, (String msg){

      debugPrint(msg);

    },objectId: categoryObjectId//order: 'sort',//limit:limit,skip:skip
    );
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
      // color: Colors.white,
      child: Center(
        
        child: Row(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Expanded(
              flex: 1,
              child: Center(child: Text('菜品名称',style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
            Expanded(
              flex: 1,
              child: Center(child: Text('价格（元）',style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
            Expanded(
              flex: 1,
              child: Center(child: Text('是否展示',style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
            Expanded(
              flex: 1,
              child: Center(child: Text('操作',style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
          ],
        ),
      ),
      
    );
    
      
    } else {
      var dish  = dishList[index-1];
      var valueb = dish.isShow;
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
              flex: 1,
              child: Center(child: Text('${dish.name}',style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
            Expanded(
              flex: 1,
              child: Center(child: Text('${dish.price}',style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
            Expanded(
              flex: 1,
              child: Center(child:Switch(
                
                value: valueb,
                activeColor: Colors.blue,
                inactiveTrackColor: Colors.blue.shade50,
                onChanged: (bool v) { 
                  setState(() { 
                    valueb = v; 
                  }); 
                },
              ),),
            ),
            Expanded(
              flex: 1,
              child: EditAndDeleteButton(
              // 删除菜品
              onDeletePressed: (){
                //deleteDish(dish);
              },
              // 编辑菜品
              onEditPressed: (){
                //pushToPage(context, ApiCategoryEditPage(category: category));
              }),
            )
          ],
        ),
      ),
      
    );
    }
  }
}

