import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_mutations/riverpod_mutations.dart';
import 'package:test/test.dart';

import 'custom_mutation.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() {
    container = ProviderContainer();
  });

  tearDownAll(() {
    container.dispose();
  });

  group('Custom Mutation Tests', () {
    late AutoDisposeProvider<MutationState<double, String>> provider;
    // ignore: no_leading_underscores_for_local_identifiers
    late ProviderSubscription _subscription;

    setUp(() {
      provider = stringToNumProvider;
      // keep it alive for the tests
      _subscription = container.listen(provider, (previous, next) {});
    });

    tearDown(() {
      _subscription.close();
    });
    test('Custom mutation with parameter', () async {
      var exampleMutation = container.read(provider);
      expect(exampleMutation, isA<MutationInitial>());

      // final expectedException = Exception('Mutation failed');
      final mutationFuture = exampleMutation('1');

      exampleMutation = container.read(provider);

      expect(
        exampleMutation,
        isA<MutationLoading>(),
        reason: 'Mutation is not loading',
      );

      await mutationFuture;

      exampleMutation = container.read(provider);

      expect(
        exampleMutation,
        isA<MutationData<double, String>>(),
        reason: 'Mutation did not succeed',
      );

      exampleMutation is MutationData;
      expect(
        exampleMutation.valueOrNull,
        isNotNull,
        reason: 'Mutation does not have a value',
      );

      expect(
        exampleMutation.valueOrNull,
        1,
        reason: 'Mutation value is not correct',
      );

      // lets give it another go, this time it will fail. same provider.
      exampleMutation = container.read(provider);

      expect(exampleMutation, isA<MutationData>());

      final mutationFuture2 = exampleMutation('Invalid input');

      exampleMutation = container.read(provider);

      expect(
        exampleMutation.isLoading,
        isTrue,
        reason: 'Mutation is not loading again',
      );

      // previous value should still be there
      expect(
        exampleMutation.valueOrNull,
        1,
        reason: 'Mutation value should not have changed',
      );

      await mutationFuture2;

      exampleMutation = container.read(provider);

      expect(
        exampleMutation.hasError,
        isTrue,
        reason: 'Mutation does not have an error',
      );

      expect(
        exampleMutation,
        isA<MutationError<double, String>>(),
        reason: 'Mutation did not fail',
      );

      exampleMutation is MutationError;

      expect(
        exampleMutation.error,
        isNotNull,
        reason: 'Mutation does not have an error',
      );

      expect(
        exampleMutation.error,
        isA<FormatException>(),
        reason: 'Mutation error is not correct',
      );

      // mutation value should still be there
      expect(
        exampleMutation.valueOrNull,
        1,
        reason: 'Mutation value should STILL not have changed',
      );
    });
  });

  group('Mutation Tests', () {
    late GenericMutationProvider provider;
    // ignore: no_leading_underscores_for_local_identifiers
    late ProviderSubscription _subscription;

    setUp(() {
      provider = genericMutationProvider('exampleKey');
      // keep it alive for the tests
      _subscription = container.listen(provider, (previous, next) {});
    });

    tearDown(() {
      _subscription.close();
    });

    test('Mutation is initial', () {
      var exampleMutation = container.read(provider);
      expect(
        exampleMutation,
        isA<MutationInitial>(),
        reason: 'Mutation is not initial',
      );
      expect(
        exampleMutation.maybeMap(
          orElse: () => false,
          initial: (_) => true,
        ),
        isTrue,
        reason: 'Mutation is not initial',
      );
    });

    test('Mutation succeeds', () async {
      var exampleMutation = container.read(provider);
      expect(exampleMutation, isA<MutationInitial>());

      final completer = Completer();
      exampleMutation.call(() async {
        await Future.delayed(Duration(microseconds: 10));
        completer.complete();
      });

      exampleMutation = container.read(provider);
      expect(
        exampleMutation,
        isA<MutationLoading>(),
        reason: 'Mutation is not loading',
      );

      await completer.future;

      exampleMutation = container.read(provider);
      expect(
        exampleMutation,
        isA<MutationData>(),
        reason: 'Mutation has not succeeded',
      );
    });

    test('Mutation fails', () async {
      var exampleMutation = container.read(provider);
      expect(exampleMutation, isA<MutationInitial>());

      final expectedException = Exception('Mutation failed');

      final completer = Completer();
      exampleMutation.call(() async {
        await Future.delayed(Duration(microseconds: 10));
        completer.complete();
        throw expectedException;
      });

      exampleMutation = container.read(provider);

      expect(
        exampleMutation,
        isA<MutationLoading>(),
        reason: 'Mutation is not loading',
      );

      await completer.future;

      exampleMutation = container.read(provider);
      expect(
        exampleMutation,
        isA<MutationError>(),
        reason: 'Mutation did not fail',
      );
      exampleMutation is MutationError;
      expect(
        exampleMutation.error,
        expectedException,
        reason: 'Mutation did not fail with expected exception',
      );
    });
  });
}
