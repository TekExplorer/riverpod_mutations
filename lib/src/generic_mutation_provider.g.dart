// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_mutation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genericMutationHash() => r'1e9fb42fc1afe9d48fc45d44dda855c15670ec2c';

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
    Object mutationKey,
  ) : this._internal(
          (ref) => genericMutation(
            ref as GenericMutationRef,
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
          mutationKey: mutationKey,
        );

  GenericMutationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mutationKey,
  }) : super.internal();

  final Object mutationKey;

  @override
  Override overrideWith(
    MutationState<void, Future<void> Function()> Function(
            GenericMutationRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenericMutationProvider._internal(
        (ref) => create(ref as GenericMutationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mutationKey: mutationKey,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<MutationState<void, Future<void> Function()>>
      createElement() {
    return _GenericMutationProviderElement(this);
  }

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

mixin GenericMutationRef
    on AutoDisposeProviderRef<MutationState<void, Future<void> Function()>> {
  /// The parameter `mutationKey` of this provider.
  Object get mutationKey;
}

class _GenericMutationProviderElement extends AutoDisposeProviderElement<
    MutationState<void, Future<void> Function()>> with GenericMutationRef {
  _GenericMutationProviderElement(super.provider);

  @override
  Object get mutationKey => (origin as GenericMutationProvider).mutationKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
