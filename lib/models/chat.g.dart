// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 1;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat(
      id: fields[0] as int,
      name: fields[1] as String,
      message: (fields[2] as List).cast<Message>(),
    );
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 2;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      dateTime: fields[0] as int,
      role: fields[1] as Role,
      mark: fields[3] as Mark,
      type: fields[2] as MessageType,
      content: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<MessageType, String>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.mark)
      ..writeByte(4)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoleAdapter extends TypeAdapter<Role> {
  @override
  final int typeId = 3;

  @override
  Role read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Role.assistant;
      case 1:
        return Role.user;
      default:
        return Role.assistant;
    }
  }

  @override
  void write(BinaryWriter writer, Role obj) {
    switch (obj) {
      case Role.assistant:
        writer.writeByte(0);
        break;
      case Role.user:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 4;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.link;
      case 1:
        return MessageType.text;
      case 2:
        return MessageType.init;
      case 3:
        return MessageType.image;
      default:
        return MessageType.link;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.link:
        writer.writeByte(0);
        break;
      case MessageType.text:
        writer.writeByte(1);
        break;
      case MessageType.init:
        writer.writeByte(2);
        break;
      case MessageType.image:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MarkAdapter extends TypeAdapter<Mark> {
  @override
  final int typeId = 5;

  @override
  Mark read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Mark.like;
      case 1:
        return Mark.dislike;
      case 2:
        return Mark.none;
      default:
        return Mark.like;
    }
  }

  @override
  void write(BinaryWriter writer, Mark obj) {
    switch (obj) {
      case Mark.like:
        writer.writeByte(0);
        break;
      case Mark.dislike:
        writer.writeByte(1);
        break;
      case Mark.none:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
