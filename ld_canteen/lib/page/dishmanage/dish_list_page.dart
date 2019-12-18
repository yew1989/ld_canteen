import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ld_canteen/api/component/edit_delete_button.dart';
import 'package:ld_canteen/model/dish.dart';



class DishListPage extends StatefulWidget {
  final List<Dish> dishList;
  DishListPage({Key key,@required this.dishList}) : super(key: key);
  @override
  _DishListPageState createState() => _DishListPageState();
}

class _DishListPageState extends State<DishListPage>  with SingleTickerProviderStateMixin{

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
       body: Container(
        child: ListView.builder(
          itemCount: widget.dishList?.length ?? 0,
          itemBuilder: (BuildContext context,int index) => dishTile(context,index),
        )
      ),
    );
  }
  Widget dishTile(BuildContext context,int index) {
    
    var dish  = widget.dishList[index];
    var valueb = dish.isShow;
    
    return Container(
      
      margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
      height: 60,
      // color: Colors.white,
      child: Center(
        
        child: Row(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Expanded(
              flex: 1,
              child: Center(child: Text('${dish.name}',style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
            Expanded(
              flex: 1,
              child: Center(child: Text('${dish.price}',style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
            Expanded(
              flex: 1,
              child: Center(child:Switch(
                
                value: valueb,
                activeColor: Colors.blue,
                inactiveTrackColor: Colors.blue.shade50,
                onChanged: (bool v) { 
                  setState(() { 
                    valueb = v; 
                  }); 
                },
              ),),
            ),
            Expanded(
              flex: 1,
              child: EditAndDeleteButton(
              // 删除菜品
              onDeletePressed: (){
                //deleteDish(dish);
              },
              // 编辑菜品
              onEditPressed: (){
                //pushToPage(context, ApiCategoryEditPage(category: category));
              }),
            )
          ],
        ),
      ),
      
    );
  }
}

