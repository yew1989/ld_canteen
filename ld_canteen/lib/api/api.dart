import 'package:ld_canteen/api/http_helper.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/model/update.dart';

// 菜品列表回调
typedef DishListCallback = void Function(List<Dish> dishes, String msg);
// 更新/新增回调
typedef UpdateCallBack   = void Function(String objectId,String msg);
// 删除回调
typedef DeleteCallBack   = void Function(String msg);

class API{
  
  // 服务器主机地址
  static final host = 'https://leancloud.cn:443/1.1';
  // 菜品对象操作路径
  static final dishesPath = '/classes/Dishes';

  // 获取菜品列表
  static void getDishList(DishListCallback onSucc,HttpFailCallback onFail,{int limit,int skip,String order}) {

    final path = host + dishesPath;

    var queryParam = Map<String, dynamic>();
    queryParam['keys'] = '-ACL,-updatedAt,-createdAt';
    if(limit != null) queryParam['limit'] = limit.toString();
    if(skip != null) queryParam['skip'] = skip.toString();
    if(order != null) queryParam['order'] = order;

    HttpHelper.getHttp(path, queryParam, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = DishListResp.fromJson(map);
        final dishes = resp.results; 
        if(onSucc != null) onSucc(dishes,msg);
        
    }, onFail);
  }

  // 新增菜品
  static void addDish(Dish dish,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + dishesPath;
    var param = dish.toJson();

    HttpHelper.postHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }

  // 更新菜品
  static void updateDish(String objectId,Dish dish,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + dishesPath + '/' + objectId;
    var param = dish.toJson();

    HttpHelper.putHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }

  // 删除菜品
  static void deleteDish(String objectId,DeleteCallBack onSucc,HttpFailCallback onFail) {

    final path = host + dishesPath + '/' + objectId;

    HttpHelper.deleteHttp(path, null, (_,String msg){
        if(onSucc != null) onSucc(msg);
    }, onFail);
  }

}