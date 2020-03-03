import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/page/static_style.dart';


class DishEditPage extends StatefulWidget {
  final Dish dish;
  final String categoryId;
  const DishEditPage({Key key, this.dish, this.categoryId}) : super(key: key);
  @override
  _DishEditPageState createState() => _DishEditPageState();
}

class _DishEditPageState extends State<DishEditPage> {

  List<Category> categories = [];
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  String categoryObjectId;
  var isShow;
  List<DropdownMenuItem<Category>> items = [];
  Category newCategory = Category(name: '请选择类型', objectId: '1111');

  @override
  void initState() {
    categoryObjectId = widget?.categoryId ?? newCategory.objectId;
    nameCtrl.text = widget?.dish?.name ?? '';
    priceCtrl.text = widget?.dish?.price ?? '';
    isShow = widget?.dish?.isShow ?? true;
    getCategoryList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isAdd = widget.dish == null;
    
    return SafeArea(
      child:Scaffold(
        appBar: AppBar(
          title: isAdd ? Text('新增菜品',style: STATIC_STYLE.appbar,) : Text('编辑菜品',style: STATIC_STYLE.appbar,),
          backgroundColor: STATIC_STYLE.backgroundColor,
        ),
        body: Container(
          margin: EdgeInsets.all(40),
          child: ListView(
            children: <Widget>[
              Text('菜品名称:', style: STATIC_STYLE.tab),
              TextField(
                  maxLength: 20,
                  maxLines: 1,
                  style: STATIC_STYLE.textField,
                  controller: nameCtrl,
                  decoration: InputDecoration()),
              Text('菜品价格:', style: STATIC_STYLE.tab),
              TextField(
                  maxLength: 20,
                  maxLines: 1,
                  style: STATIC_STYLE.textField,
                  controller: priceCtrl,
                  decoration: InputDecoration()),
              Row(
                children: <Widget>[
                  Text('菜品类型:',
                      style: STATIC_STYLE.tab),
                ],
              ),
              Row(children: <Widget>[
                Expanded(
                  flex: 3,
                  child: DropdownButton<String>(
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          '${category.name}',
                          style: STATIC_STYLE.textField,
                        ),
                        value: category.objectId,
                      );
                    }).toList(),
                    onChanged: (String category) {
                      setState(() {
                        categoryObjectId = category;
                      });
                    },
                    value: categoryObjectId,
                    iconSize: 25,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text('是否展示:',
                      style: STATIC_STYLE.tab),
                ),
                Switch(
                  value: isShow,
                  activeColor: STATIC_STYLE.backgroundColor,
                  inactiveTrackColor: Colors.black12,
                  onChanged: (bool v) {
                    isShow = v;
                  },
                ),
              ]),
            ],
          ),
        ),
        bottomNavigationBar: FlatButton(
          padding: EdgeInsets.all(10),
          child: Text('确定',
              style: STATIC_STYLE.buttonText),
          color: STATIC_STYLE.backgroundColor,
          onPressed: () {
            // 新增
            if (isAdd) {
              var item = Dish(
                  name: nameCtrl.text ?? '',
                  price: priceCtrl.text ?? '',
                  isShow: isShow);
              createDish(item, categoryObjectId);
            }
            // 更新
            else {
              var item = widget.dish;
              item.name = nameCtrl.text ?? '';
              item.price = priceCtrl.text ?? '';
              item.isShow = isShow;
              updateDish(item, categoryObjectId);
            }
          },
        ),
      )
    );
  }

  // 更新
  void updateDish(Dish dish, String categoryObjectId) {
    API.updateDish(
      dish.objectId,
      dish,
      (_, msg) {
        Navigator.of(context).pop();
        // 发送刷新通知
        EventBus().emit('REFRESH');
      },
      (_) {},categoryId:categoryObjectId
    );
  }

  // 新增
  void createDish(Dish dish, String categoryObjectId) {
    final categoryId = categoryObjectId;
      API.createDish(categoryId, dish, (_, msg) {
        Navigator.of(context).pop();
        // 发送刷新通知
        EventBus().emit('REFRESH');
      }, (_) {},
    );
  }

  // 请求菜品分类数据
  void getCategoryList() {
    API.getCategoryList((List<Category> categories, String msg) {
      setState(() {
        this.categories = categories;
        categories.insert(0, newCategory);
      });
      debugPrint(msg);
    }, (String msg) {
      debugPrint(msg);
    });
  }
  
}
