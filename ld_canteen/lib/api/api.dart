import 'package:ld_canteen/api/http_helper.dart';
import 'package:ld_canteen/model/banner.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/dish.dart';
import 'package:ld_canteen/model/menu.dart';
import 'package:ld_canteen/model/picture.dart';
import 'package:ld_canteen/model/update.dart';

// 菜品分类回调
typedef CategoryListCallback = void Function(List<Category> categories, String msg);
// 菜品列表回调
typedef DishListCallback = void Function(List<Dish> dishes, String msg);
// 广告列表回调
typedef BannerListCallback = void Function(List<Banner> banners, String msg);
// 展示位列表回调
typedef MenuListCallback = void Function(List<Menu> menus, String msg);
// 素材库列表回调
typedef PictureCallback = void Function(List<PictureBean> menus, String msg);

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
  // 素材库
  static final filePath       = '/classes/_File';

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

  // 新增分类
  static void createCategory(Category category,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + categoryPath;
    var param = category.toJson();
    if(param.containsKey('objectId')) {
      param.remove('objectId');
    }

    HttpHelper.postHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }

  // 更新分类
  static void updateCategory(String objectId,Category category,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + categoryPath + '/' + objectId;
    var param = category.toJson();
    if(param.containsKey('objectId')) {
      param.remove('objectId');
    }

    HttpHelper.putHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }

  // 删除分类
  static void deleteCategory(String objectId,DeleteCallBack onSucc,HttpFailCallback onFail) {

    final path = host + categoryPath + '/' + objectId;

    HttpHelper.deleteHttp(path, null, (_,String msg){
        if(onSucc != null) onSucc(msg);
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
  static void createDish(String categoryId,Dish dish,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + dishPath;
    var param = dish.toJson();
    if(categoryId != null) {
      var category = Map<String,dynamic>();
      category['__type'] = 'Pointer';
      category['className'] = 'Category';
      category['objectId'] = '$categoryId';
      param['category'] = category;
    }
    if(param.containsKey('objectId')) {
      param.remove('objectId');
    }

    HttpHelper.postHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }

  // 更新菜品
  static void updateDish(String objectId,Dish dish,UpdateCallBack onSucc,HttpFailCallback onFail,{String categoryId}) {

    final path = host + dishPath + '/' + objectId;
    var param = dish.toJson();
    
    if(categoryId != null) {
      var category = Map<String,dynamic>();
      category['__type'] = 'Pointer';
      category['className'] = 'Category';
      category['objectId'] = '$categoryId';
      param['category'] = category;
    }
    if(param.containsKey('objectId')) {
      param.remove('objectId');
    }

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

  // 删除某一分类下所有菜品
  static void deleteDishesByCategoryId(String categoryId,DeleteCallBack onSucc,HttpFailCallback onFail) {
    
    List<String> dishObjetcIdList = [];

    // 1.查出所有菜
    API.getDishList((List<Dish> dishes,_){
      for (var dish in dishes) {
        dishObjetcIdList.add(dish.objectId);
      }
      if(dishObjetcIdList.length == 0) {
        if(onSucc != null) onSucc('操作成功');
        return;
      }
      
      // 2.批量删除改分类下所有菜品
      final path = host + '/batch';
      var param = Map<String,dynamic>();
      List<Map<String,dynamic>> requests = [];
   
      for (final dishObjectId in dishObjetcIdList) {
        var request = Map<String,dynamic>();
        request['method'] = 'DELETE';
        request['path'] = '/1.1/classes/Dish/$dishObjectId';
        requests.add(request);
      }
      param['requests'] = requests;

      HttpHelper.postHttp(path, param, (dynamic data,String msg){
        if(onSucc != null) onSucc('操作成功');
      }, (String msg){
        if(onFail != null) onFail('操作失败');
      });

    }, onFail,objectId: categoryId);
    
  }


  // 获取所有广告栏列表
  static void getBannerList(BannerListCallback onSucc,HttpFailCallback onFail,{int limit,int skip}) {

    final path = host + bannerPath;
    var queryParam = Map<String, dynamic>();
    queryParam['keys'] = '-ACL,-updatedAt,-createdAt';
    queryParam['count'] = '1';
    if(limit != null) queryParam['limit'] = limit.toString();
    if(skip != null) queryParam['skip'] = skip.toString();

    HttpHelper.getHttp(path, queryParam, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = BannerResp.fromJson(map);
        final banners = resp.results; 
        if(onSucc != null) onSucc(banners,msg);
        
    }, onFail);
  }

  // 新增广告栏
  static void createBanner(Banner banner,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + bannerPath;
    var param = banner.toJson();
    if(param.containsKey('objectId')) {
      param.remove('objectId');
    }

    HttpHelper.postHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }
  
  // 更新广告栏
  static void updateBanner(String objectId,Banner banner,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + bannerPath + '/' + objectId;
    var param = banner.toJson();
    if(param.containsKey('objectId')) {
      param.remove('objectId');
    }

    HttpHelper.putHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }
  
  // 删除广告栏
  static void deleteBanner(String objectId,DeleteCallBack onSucc,HttpFailCallback onFail) {

    final path = host + bannerPath + '/' + objectId;

    HttpHelper.deleteHttp(path, null, (_,String msg){
        if(onSucc != null) onSucc(msg);
    }, onFail);
  }


  // 获取展览位列表 若为 TV端 首页 limit = 6,skip = 0,
  static void getMenuList(MenuListCallback onSucc,HttpFailCallback onFail,{int limit,int skip}) {

    final path = host + menuPath;
    var queryParam = Map<String, dynamic>();
    var keys = '-ACL,-updatedAt,-createdAt,';
    keys += '-category.className,-category.createdAt,-category.updatedAt,';
    keys += '-banner.className,-banner.updatedAt,-banner.createdAt';
    queryParam['keys'] = keys;
    queryParam['count'] = '1';
    if(limit != null) queryParam['limit'] = limit.toString();
    if(skip != null) queryParam['skip'] = skip.toString();

    HttpHelper.getHttp(path, queryParam, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = MenuResp.fromJson(map);
        final menus = resp.results; 
        if(onSucc != null) onSucc(menus,msg);
        
    }, onFail);
  }
  
  // 新增展览位 
  static void createMenu(Menu menu,UpdateCallBack onSucc,HttpFailCallback onFail,{String bannerId,String categoryId}) {

    if(bannerId != null && categoryId != null) {
      onFail('展览位和菜品分类只能关联一个');
      return;
    }

    final path = host + menuPath;
    var param = menu.toJson();
    if(param.containsKey('objectId')) {
      param.remove('objectId');
    }

    if(categoryId != null) {
      var category = Map<String,dynamic>();
      category['__type'] = 'Pointer';
      category['className'] = 'Category';
      category['objectId'] = '$categoryId';
      param['category'] = category;
    }

     if(bannerId != null) {
      var banner = Map<String,dynamic>();
      banner['__type'] = 'Pointer';
      banner['className'] = 'Banner';
      banner['objectId'] = '$bannerId';
      param['banner'] = banner;
    }

    HttpHelper.postHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }

  // 更新展览位
  static void updateMenu(String objectId,Menu menu,UpdateCallBack onSucc,HttpFailCallback onFail,{String bannerId,String categoryId}) {

    if(bannerId != null && categoryId != null) {
      onFail('展览位和菜品分类只能关联一个');
      return;
    }

    final path = host + menuPath + '/' + objectId;
    var param = menu.toJson();
    if(param.containsKey('objectId')) {
      param.remove('objectId');
    }
    
    if(categoryId != null) {
      var category = Map<String,dynamic>();
      category['__type'] = 'Pointer';
      category['className'] = 'Category';
      category['objectId'] = '$categoryId';
      param['category'] = category;
    }

    if(bannerId != null) {
      var banner = Map<String,dynamic>();
      banner['__type'] = 'Pointer';
      banner['className'] = 'Banner';
      banner['objectId'] = '$bannerId';
      param['banner'] = banner;
    }

    HttpHelper.putHttp(path, param, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }

  // 删除展览位
  static void deleteMenu(String objectId,DeleteCallBack onSucc,HttpFailCallback onFail) {

    final path = host + menuPath + '/' + objectId;

    HttpHelper.deleteHttp(path, null, (_,String msg){
        if(onSucc != null) onSucc(msg);
    }, onFail);
  }


  // 素材列表获取
  static void getPictureList(PictureCallback onSucc,HttpFailCallback onFail,{int limit,int skip}) {

    final path = host + filePath;
    var queryParam = Map<String, dynamic>();
    queryParam['keys'] = '-metaData,-updatedAt,-createdAt,-provider,-bucket';
    queryParam['count'] = '1';
    if(limit != null) queryParam['limit'] = limit.toString();
    if(skip != null) queryParam['skip'] = skip.toString();

    HttpHelper.getHttp(path, queryParam, (dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = PictureResp.fromJson(map);
        final pictures = resp.results; 
        if(onSucc != null) onSucc(pictures,msg);
        
    }, onFail);
  }

  // 删除素材
  static void deletePicture(String objectId,DeleteCallBack onSucc,HttpFailCallback onFail) {

    final path = host + '/files/' + objectId;

    HttpHelper.deleteHttp(path, null, (_,String msg){
        if(onSucc != null) onSucc(msg);
    }, onFail);
  }

  // 素材上传
  static void uploadPicture(String fileName,String filePath,UpdateCallBack onSucc,HttpFailCallback onFail) {

    final path = host + '/files/' + fileName;

    HttpHelper.uploadHttp(path, filePath,fileName,(dynamic data,String msg){
        final map  = data as Map<String,dynamic>;
        final resp = UpdateResp.fromJson(map);
        final objectId = resp?.objectId ?? ''; 
        if(onSucc != null) onSucc(objectId,msg);
    }, onFail);
  }
  

}