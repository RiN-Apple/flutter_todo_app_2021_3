import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
//flutter pub run build_runner build --delete-conflicting-outputsで生成

//TODOの雛形
@freezed
class Todo with _$Todo {
  const factory Todo(
      {required String id,
      required String title,
      @Default(false) bool isDone}) = _Todo;

  //freezeでメソッドを動かすために必要
  const Todo._();

  // Map型 key and value の型

  //fireStoreからのデータからtodoをインスタンス化
  factory Todo.fromMap(DocumentSnapshot doc) {
    return Todo(
      id: doc.id,
      title: doc.data()!['title'] as String,
      isDone: doc.data()!['isDone'] as bool,
    );
  }

  //FireStore用のMapに変換
  static Map<String, dynamic> toMap(Todo todo) {
    return <String, dynamic>{
      'title': todo.title,
      'isDone': todo.isDone,
    };
  }
}
