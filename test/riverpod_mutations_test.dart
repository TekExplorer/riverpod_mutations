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
    setUp(() {
      provider = stringToDoubleProvider;
      container.listen(provider, (p, n) {});
    });

    test('Custom mutation with parameter', () async {
      var exampleMutation = container.read(provider);
      expect(exampleMutation, isA<MutationInitial<double, String>>());

      // final expectedException = Exception('Mutation failed');
      final mutationFuture = exampleMutation('1');

      exampleMutation = container.read(provider);

      expect(
        exampleMutation,
        isA<MutationLoading<double, String>>(),
        reason: 'Mutation is not loading',
      );

      await mutationFuture;

      exampleMutation = container.read(provider);

      expect(
        exampleMutation,
        isA<MutationData<double, String>>(),
        reason: 'Mutation did not succeed',
      );

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

      expect(exampleMutation, isA<MutationData<double, String>>());

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

      expect(
        exampleMutation.error,
        isNotNull,
        reason: 'Mutation does not have an error',
      );

      expect(
        exampleMutation.error,
        isA<FormatException>(),
        reason: 'Mutation error should be a FormatException',
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
    setUp(() {
      provider = genericMutationProvider('mutationKey');
      container.listen(provider, (p, n) {});
    });

    tearDown(() {
      container.invalidate(provider);
    });

    test('Mutation is initial', () {
      final exampleMutation = container.read(provider);
      expect(
        exampleMutation,
        isA<MutationInitial<void, Future<void> Function()>>(),
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
      expect(
        exampleMutation,
        isA<MutationInitial<void, Future<void> Function()>>(),
      );

      final completer = Completer<void>();
      final f = exampleMutation(() async {
        await Future<void>.delayed(const Duration(microseconds: 100));
        return completer.future;
      });

      exampleMutation = container.read(provider);
      expect(
        exampleMutation,
        isA<MutationLoading<void, Future<void> Function()>>(),
        reason: 'Mutation is not loading',
      );

      completer.complete();
      await f;

      exampleMutation = container.read(provider);
      expect(
        exampleMutation,
        isA<MutationData<void, Future<void> Function()>>(),
        reason: 'Mutation has not succeeded',
      );
    });

    test('Mutation fails', () async {
      var exampleMutation = container.read(provider);
      expect(
        exampleMutation,
        isA<MutationInitial<void, Future<void> Function()>>(),
      );

      final expectedException = Exception('Mutation failed');

      final completer = Completer<void>();
      final f = exampleMutation.call(() async {
        await Future<void>.delayed(const Duration(microseconds: 10));
        await completer.future;
        throw expectedException;
      });

      exampleMutation = container.read(provider);

      expect(
        exampleMutation,
        isA<MutationLoading<void, Future<void> Function()>>(),
        reason: 'Mutation is not loading',
      );

      completer.complete();
      await f;

      exampleMutation = container.read(provider);
      expect(
        exampleMutation,
        isA<MutationError<void, Future<void> Function()>>(),
        reason: 'Mutation did not fail',
      );

      expect(
        exampleMutation.error,
        expectedException,
        reason: 'Mutation did not fail with expected exception',
      );
    });
  });
}
