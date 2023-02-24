import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_mutations/riverpod_mutations.dart';
import 'package:test/test.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() {
    container = ProviderContainer();
  });

  tearDownAll(() {
    container.dispose();
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
