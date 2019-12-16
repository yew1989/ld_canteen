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
              child: Text('编辑',style: TextStyle(color: Colors.white,fontSize: 20)),onPressed: (){}),
            SizedBox(width: 8),
            FlatButton(
              color: Colors.red,
              child: Text('删除',style: TextStyle(color: Colors.white,fontSize: 20)),onPressed: (){}),
        ],
      ),
    );
  }
}