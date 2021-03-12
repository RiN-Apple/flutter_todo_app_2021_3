import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/controllers/todo_controller.dart';
import 'package:todo_app/main.dart';

import 'models/todo.dart';

//プロバイダー
final todoListProvider = StateNotifierProvider((ref) => TodoController());

//フィルターの状態
String filterState = 'すべて';

final filterStateProvider = StateProvider<String>((_) => filterState = 'すべて');
//フィルターされたTODOリスト
final Provider filteredTodosProvider = Provider((ref) {
  final filter = ref.watch(filterStateProvider);
  final todos = ref.watch(todoListProvider.state);
  switch (filter.state) {
    case '完了':
      return todos.todoList.where((todo) => todo.isDone).toList();
    case '未完了':
      return todos.todoList.where((todo) => !todo.isDone).toList();
    case 'すべて':
    default:
      return todos.todoList;
  }
});

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _SignOutWithGoogle() async {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => LoginCheck()), (_) => false);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('TODOリスト'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _SignOutWithGoogle)
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          ToolBar(),
          Divider(color: Colors.black),
          ChangeFilterButton(),
          TodoItems(),
        ],
      ),
    );
  }
}

//ツールバー　追加ボタン
class ToolBar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _todo = '';
    final _focusNode = FocusNode();
    return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'TODO'),
                maxLength: 20,
                focusNode: _focusNode,
                validator: (text) {
                  return text!.isEmpty ? 'TODOを入力してください' : null;
                },
                onSaved: (value) {
                  _todo = value!;
                },
              ),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 15),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'TODOを追加',
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        context.read(todoListProvider).add(_todo);
                        _todo = '';
                        _formKey.currentState!.reset();
                        _focusNode.unfocus();
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}

//フィルター選択

class ChangeFilterButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final filterState = useProvider(filterStateProvider);
    return DropdownButton(
      value: filterState.state,
      items: [
        DropdownMenuItem(
          value: 'すべて',
          child: Text('すべて'),
        ),
        DropdownMenuItem(value: '完了', child: Text('完了')),
        DropdownMenuItem(value: '未完了', child: Text('未完了')),
      ],
      onChanged: (String? value) {
        context.read(filterStateProvider).state = value!;
      },
    );
  }
}

//todoカードのリスト
class TodoItems extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final filteredtodos = useProvider(filteredTodosProvider);
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: filteredtodos.length,
        itemBuilder: (BuildContext context, int index) {
          return ProviderScope(
            overrides: [_currentTodo.overrideWithValue(filteredtodos[index])],
            child: TodoItem(),
          );
        },
      ),
    );
  }
}

final _currentTodo = ScopedProvider<Todo>(null);

//todoカード
class TodoItem extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final todo = useProvider(_currentTodo);
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (value) {
            context.read(todoListProvider).toggle(todo.id);
          },
        ),
        title: Center(
          child: Text(
            todo.title,
            style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 25.0),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            context.read(todoListProvider).remove(todo.id);
          },
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }
}
