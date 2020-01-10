import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/model/dish.dart';

class MenuListPage extends StatefulWidget {
  final String categoryObjectId;
  final int limit;
  const MenuListPage({Key key, this.categoryObjectId,this.limit}) : super(key : key);
  @override
  _MenuListPageState createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {

  List<Dish> dishList = [];
  String categoryObjectId;
  int limit; 
  @override
  void initState() {
    categoryObjectId = widget?.categoryObjectId;
    limit = widget?.limit ?? 8; 
    getDishList(categoryObjectId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var list;
    int pageNum = (dishList.length + limit -1)~/limit;
    if (dishList != null) {
      return Swiper(
        itemCount: pageNum,
        itemBuilder: (BuildContext context, int index) {
          list = dishList.sublist(index*this.limit , (index+1)*this.limit < dishList.length ? (index+1)*this.limit : dishList.length);
          return ListView.builder(
            
            itemBuilder: (BuildContext context, int index) {
              if(index.isEven){
                return  Container(
                  color: Color.fromRGBO(241, 241, 241, 1.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Expanded(
                        flex: 1,
                        child: Center(child: Text('${list[index].name}',style: TextStyle(fontSize: 29))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(child: Text('${list[index].price}',style: TextStyle(fontSize: 29))),
                      ),
                    ]
                  )
                );
              }
              if(index.isOdd){
                return  Container(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Expanded(
                        flex: 1,
                        child: Center(child: Text('${list[index].name}',style: TextStyle(fontSize: 29))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(child: Text('${list[index].price}',style: TextStyle(fontSize: 29))),
                      ),
                    ]
                  )
                );
              }
            },
            itemCount: list.length,
          );
        },
        autoplay: pageNum == 1 || pageNum == 0 ? false : true ,
        autoplayDelay: 5000,
      );
    }
  }
  
  void getDishList(String categoryObjectId) {
    
    API.getDishList((List<Dish> dishes,String msg){
      setState(() {
        this.dishList = dishes;
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    },objectId: categoryObjectId//order: 'sort',//limit:limit,skip:skip
    );
  }
}
