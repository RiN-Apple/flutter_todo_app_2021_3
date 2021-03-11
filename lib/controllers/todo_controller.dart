import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/todo_state.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid(); //idの生成をするクラス

//リストの状態の変更、画面全体への変更の通知を行う
class TodoController extends StateNotifier<TodoState> {
  TodoController() : super(const TodoState());

  //リストに追加
  void add(String title) {
    state = state.copyWith(
        todoList: [...state.todoList, Todo(id: _uuid.v4(), title: title)]);
  }

  //リストから削除
  void remove(String id) {
    state = state.copyWith(
        todoList: state.todoList.where((todo) => todo.id != id).toList());
  }

  //タスクの完了・未完了の切り替え
  void toggle(String id) {
    state = state.copyWith(
        todoList: state.todoList
            .map((todo) =>
                todo.id == id ? todo.copyWith(isDone: !todo.isDone) : todo)
            .toList());
  }

  void deleteAll() {
    state = state.copyWith(todoList: []);
  }
}
