import 'package:ld_canteen/api/http_helper.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/model/update.dart';

// 菜品分类回调
typedef CategoryListCallback = void Function(List<Category> categories, String msg);
// 菜品列表回调
typedef DishListCallback = void Function(List<Dish> dishes, String msg);
// 更新/新增回调
typedef UpdateCallBack   = void Function(String objectId,String msg);
// 删除回调
typedef DeleteCallBack   = void Function(String msg);

class API{
  
  // 服务器主机地址
  static final host = 'https://leancloud.cn:443/1.1';

  // 菜品分类
  static final categoryPath   = '/classes/Category';
  // 菜品
  static final dishPath       = '/classes/Dish';
  // 广告栏
  static final bannerPath     = '/classes/Banner';
  // 展览位
  static final menuPath       = '/classes/Menu';

  // 获取分类列表
  static void getCategoryList(CategoryListCallback onSucc,HttpFailCallback onFail,{int limit,int skip}) {

    final path = host + categoryPath;
    var queryParam = Map<String, dynamic>();
    queryParam['keys'] = '-ACL,-updatedAt,-createdAt';
    queryParam['count'] = '1';
    if(limit != null) queryParam['limit'] = limit.toString();
    if(skip != null) queryParam['skip'] = skip.toString();

    HttpHelper.getHttp(path, queryParam, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = CategoryListResp.fromJson(map);
        final dishes = resp.results; 
        if(onSucc != null) onSucc(dishes,msg);
        
    }, onFail);
  }

  // 删除分类
  static void deleteCategory(String objectId,DeleteCallBack onSucc,HttpFailCallback onFail) {

    final path = host + categoryPath + '/' + objectId;

    HttpHelper.deleteHttp(path, null, (_,String msg){
        if(onSucc != null) onSucc(msg);
    }, onFail);
  }

  // 更新分类
  static void updateCategory(String objectId,Category category,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + categoryPath + '/' + objectId;
    var param = category.toJson();

    HttpHelper.putHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }

  // 新增分类
  static void createCategory(Category category,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + categoryPath;
    var param = category.toJson();

    HttpHelper.postHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }



  // 获取菜品列表
  static void getDishList(DishListCallback onSucc,HttpFailCallback onFail,{String objectId,int limit,int skip}) {

    final path = host + dishPath;

    var queryParam = Map<String, dynamic>();
    queryParam['keys'] = '-ACL,-updatedAt,-createdAt';
    queryParam['count'] = '1';
    queryParam['order'] = 'createdAt';
    if(objectId != null) {
        queryParam['where'] = '{"category":{"\$inQuery":{"where":{"objectId":"$objectId"},"className":"Category"}}}';
    }
    if(limit != null) queryParam['limit'] = limit.toString();
    if(skip != null) queryParam['skip'] = skip.toString();

    HttpHelper.getHttp(path, queryParam, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = DishListResp.fromJson(map);
        final dishes = resp.results; 
        if(onSucc != null) onSucc(dishes,msg);
        
    }, onFail);
  }


  // 新增菜品
  static void createDish(Dish dish,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + dishPath;
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

    final path = host + dishPath + '/' + objectId;
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

    final path = host + dishPath + '/' + objectId;

    HttpHelper.deleteHttp(path, null, (_,String msg){
        if(onSucc != null) onSucc(msg);
    }, onFail);
  }








}