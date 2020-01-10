import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/page/static_style.dart';

class CategoryEditPage extends StatefulWidget {
  final Category category;
  const CategoryEditPage({Key key, this.category}) : super(key : key);
  @override
  _CategoryEditPageState createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {

  TextEditingController nameCtrl = TextEditingController();

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

    var isAdd = widget.category == null;
    nameCtrl.text = widget?.category?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: isAdd ? Text('新增菜品分类',style: STATIC_STYLE.appbar,) : Text('编辑菜品分类',style: STATIC_STYLE.appbar,),
        backgroundColor: STATIC_STYLE.backgroundColor,
      ),
      body: Container(
        margin: EdgeInsets.all(40),
        child: ListView(
          children: <Widget>[
            Text('菜品分类名称:', style: STATIC_STYLE.tab),
            TextField(
                maxLength: 20,
                maxLines: 1,
                style: STATIC_STYLE.textField,
                controller: nameCtrl,
                decoration: InputDecoration()),
            
          ],
        ),
      ),
      bottomNavigationBar: FlatButton(
              padding: EdgeInsets.all(10),
              child: Text('确定',
                  style: STATIC_STYLE.buttonText),
              color: Colors.blueAccent,
              onPressed: () {
                // 新增
                if (isAdd) {
                  var item = Category(
                      name: nameCtrl.text ?? '',);
                  createCategory(item);
                }
                // 更新
                else {
                  var item = widget.category;
                  item.name = nameCtrl.text ?? '';
                  updateCategory(item);
                }
              },
            ),
    );
  }

  // 更新
  void updateCategory(Category category) {
    API.updateCategory(
      category.objectId,
      category,
      (_, msg) {
        Navigator.of(context).pop();
        // 发送刷新通知
        EventBus().emit('REFRESH');
      },
      (_) {}
    );
  }

  // 新增
  void createCategory(Category category) {
    API.createCategory(category, (_, msg) {
      Navigator.of(context).pop();
      // 发送刷新通知
      EventBus().emit('REFRESH');
    }, (_) {},
    );
  }
}