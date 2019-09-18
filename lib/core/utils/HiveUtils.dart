import 'dart:io';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsResponse.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveUtils {
  static const String _kSavedComments = "savedComments";
  static const String _kSavedCommentsBox = "savedCommentsBox";

  List<Comment> favoritesList = [];

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

  void registerAdapters() {
    Hive.registerAdapter(CommentAdapter(), 0);
  }

  Future<List<Comment>> readSavedComments() async {
    //TODO: permissions
    var box = await Hive.openBox(_kSavedCommentsBox);
    List<dynamic> dynamicSavedComments =
        box.get(_kSavedComments, defaultValue: List<Comment>());
    var savedComments = new List<Comment>.from(dynamicSavedComments);
    favoritesList = savedComments;
    return savedComments;
  }

  Future<void> saveComment(Comment comment) async {
    List<Comment> savedComments = await readSavedComments();
    if (savedComments.contains(comment)) return;
    var box = await Hive.openBox(_kSavedCommentsBox);
    savedComments.add(comment);
    favoritesList = savedComments;
    box.put(_kSavedComments, savedComments).whenComplete(() => box.close());
  }

  Future<void> removeComment(Comment comment) async {
    List<Comment> savedComments = await readSavedComments();
    if (!savedComments.contains(comment)) return;
    var box = await Hive.openBox(_kSavedCommentsBox);
    savedComments.remove(comment);
    favoritesList = savedComments;
    box.put(_kSavedComments, savedComments).whenComplete(() => box.close());
  }
}
