// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentsResponse.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommentAdapter extends TypeAdapter<Comment> {
  @override
  Comment read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comment(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.comment)
      ..writeByte(2)
      ..write(obj.likeCount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.ownerUsername)
      ..writeByte(5)
      ..write(obj.ownerProfileUrl)
      ..writeByte(6)
      ..write(obj.commentUrl);
  }
}
