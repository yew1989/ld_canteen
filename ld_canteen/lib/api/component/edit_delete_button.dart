import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditAndDeleteButton extends StatelessWidget {
  
  final void Function() onEditPressed;
  final void Function() onDeletePressed;

  const EditAndDeleteButton({Key key, this.onEditPressed, this.onDeletePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
            FlatButton(
              color: Colors.green,
              child: Text('编辑',style: TextStyle(color: Colors.white,fontSize: 20)),onPressed: (){
                if(onEditPressed != null)onEditPressed();
              }),
            SizedBox(width: 8),
            FlatButton(
              color: Colors.red,
              child: Text('删除',style: TextStyle(color: Colors.white,fontSize: 20)),onPressed: (){
                showDialog(
                  context:context,
                  child: CupertinoAlertDialog(
                    title:Text('提示'),
                    content:Center(
                      child: Text('是否确定删除该项'),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(isDestructiveAction: true,child: Text('确定'),onPressed: (){
                        if(onDeletePressed != null) onDeletePressed();
                        Navigator.of(context).pop();
                      }),
                      CupertinoDialogAction(child: Text('取消'),onPressed: (){
                        Navigator.of(context).pop();
                      }),
                    ],
                  )
                );
              }),
        ],
      ),
    );
  }

}