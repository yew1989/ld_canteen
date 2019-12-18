import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/page/updatedishpage.dart';

class DishEditPage extends StatefulWidget {

  final Dish dish;
  final String categoryId;
  const DishEditPage({Key key,this.dish,this.categoryId}) : super(key :key);
  @override
  _DishEditPageState createState() => _DishEditPageState();
}

class _DishEditPageState extends State<DishEditPage> {


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
    return Container(
      
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
  void createDish(Dish dish) {

    final categoryId = widget?.categoryId ?? '';
    API.createDish(categoryId,dish, (_,msg){

      Navigator.of(context).pop();
      // 发送刷新通知
      EventBus().emit('REFRESH');

    }, (_){

    });
  }
}