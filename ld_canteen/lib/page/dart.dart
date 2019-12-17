

import 'package:ld_canteen/model/dish.dart';

class DishTypeModel{
  final String name; //类型名称
  final bool isShow; //是否展示
  final int sort;  //编号
  final String objectId; //类型id

  DishTypeModel({this.name, this.isShow, this.sort, this.objectId});
}

var typeTest = [
  DishTypeModel(
    name: '荤菜',
    isShow: true,
    sort: 1,
    objectId: '5df4880b43c2570080cf9a93',
  ),
  DishTypeModel(
    name: '半荤素',
    isShow: true,
    sort: 2,
    objectId: '5df4886243c2570080cf9ab0',
  ),
  DishTypeModel(
    name: '素菜',
    isShow: true,
    sort: 3,
    objectId: '5df4887d43c2570080cf9ac6',
  ),
  DishTypeModel(
    name: '汤类',
    isShow: true,
    sort: 4,
    objectId: '5df4887d43c2570080cf9ac6',
  ),
];

class DishModel{
  final String name; //菜品名称
  final bool isShow; //是否展示
  final double price; //价格 
  final int sort;  //编号
  final String objectId; //菜品id

  DishModel({this.name, this.isShow, this.price ,this.sort, this.objectId});
}

List<Dish> dishTest = [
  Dish(
    name: '红烧狮子头',
    isShow: true,
    price: '4.0',
    // sort: 1
  ),
  Dish(
    name: '清炒空心菜',
    isShow: true,
    price: '2.0',
    // sort: 2
  ),
  Dish(
    name: '土豆烧牛肉',
    isShow: true,
    price: '12.0',
    // sort: 3
  ),
  Dish(
    name: '香辣鸡腿',
    isShow: true,
    price: '8.0',
    // sort: 4
  ),
  Dish(
    name: '肉末茄子',
    isShow: true,
    price: '5.5',
    // sort: 5
  ),
  Dish(
    name: '梅菜扣肉',
    isShow: true,
    price: '6.7',
    // sort: 6
  ),
  Dish(
    name: '牛肉拉面',
    isShow: true,
    price: '10.2',
    // sort: 6
  ),
  Dish(
    name: '青椒肉丝',
    isShow: true,
    price: '5.8',
    // sort: 7
  ),
  Dish(
    name: '干炒牛河',
    isShow: true,
    price: '22.0',
    // sort: 8
  ),
  Dish(
    name: '牛肉炒刀削',
    isShow: true,
    price: '12.0',
    // sort: 9
  ),
  Dish(
    name: '西红柿炒鸡蛋',
    isShow: true,
    price: '8.8',
    // sort: 10
  ),
  Dish(
    name: '韭菜炒鸡蛋',
    isShow: true,
    price: '10.5',
    // sort: 11
  ),
];