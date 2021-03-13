import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/todo_state.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid(); //idの生成をするクラス

//リストの状態の変更、画面全体への変更の通知を行う
class TodoController extends StateNotifier<TodoState> {
  TodoController() : super(const TodoState());

  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  late StreamSubscription _todoListener; //初期値なしにするにはlateをつける
  late CollectionReference _todoPath;

  //ログアウト時の停止処理
  Future<void> disposeStream() async {
    if (_todoListener != null) {
      await _todoListener.cancel();
    }
  }

  //FireStoreのリアルタイムアップデートを開始する関数
  void subScribeStream() {
    _todoPath = _store
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('todo_list');
    _todoListener = _todoPath.snapshots().listen((snapshot) {
      if (snapshot != null) {
        //Todo型に変換した新規分のリスト
        final List<Todo> newTodos =
            snapshot.docs.map((doc) => Todo.fromMap(doc)).toList();
        //stateに追加
        state = state.copyWith(todoList: [...newTodos]);
      }
    });
  }

  //リストに追加
  void add(String title) {
    // state = state.copyWith(
    //     todoList: [...state.todoList, Todo(id: _uuid.v4(), title: title)]);
    final _newTodo = Todo(id: _uuid.v4(), title: title);
    _todoPath.doc(_newTodo.id).set(Todo.toMap(_newTodo));
  }

  //リストから削除
  void remove(Todo todo) {
    // state = state.copyWith(
    //     todoList: state.todoList.where((todo) => todo.id != id).toList());
    _todoPath.doc(todo.id).delete();
  }

  //タスクの完了・未完了の切り替え
  void toggle(Todo todo) {
    // state = state.copyWith(
    //     todoList: state.todoList
    //         .map((todo) =>
    //             todo.id == id ? todo.copyWith(isDone: !todo.isDone) : todo)
    //         .toList());
    _todoPath.doc(todo.id).update({'isDone': !todo.isDone});
  }
}
