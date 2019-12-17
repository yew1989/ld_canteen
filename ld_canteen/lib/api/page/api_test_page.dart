import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/page/dishlistpage.dart';

class ApiTestPage extends StatefulWidget {
  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {

  // UI 初始化
  List<String> itemTitles = ['菜品列表','新增菜品','修改菜品','删除菜品'];
  List<Color> itemColors = [Colors.blue,Colors.green,Colors.orange,Colors.red];

  // 单元列表项
  Widget listTitle(int index,BuildContext context) {
    var itemTitle = itemTitles[index]; 
    var itemColor = itemColors[index];
    return ListTile(
      title: FlatButton(
        color: itemColor,
        child: Text('$itemTitle',style: TextStyle(color:Colors.white,fontSize: 15)),
        onPressed: ()=>handleTestAPI(index,context),
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
        itemBuilder: (_,index) => listTitle(index,context),
      ),
    );
  }

  // 请求测试
  void handleTestAPI(int index,BuildContext context) {
    switch (index) {

      // 获取菜品列表
      case 0:
        {
          //var limit = 20;
          //var skip = 0;
          API.getDishList((List<Dish> dishes,String msg){
            
              debugPrint(msg);
              debugPrint(dishes.map((f)=>f.toJson()).toList().toString());
              Navigator.push(context,
                MaterialPageRoute(builder: (context) 
                => DishListPage(dishList:dishes)));
            }, (String msg){

              debugPrint(msg);

            },order:'sort',//limit: limit,skip: skip
              
          );
          
          
        }
        break;

        // 新增菜品
        case 1:
        {
            // 菜品对象
            var dish = Dish();
            dish.name = '青椒肉丝';
            // dish.price = '8.5';
            // dish.isShow = true;
            // dish.sort = 8;

            API.addDish(dish,(String objectId,String msg){
            
            debugPrint(msg);
            debugPrint(objectId);

          }, (String msg){

            debugPrint(msg);

          });
        }
        break;

        // 修改菜品
        case 2:
        {

          final objectId = '5df3304543c2570080cdb950';
          // 菜品对象
          var dish = Dish();
          dish.name = '肉末茄子';
          // dish.price = '3.5';
          // dish.isShow = true;
          // dish.sort = 4;

          API.updateDish(objectId,dish,(String objectId,String msg){
            
            debugPrint(msg);
            debugPrint(objectId);

          }, (String msg){

            debugPrint(msg);

          });
        }
        break;

        // 删除菜品
        case 3:
        {
          final objectId = '5df330430a8a84007ffafa2e';

          API.deleteDish(objectId,(String msg){
            
            debugPrint(msg);

          }, (String msg){

            debugPrint(msg);

          });
        }
        break;

      default:
    }
  }

}