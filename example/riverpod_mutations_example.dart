import 'dart:math';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations/riverpod_mutations.dart';

part 'riverpod_mutations_example.g.dart';

void main(List<String> args) async {
  final container = ProviderContainer();
  container.listen(todosNotifierProvider, (previous, next) {
    next.when(
      data: (data) {
        print('Todos Data: [\n\t${data.join(',\n\t')}\n]');
      },
      error: (error, stack) {
        print('Todos Error: $error');
      },
      loading: () {
        print('Todos Loading...');
      },
    );
  }, fireImmediately: true);

  container.listen(addTodoProvider, (previous, next) {
    next.when(
      initial: () {
        print('AddTodo Initial');
      },
      data: (data) {
        print('Add Todo Success');
      },
      error: (error, stack) {
        print('Add Todo Error: $error');
      },
      loading: () {
        print('Add Todo Loading...');
      },
    );
  }, fireImmediately: true);

  await container.read(todosNotifierProvider.future);

  final addTodo = container.read(addTodoProvider);
  // will randomly fail, for demonstration purposes.
  await addTodo(Todo(title: 'NEW Todo'));
  await container.read(todosNotifierProvider.future);
}

class Todo {
  Todo({required this.title});
  final String timeCreated = DateTime.now().toString();
  final String title;

  @override
  String toString() {
    return 'Todo(title: $title, timeCreated: $timeCreated)';
  }
}

@Riverpod(keepAlive: true)
class TodosNotifier extends _$TodosNotifier {
  @override
  Future<List<Todo>> build() async {
    final list = <Todo>[];

    for (var i = 0; i < 3; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      list.add(Todo(title: 'Todo $i'));
    }

    return list;
  }

  /// example notifier function. randomly throws for demonstration purposes
  Future<void> addTodo(Todo todo) async {
    await Future<void>.delayed(const Duration(seconds: 1), () {
      if (Random().nextBool()) {
        throw Exception('Failed to add todo');
      }
    });
    var newState = [...await future, todo];
    state = AsyncData(newState);
  }
}

@Riverpod(keepAlive: true)
MutationState<void, Todo> addTodo(AddTodoRef ref) {
  // user passes in a `Todo`
  // addTodo is called, with error handling by this provider
  // could use a tearoff
  return MutationState.create((newState) => ref.state = newState, (todo) async {
    return await ref.read(todosNotifierProvider.notifier).addTodo(todo);
  });
}
