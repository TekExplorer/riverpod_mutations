import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations/riverpod_mutations.dart';

part 'custom_mutation.g.dart';

@riverpod
MutationState<double, String> stringToNum(StringToNumRef ref) {
  return MutationState.create(ref, double.parse);
}
