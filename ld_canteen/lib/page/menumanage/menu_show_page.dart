import 'package:flutter/material.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/model/banner.dart';
import 'package:ld_canteen/model/category.dart';
import 'package:ld_canteen/model/menu.dart';
import 'package:ld_canteen/page/dishmanage/dish_list_page.dart';
import 'package:ld_canteen/page/picturemanage/picture_add_page.dart';
import 'package:ld_canteen/page/static_style.dart';

class MenuShowPage extends StatefulWidget {
  final Menu menu;
  const MenuShowPage({Key key, this.menu}) : super(key : key);
  @override
  _MenuShowPageState createState() => _MenuShowPageState();
}

class _MenuShowPageState extends State<MenuShowPage> {

  //选取分类
  var types = [{'name':'选择展示框分类','value':'xxxx'},{'name':'菜品类型','value':'category'},{'name':'广告图片','value':'banner'}];

  List<Category> categoryList = [];
  List<BannerBean> bannerList = [];
  Menu menu;
  String change = '';
  Category _category = new Category(name: '选择菜品类型',objectId: '1111');
  BannerBean _bannerBean = new BannerBean(name: '选择广告',objectId: '2222');
  String _categoryChange = '1111';
  String _bannerBeanChange = '2222';
  List<String> imageUrlList = [];
  BannerBean banner = BannerBean();

  // 请求菜品分类数据
  void getCategoryList() {
    API.getCategoryList((List<Category> categories,String msg){
      setState(() {
        this.categoryList = categories;
        this.categoryList.insert(0, _category);
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  // 请求菜广告栏数据
  void getBannerList() {
    API.getBannerList((List<BannerBean> banners,String msg){
      setState(() {
        this.bannerList = banners;
        this.bannerList.insert(0, _bannerBean);
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  @override
  void initState() {
    this.menu = widget?.menu ?? null ;
    change = widget?.menu?.type ?? '';
    _categoryChange = this.menu?.category?.objectId ?? _category.objectId ;
    _bannerBeanChange = this.menu?.banner?.objectId ?? _bannerBean.objectId ;
    getCategoryList();
    getBannerList();
    getBanner(_bannerBeanChange);
    EventBus().on('REFRESH', (_) {
      _page(change,_categoryChange,_bannerBeanChange);
    });
    EventBus().on('REFRESH_BANNERID', (_bannerBeanChange) {
      getBanner(_bannerBeanChange);
    });

    super.initState();
  }

  @override
  void dispose() {
    EventBus().off('REFRESH');
    super.dispose();
  }

  //更新展览框
  void updateMenu(String categoryId,String bannerId,Menu menu,String type){
    menu.type = type;
    if (type == 'category') {
      API.updateMenu(
        menu.objectId,
        menu,
        (_, msg) {
          Navigator.of(context).pop();
          // 发送刷新通知
          EventBus().emit('REFRESHLIST');
        },
        (_) {},categoryId:categoryId
      );
    }else if (type == 'banner') {
      API.updateMenu(
        menu.objectId,
        menu,
        (_, msg) {
          Navigator.of(context).pop();
          // 发送刷新通知
          EventBus().emit('REFRESHLIST');
        },
        (_) {},bannerId:bannerId
      );
    }
  }

  // 更新广告栏
  void updateBanner(BannerBean banner) {
    API.updateBanner(
      banner.objectId,
      banner,
      (_, msg) {
        // 发送刷新通知
        // EventBus().emit('REFRESH');
      },
      (_) {}
    );
  }

  // 请求菜广告栏数据
  void getBanner(String bannerId) {
    API.getBanner(bannerId,(BannerBean banner,String msg){
      setState(() {
        this.banner = banner;
        imageUrlList = this.banner.images;
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child:Scaffold(
        appBar: AppBar(
          title: Text('编辑',style: STATIC_STYLE.appbar,),
          backgroundColor: STATIC_STYLE.backgroundColor,
        ),
        body:Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10),),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10),),
                Expanded(
                  flex: 5,
                  child: DropdownButton<String>(
                    items: types.map((type) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          type['name'],
                          style: STATIC_STYLE.tab,
                        ),
                        value: type['value'],
                      );
                    }).toList(),
                    onChanged: (String v) {
                      if(v == '选择展示框分类'){

                      }else{
                        setState(() {
                          change = v;
                          _page(change,_categoryChange,_bannerBeanChange);
                        });
                      }
                    },
                    value: change ,
                    iconSize: 25,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),),
                Expanded(
                  flex: 5,
                  child: _dropdownButton(),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: _page(change,_categoryChange,_bannerBeanChange),
            )
          ],
        ),
        bottomNavigationBar: FlatButton(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text('确定',
              style: STATIC_STYLE.buttonText),
          color: STATIC_STYLE.backgroundColor,
          onPressed: (){
            setState(() {
              if(change == 'banner'){
                banner.images = imageUrlList;
                updateBanner(banner);
              }
              if(_bannerBeanChange != '2222' ||_categoryChange != '1111'){
                updateMenu(_categoryChange,_bannerBeanChange,menu,change);
              }
              EventBus().emit('REFRESHLIST');
            });
          }
        ),
      ),
    );
  }

  //下拉框
  Widget _dropdownButton(){
    if (change == 'category') {
      return DropdownButton<String>(
        items: categoryList.map((category) {
          return DropdownMenuItem<String>(
            child: Text(
              category.name,
              style: STATIC_STYLE.tab,
            ),
            value: category.objectId,
          );
        }).toList(),
        onChanged: (String v) {
          setState(() {
            _categoryChange= v;
            EventBus().emit('REFRESH_CATEGORYID',_categoryChange);
          });
        },
        value: _categoryChange,
        iconSize: 25,
      );
    }
    else if (change == 'banner') {
      return DropdownButton<String>(
        items: bannerList.map((BannerBean banner) {
          return DropdownMenuItem<String>(
            child: Text(
              banner.name,
              style: STATIC_STYLE.tab,
            ),
            value: banner.objectId,
          );
        }).toList(),
        onChanged: (String v) {
          setState(() {
            _bannerBeanChange = v;
            EventBus().emit('REFRESH_BANNERID',_bannerBeanChange);
          });
        },
        value: _bannerBeanChange ,
        iconSize: 25,
      );
    }else{
      return Column();
    }
  }
  
  //下拉框下方加载页面
  Widget _page(String change,String categoryId,String bannerId){
   
      if (change == 'category') {
        return DishListPage(categoryObjectId:categoryId);
      }else if (change == 'banner' && bannerId != '2222') {
        EventBus().emit('REFRESH_BANNERID',_bannerBeanChange);
        return bannerPage();
      }else{
        return Column();
      }

  }
  
  //广告分支页
  Widget bannerPage(){
    
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child:Text('图片预览:', style: STATIC_STYLE.tab),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  padding: EdgeInsets.all(1),
                  child: Text('选择图片',
                    style: STATIC_STYLE.buttonText),
                  color: STATIC_STYLE.backgroundColor,
                  onPressed: () {
                    setState((){
                      pushToPage(context, PictureAddPage(pictureUrlList: banner.images));  
                    });
                  }, 
                )
              ),
            ],
          ),
          Container(
            height: 700,
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: _imagePreview(),
            ),
          ),
        ],
      ),
    );
  }


  //广告分支加载图片
  List<Widget> _imagePreview(){
    List<Widget> list = [];
    if (imageUrlList == null) {
      list.add(Container(child:Text('未上传图片！', style: TextStyle(color: Colors.red, fontSize: 25))));
      return list;
    } else {
      list = imageUrlList.map((imageUrl){
        try {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment:AlignmentDirectional.topEnd,
                children:<Widget>[
                  Image(image: NetworkImage(imageUrl)),
                  Container(),
                  IconButton(
                    icon: Icon(Icons.close,size: 30,color: Colors.red,),
                    onPressed: (){
                      setState(() {
                        imageUrlList.remove(imageUrl);
                      });
                    },
                  ),
                ],
              ),
            ],
          );
        } catch (e) {
          print(e);
          imageUrlList.remove(imageUrl);
        }
      }).toList();

      return list;
    }
  }

  
  


  
}