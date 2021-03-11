import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

//TODOの雛形
@freezed
class Todo with _$Todo {
  const factory Todo(
      {required String id,
      required String title,
      @Default(false) bool isDone}) = _Todo;
}
