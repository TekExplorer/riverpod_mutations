// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod_mutations_example.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$addTodoHash() => r'265710d5c2a79b337b6af72789193fc1c1878060';

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
