import 'package:riverpod/riverpod.dart';
import 'package:riverpod_mutations/src/experimental_mutation.dart';
import 'package:riverpod_mutations/src/mutation_state.dart';
import 'package:test/test.dart';

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

void main() {
  // group(description, () => null)
  test(
    'check if experiment notifier works normally',
    () {
      final container = createContainer();

      final subscription =
          container.listen(myNotifierProvider, (previous, next) {});

      // Equivalent to `container.read(provider)`
      // But the provider will not be disposed unless "subscription" is disposed.
      final firstValue = subscription.read();
      expect(
        firstValue,
        isA<AsyncValue<int>>(),
        reason: 'WTF this is whack',
      );

      expect(
        firstValue,
        isA<AsyncData<int>>(),
        reason: 'Should have been an AsyncData as build eagerly returns.',
      );

      expect(
        firstValue.valueOrNull,
        1,
        reason: 'Initial value is 1',
      );
    },
  );

  test('test updateInt', () async {
    final container = createContainer();

    final subscription =
        container.listen(myNotifierProvider, (previous, next) {});

    // Equivalent to `container.read(provider)`
    // But the provider will not be disposed unless "subscription" is disposed.
    var value = subscription.read();
    expect(value.valueOrNull, 1);

    final notifierSubscription =
        container.listen(myNotifierProvider.notifier, (previous, next) {});

    final notifier = notifierSubscription.read();

    expect(notifier, isA<MyNotifier>());
    await expectLater(notifier.updateInt(2), completes);

    container.pump();
    value = subscription.read();
    // Not checking the mutation yet. it just does it.
    expect(value, isA<AsyncData>());
    expect(value.valueOrNull, 2);
  });

  test('test updateInt mutation', () async {
    final container = createContainer();

    final valueSubscription =
        container.listen(myNotifierProvider, (previous, next) {});
    final updateIntSubscription =
        container.listen(myNotifierProvider.updateInt, (previous, next) {});

    // Equivalent to `container.read(provider)`
    // But the provider will not be disposed unless "subscription" is disposed.
    var mutation = updateIntSubscription.read();

    expect(mutation, isA<MutationInitial>());

    final future = expectLater(mutation(2), completion(isA<MutationData>()));

    container.pump();

    mutation = updateIntSubscription.read();
    expect(mutation, isA<MutationLoading>());

    await future;

    container.pump();

    mutation = updateIntSubscription.read();
    expect(mutation, isA<MutationData>());

    final value = valueSubscription.read();

    expect(value, isA<AsyncData>());
    expect(value.valueOrNull, 2);

    // expect(firstValue, isA<MutationLoading>());
  });
//
}
