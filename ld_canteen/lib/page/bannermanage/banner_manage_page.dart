
import 'package:ld_canteen/api/api.dart';
import 'package:flutter/material.dart';
import 'package:ld_canteen/api/component/edit_delete_button.dart';
import 'package:ld_canteen/api/component/event_bus.dart';
import 'package:ld_canteen/api/component/public_tool.dart';
import 'package:ld_canteen/model/banner.dart';
import 'package:ld_canteen/page/bannermanage/banner_edit_page.dart';
import 'package:ld_canteen/page/static_style.dart';

class BannerManagePage extends StatefulWidget {
  @override
  _BannerManagePageState createState() => _BannerManagePageState();
}

class _BannerManagePageState extends State<BannerManagePage> {

  List<BannerBean> bannerList = [];

  // 请求菜广告栏数据
  void getBannerList() {
    API.getBannerList((List<BannerBean> banners,String msg){
      setState(() {
        this.bannerList = banners;
      });
      debugPrint(msg);
    }, (String msg){
      debugPrint(msg);
    });
  }

  @override
  void initState() {
    getBannerList();
    EventBus().on('REFRESH', (_) {
      getBannerList();
    });
    super.initState();
  }

  @override
  void dispose() {
    EventBus().off('REFRESH');
    super.dispose();
  }

  //标签栏 行数+1
  int  _getListCount(){
    int dishListCount = bannerList?.length ?? 0;
    return dishListCount + 1;
  }  

  // 删除广告栏
  void deleteBanner(BannerBean banner) {
        // 删除分类
    API.deleteBanner(banner.objectId, (String msg){
      debugPrint(msg);
      // 刷新列表
      getBannerList();
    }, (String msg) {
      debugPrint(msg);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: new AppBar(
          title: Text('广告栏管理',style: STATIC_STYLE.appbar),
          backgroundColor: STATIC_STYLE.backgroundColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_box,size: 30),
              onPressed: () {
                pushToPage(context, BannerEditPage());
              }
            )
          ],
        ),
        body: Container(
          child: ListView.builder(
            itemCount: _getListCount(),
            itemBuilder: (BuildContext context,int index) => bannerTile(context,index),
          ),
        ),
      ),
    );
  }


  Widget bannerTile(BuildContext context,int index) {
    //首行 标签
    if (index == 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
        height: 60,
        color: Color.fromRGBO(241, 241, 241, 1.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Expanded(
                flex: 1,
                child: Center(child: Text('广告栏名称',style: STATIC_STYLE.listView)),
              ),
              Expanded(
                flex: 2,
                child: Center(child: Text('图片预览',style: STATIC_STYLE.listView)),
              ),
              Expanded(
                flex: 1,
                child: Center(child: Text('操作',style: STATIC_STYLE.listView)),
              ),
            ],
          ),
        ),
      );
    }else if(index.isEven){
      var  banner  = bannerList[index-1];
      List<String> str = banner.images;
      return GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
          height: 60,
          color: Color.fromRGBO(241, 241, 241, 1.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Expanded(
                  flex: 1,
                  child: Center(child: Text('${banner.name}',style: STATIC_STYLE.listView)),
                ),
                Expanded(
                  flex: 2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:str.map((imageUrl) {
                      try {
                        return Image(
                          image: NetworkImage('${imageUrl.toString()}'),fit: BoxFit.cover,
                        );
                      } catch (e) {
                        print(e);
                      }
                    }).toList(),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: EditAndDeleteButton(
                    // 删除广告栏
                    onDeletePressed: (){
                      deleteBanner(banner);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: (){
          pushToPage(context, BannerEditPage(banner: banner));
        },
      );
    } else {
      var  banner  = bannerList[index-1];
      List<String> str = banner.images;
      return GestureDetector(
        child: Container(
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
                  child: Center(child: Text('${banner.name}',style: STATIC_STYLE.listView)),
                ),
                Expanded(
                  flex: 2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:str.map((imageUrl) {
                      try {
                        return Image(
                          image: NetworkImage('${imageUrl.toString()}'),fit: BoxFit.cover,
                        );
                      } catch (e) {
                        print(e);
                      }
                    }).toList(),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: EditAndDeleteButton(
                    // 删除广告栏
                    onDeletePressed: (){
                      deleteBanner(banner);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: (){
          pushToPage(context, BannerEditPage(banner: banner));
        },
      );
    }
  }

}