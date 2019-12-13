import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:ld_canteen/api/api.dart';

typedef HttpSuccCallback = void Function(dynamic data, String msg);
typedef HttpFailCallback = void Function(String msg);

class HttpHelper {

  // 开启代理模式,允许抓包
  static final isProxyModeOpen = false;
  // 代理地址
  static final proxyIP = 'PROXY 192.168.31.74:8888';
  // 超时时间
  static final kTimeOutSeconds = 20;

  // 应用账号
  static final leancloudID = 'oXs9QMrxcehkiO2MsIASzvjy-gzGzoHsz';
  static final leancloudKey = 'DNDBbIrsP1YKSEMsxTqnP8u3';

  // 创建 DIO 对象
  static Dio initDio() {
    var dio = Dio();
    var adapter = dio.httpClientAdapter as DefaultHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
        client.findProxy = (_) => isProxyModeOpen ? proxyIP : 'DIRECT';
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    };
    return dio;
  }

  // 检测网络
  static Future<bool> isReachablity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  // GET 
  static void getHttp(String path, Map<String, dynamic> queryParam,HttpSuccCallback onSucc,HttpFailCallback onFail) async { 

    // 检测网络
    var isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        onFail('网络异常,请检查网络');
        return;
      }
    }

    final dio = HttpHelper.initDio();

    try {
      var url = API.host + path;
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
          'X-LC-Id': leancloudID,
          'X-LC-Key':leancloudKey,
          },
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
        ),
        queryParameters: queryParam,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if ((response.statusCode - 200) >= 100) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if (response.data is! Map) {
        onFail('返回格式错误');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      onFail('请求错误');
    }
  }

  // POST 
  static void postHttp(String path, Map<String, dynamic> param,HttpSuccCallback onSucc,HttpFailCallback onFail) async { 

    // 检测网络
    var isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        onFail('网络异常,请检查网络');
        return;
      }
    }

    final dio = HttpHelper.initDio();

    try {
      var url = API.host + path;
      Response response = await dio.post(
        url,
        options: Options(
          headers: {
          'X-LC-Id': leancloudID,
          'X-LC-Key':leancloudKey,
          },
          contentType: Headers.jsonContentType,
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
        ),
        data:param,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if ((response.statusCode - 200) >= 100) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if (response.data is! Map) {
        onFail('返回格式错误');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      onFail('请求错误');
    }
  }

  // PUT
  static void putHttp(String path, Map<String, dynamic> param,HttpSuccCallback onSucc,HttpFailCallback onFail) async { 

    // 检测网络
    var isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        onFail('网络异常,请检查网络');
        return;
      }
    }

    final dio = HttpHelper.initDio();

    try {
      var url = API.host + path;
      Response response = await dio.put(
        url,
        options: Options(
          headers: {
          'X-LC-Id': leancloudID,
          'X-LC-Key':leancloudKey,
          },
          contentType: Headers.jsonContentType,
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
        ),
        data:param,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if ((response.statusCode - 200) >= 100) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if (response.data is! Map) {
        onFail('返回格式错误');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      onFail('请求错误');
    }
  }

  // Delete
  static void deleteHttp(String path, Map<String, dynamic> queryParam,HttpSuccCallback onSucc,HttpFailCallback onFail) async { 

    // 检测网络
    var isReachable = await isReachablity();
    if (isReachable == false) {
      if (onFail != null) {
        onFail('网络异常,请检查网络');
        return;
      }
    }

    final dio = HttpHelper.initDio();

    try {
      var url = API.host + path;
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {
          'X-LC-Id': leancloudID,
          'X-LC-Key':leancloudKey,
          },
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: HttpHelper.kTimeOutSeconds,
          sendTimeout: HttpHelper.kTimeOutSeconds,
        ),
        queryParameters:queryParam,
      );
      if (response == null) {
        onFail('网络异常,请检查网络');
        return;
      }
      if ((response.statusCode - 200) >= 100) {
        onFail('请求错误 ( ' + response.statusCode.toString() + ' )');
        return;
      }
      if (response.data is! Map) {
        onFail('返回格式错误');
        return;
      }
      onSucc(response.data, '请求成功');
    } catch (e) {
      onFail('请求错误');
    }
  }
}