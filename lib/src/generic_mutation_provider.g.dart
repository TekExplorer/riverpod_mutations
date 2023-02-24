// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_mutation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genericMutationHash() => r'2508654a692a465e37c21ccf735b98e28f2b0a53';

/// Copied from Dart SDK
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

typedef GenericMutationRef
    = AutoDisposeProviderRef<MutationState<void, Future<void> Function()>>;

/// generic mutation. pass a function into [call] to execute the mutation
/// the [mutationKey] will allow creating a new provider per context
/// allows you to avoid creating a new mutation definition for every single function
///
/// Copied from [genericMutation].
@ProviderFor(genericMutation)
const genericMutationProvider = GenericMutationFamily();

/// generic mutation. pass a function into [call] to execute the mutation
/// the [mutationKey] will allow creating a new provider per context
/// allows you to avoid creating a new mutation definition for every single function
///
/// Copied from [genericMutation].
class GenericMutationFamily
    extends Family<MutationState<void, Future<void> Function()>> {
  /// generic mutation. pass a function into [call] to execute the mutation
  /// the [mutationKey] will allow creating a new provider per context
  /// allows you to avoid creating a new mutation definition for every single function
  ///
  /// Copied from [genericMutation].
  const GenericMutationFamily();

  /// generic mutation. pass a function into [call] to execute the mutation
  /// the [mutationKey] will allow creating a new provider per context
  /// allows you to avoid creating a new mutation definition for every single function
  ///
  /// Copied from [genericMutation].
  GenericMutationProvider call(
    Object mutationKey,
  ) {
    return GenericMutationProvider(
      mutationKey,
    );
  }

  @override
  GenericMutationProvider getProviderOverride(
    covariant GenericMutationProvider provider,
  ) {
    return call(
      provider.mutationKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'genericMutationProvider';
}

/// generic mutation. pass a function into [call] to execute the mutation
/// the [mutationKey] will allow creating a new provider per context
/// allows you to avoid creating a new mutation definition for every single function
///
/// Copied from [genericMutation].
class GenericMutationProvider
    extends AutoDisposeProvider<MutationState<void, Future<void> Function()>> {
  /// generic mutation. pass a function into [call] to execute the mutation
  /// the [mutationKey] will allow creating a new provider per context
  /// allows you to avoid creating a new mutation definition for every single function
  ///
  /// Copied from [genericMutation].
  GenericMutationProvider(
    this.mutationKey,
  ) : super.internal(
          (ref) => genericMutation(
            ref,
            mutationKey,
          ),
          from: genericMutationProvider,
          name: r'genericMutationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericMutationHash,
          dependencies: GenericMutationFamily._dependencies,
          allTransitiveDependencies:
              GenericMutationFamily._allTransitiveDependencies,
        );

  final Object mutationKey;

  @override
  bool operator ==(Object other) {
    return other is GenericMutationProvider && other.mutationKey == mutationKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mutationKey.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
