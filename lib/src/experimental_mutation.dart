import 'package:riverpod/src/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../riverpod_mutations.dart';

part 'experimental_mutation.g.dart';

final myNotifierProvider = MyNotifierProvider(MyNotifier.new);

// Presumably this goes into the ProviderElement
@riverpod
MutationState<void, int> _updateInt(_UpdateIntRef ref) {
  return MutationState<void, int>.fromRef(
    ref,
    ref.read(myNotifierProvider.notifier).updateInt,
  );
}

class MyNotifier extends AutoDisposeAsyncNotifier<int> {
  @override
  FutureOr<int> build() => 1;

  Future<void> updateInt(int i) => Future.delayed(Duration(seconds: 1), () {
        state = AsyncData(i);
      });
}

// ignore: missing_override_of_must_be_overridden, subtype_of_sealed_class
class MyNotifierProvider
    extends AutoDisposeAsyncNotifierProvider<MyNotifier, int> {
  MyNotifierProvider(super.createNotifier);

  // Presumably this points to a ProviderElement variable
  // I'm guessing i would need to extend the element and add the state there
  Refreshable<MutationState<void, int>> get updateInt => _updateIntProvider;

  @override
  bool operator ==(Object other) => other is MyNotifierProvider;

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);

    return _SystemHash.finish(hash);
  }
}

class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}
