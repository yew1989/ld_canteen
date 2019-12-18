import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/dish.dart';

var selectItemValue;

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
  Category selectedCategory;

  @override
  void initState() {
    selectedCategory = newCategory;
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

    nameCtrl.text = widget?.dish?.name ?? '';
    priceCtrl.text = widget?.dish?.price ?? '';
    isShow = widget?.dish?.isShow ?? true;

    return Scaffold(
      appBar: AppBar(
        title: isAdd ? Text('新增菜品') : Text('编辑菜品'),
      ),
      body: Container(
        margin: EdgeInsets.all(40),
        child: ListView(
          children: <Widget>[
            Text('菜品名称:', style: TextStyle(color: Colors.black, fontSize: 30)),
            TextField(
                maxLength: 20,
                maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: 30),
                controller: nameCtrl,
                decoration: InputDecoration()),
            Text('菜品价格:', style: TextStyle(color: Colors.black, fontSize: 30)),
            TextField(
                maxLength: 20,
                maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: 30),
                controller: priceCtrl,
                decoration: InputDecoration()),
            Row(
              children: <Widget>[
                Text('菜品类型:',
                    style: TextStyle(color: Colors.black, fontSize: 30)),
              ],
            ),
            Row(children: <Widget>[
              Expanded(
                flex: 2,
                child: DropdownButton<Category>(
                  items: categories.map((category) {
                    return DropdownMenuItem<Category>(
                      child: Text(
                        '${category.name}',
                        style: TextStyle(fontSize: 30),
                      ),
                      value: category,
                    );
                  }).toList(),
                  onChanged: (Category category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  value: selectedCategory,
                  iconSize: 50,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('是否展示:',
                    style: TextStyle(color: Colors.black, fontSize: 30)),
              ),
              Switch(
                value: isShow,
                activeColor: Colors.blue,
                inactiveTrackColor: Colors.blue.shade50,
                onChanged: (bool v) {
                  setState(() {
                    isShow = v;
                  });
                },
              ),
            ]),
            FlatButton(
              padding: EdgeInsets.all(10),
              child: Text('确定',
                  style: TextStyle(color: Colors.white, fontSize: 40)),
              color: Colors.blueAccent,
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
                  item.isShow = isShow ?? true;
                  updateDish(item, categoryObjectId);
                }
              },
            ),
          ],
        ),
      ),
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
      (_) {},
    );
  }

  // 新增
  void createDish(Dish dish, String categoryObjectId) {
    final categoryId = categoryObjectId;
    API.createDish(categoryId, dish, (_, msg) {
      Navigator.of(context).pop();
      // 发送刷新通知
      EventBus().emit('REFRESH');
    }, (_) {});
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
