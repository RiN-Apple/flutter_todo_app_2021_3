import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app/models/todo.dart';

part 'todo_state.freezed.dart';
//flutter pub run build_runner build --delete-conflicting-outputsで生成

//TODOのリスト
@freezed //freezedするとcopyWith()から安全にデータを変更できる
class TodoState with _$TodoState {
  const factory TodoState({
    @Default(<Todo>[]) List<Todo> todoList,
  }) = _TodoState; //@default はfreezedのデフォルト値を入れる記法
}
