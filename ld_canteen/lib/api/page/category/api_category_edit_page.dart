import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/category.dart';

class ApiCategoryEditPage extends StatefulWidget {

  final Category category;
  const ApiCategoryEditPage({Key key, this.category}) : super(key: key);
  @override
  _ApiCategoryEditPageState createState() => _ApiCategoryEditPageState();
}

class _ApiCategoryEditPageState extends State<ApiCategoryEditPage> {

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var isAdd = widget.category == null;
    var initText = widget?.category?.name ?? '';
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
                    var item = Category(name: controller.text ?? '');
                    addCategory(item);
                }
                // 更新
                else {
                    var item = widget.category;
                    item.name = controller.text ?? '';
                    updateCategory(item);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 更新
  void updateCategory(Category category) {

    API.updateCategory(category.objectId, category, (_,msg){

      Navigator.of(context).pop();

    }, (_){

    });
  }

  // 新增
  void addCategory(Category category) {

    API.createCategory(category, (_,msg){

      Navigator.of(context).pop();

    }, (_){

    });
  }
}