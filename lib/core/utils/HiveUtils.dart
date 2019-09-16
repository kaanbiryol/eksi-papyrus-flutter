import 'dart:io';

import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsResponse.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HiveUtils {
  // HiveUtils._();
  // static HiveUtils _instance;
  // Future<HiveUtils> get hive async {
  //   if (_instance != null) return _instance;
  //   _instance = await initHive();
  //   return _instance;
  // }

  // initHive() async {
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   Hive.init(directory.path);
  // }

  HiveUtils._();
  static Directory _directory;
  static final HiveUtils _instance = HiveUtils._();
  static HiveUtils get instance {
    if (_directory == null) {
      _initHive();
    }
    return _instance;
  }

  static void _initHive() async {
    Directory directory = await getApplicationDocumentsDirectory();
    _directory = directory;
    Hive.init(directory.path);
  }

  static const String _kSavedComments = "savedComments";
  static const String _kSavedCommentsBox = "savedCommentsBox";

  Future<List<Comment>> readSavedComments() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    //TODO: permissions
    var box = await Hive.openBox(_kSavedCommentsBox);
    List<Comment> savedComments =
        box.get(_kSavedComments, defaultValue: List<Comment>());
    return savedComments;
  }

  Future<void> saveComment(Comment comment) async {
    List<Comment> savedCommentList = await readSavedComments();
    var box = await Hive.openBox(_kSavedCommentsBox);
    savedCommentList.add(comment);
    box.put(_kSavedComments, comment).whenComplete(() => box.close());
  }
}
