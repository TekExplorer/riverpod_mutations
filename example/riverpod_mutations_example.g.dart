// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod_mutations_example.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addTodoHash() => r'35be14fdb9f239976934f94d00fe5a58266ca127';

/// See also [addTodo].
@ProviderFor(addTodo)
final addTodoProvider = Provider<MutationState<void, Todo>>.internal(
  addTodo,
  name: r'addTodoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$addTodoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AddTodoRef = ProviderRef<MutationState<void, Todo>>;
String _$todosNotifierHash() => r'aa94d12eb52013a3c5b8ab8ac90bcad91c157b86';

/// See also [TodosNotifier].
@ProviderFor(TodosNotifier)
final todosNotifierProvider =
    AsyncNotifierProvider<TodosNotifier, List<Todo>>.internal(
  TodosNotifier.new,
  name: r'todosNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todosNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodosNotifier = AsyncNotifier<List<Todo>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
