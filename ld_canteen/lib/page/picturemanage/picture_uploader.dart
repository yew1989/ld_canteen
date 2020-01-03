import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ld_canteen/api/api.dart';
import 'package:ovprogresshud/progresshud.dart';

class PictureUploader{

  // 上传照片
  static void uploadPicture(BuildContext context,Function(String, String) onSucc,Function(String) onFail) async {
    final file = await choosePicture(context);
    if(file == null) return;
    final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    final filePath = file.uri.toFilePath();
    API.uploadPicture(fileName, filePath, onSucc, onFail);
  }

  // 选择照片
  static Future<File> choosePicture(BuildContext context) async {
    if(TargetPlatform.android != defaultTargetPlatform  && TargetPlatform.iOS != defaultTargetPlatform) {
      Progresshud.showInfoWithStatus('暂不支持iOS和Android系统以外操作系统上传图片');
      return null; 
    }
    final res = await showActionSheet(context);
    if(res == 0) return null;
    var imageFile = await ImagePicker.pickImage(source: res == 1 ? ImageSource.camera : ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(
        ratioX: 4.0, 
        ratioY: 3.0,
      ),
      compressQuality: 50,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
    );
    return croppedFile;
  }

  // 选择照片和相册
  static Future<int> showActionSheet(BuildContext context) {
    return showCupertinoModalPopup<int>(
      context: context,
      builder: (cxt) {
        final dialog = CupertinoActionSheet(
          title: Text('选择菜品照片'),
          cancelButton: CupertinoActionSheetAction(
            onPressed: (){
              Navigator.pop(cxt,0);
            },
            child: Text('取消'),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
            onPressed: (){
              Navigator.pop(cxt,1);
            },
            child: Text('拍照'),
          ),
          CupertinoActionSheetAction(
            onPressed: (){
              Navigator.pop(cxt,2);
            },
            child: Text('手机相册'),
          ),
          ],
        );
        return dialog;
      }
    );
  }
}