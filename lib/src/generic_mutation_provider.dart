import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'mutation_state.dart';

// make sure consumers see the extension
export 'mutation_state.dart';

part 'generic_mutation_provider.g.dart';

/// generic mutation. pass a function into [call] to execute the mutation
/// the [mutationKey] will allow creating a new provider per context
/// allows you to avoid creating a new mutation definition for every single function
@riverpod
MutationState<void, Future<void> Function()> genericMutation(
    GenericMutationRef ref, Object mutationKey) {
  // simply calls the function provided by the user
  return MutationState.fromRef(ref, (fn) => fn());
}
