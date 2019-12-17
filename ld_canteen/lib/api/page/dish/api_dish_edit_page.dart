import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/dish.dart';

class ApiDishEditPage extends StatefulWidget {

  final Dish dish;
  const ApiDishEditPage({Key key, this.dish}) : super(key: key);
  @override
  _ApiDishEditPageState createState() => _ApiDishEditPageState();
}

class _ApiDishEditPageState extends State<ApiDishEditPage> {

  TextEditingController controller = TextEditingController();

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

    var isAdd = widget.dish == null;
    var initText = widget?.dish?.name ?? '';
    controller.text = initText;

    return Scaffold(
      appBar: AppBar(
        title: isAdd ? Text('新增菜品分类') : Text('编辑菜品分类'),
      ),
      body: Container(
        margin: EdgeInsets.all(40),
        child: ListView(
          children: <Widget>[
            Text('菜品名称:',style: TextStyle(color: Colors.black,fontSize: 30),),
            TextField(
              maxLength: 20,
              maxLines: 1,
              style: TextStyle(color: Colors.black,fontSize: 30),
              controller: controller,
              decoration:InputDecoration(

              )
            ),
            FlatButton(
            padding: EdgeInsets.all(10),
            child: Text('确定',style: TextStyle(color: Colors.white,fontSize: 40)),
            color: Colors.blueAccent,
            onPressed: (){
                // 新增
                if(isAdd) {
                    var item = Dish(name: controller.text ?? '');
                    addDish(item);
                }
                // 更新
                else {
                    var item = widget.dish;
                    item.name = controller.text ?? '';
                    updateDish(item);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 更新
  void updateDish(Dish dish) {

    API.updateDish(dish.objectId, dish, (_,msg){

      Navigator.of(context).pop();
      // 发送刷新通知
      EventBus().emit('REFRESH');
    }, (_){

    });
  }

  // 新增
  void addDish(Dish dish) {

    API.createDish(dish, (_,msg){

      Navigator.of(context).pop();
      // 发送刷新通知
      EventBus().emit('REFRESH');

    }, (_){

    });
  }
}