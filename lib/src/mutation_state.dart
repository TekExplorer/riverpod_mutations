import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stack_trace/stack_trace.dart';

/// AsyncValue-like data class, but includes a ref and callback
/// strictly for use in providers
/// `_fn` is the handler for whatever parameter gets passed in (a call to a notifier function, for example)
/// Param is the type of the value that gets passed in by the front end
/// T is the type of the created data from the call (equivalent to AsyncValue's T)
/// (the type of the `value`)
@immutable
abstract class MutationState<T, Param> {
  const MutationState._(this._ref, this._fn);

  const factory MutationState._initial(
    ProviderRef<MutationState<T, Param>> _ref,
    Future<T> Function(Param p) _fn,
  ) = MutationInitial<T, Param>._;

  factory MutationState.create(
    ProviderRef<MutationState<T, Param>> _ref,
    Future<T> Function(Param p) _fn,
  ) {
    return MutationState<T, Param>._initial(_ref, _fn);
  }

  const factory MutationState._error(
    ProviderRef<MutationState<T, Param>> _ref,
    Future<T> Function(Param p) _fn,
    Object error, {
    required StackTrace stackTrace,
  }) = MutationError<T, Param>._;

  const factory MutationState._data(
    ProviderRef<MutationState<T, Param>> _ref,
    Future<T> Function(Param p) _fn,
    T value,
  ) = MutationData<T, Param>._;

  const factory MutationState._loading(
    ProviderRef<MutationState<T, Param>> _ref,
    Future<T> Function(Param p) _fn,
  ) = MutationLoading<T, Param>._;

  static Future<MutationState<T, P>> _guard<T, P>(
    ProviderRef<MutationState<T, P>> ref,
    Future<T> Function(P p) cb,
    P parameter,
  ) async {
    try {
      return MutationState<T, P>._data(ref, cb, await cb(parameter));
    } catch (e, s) {
      return MutationState<T, P>._error(ref, cb, e, stackTrace: s);
    }
  }

  final ProviderRef<MutationState<T, Param>> _ref;
  bool get isLoading;
  bool get hasValue;
  T? get value;
  Object? get error;
  StackTrace? get stackTrace;
  final Future<T> Function(Param p) _fn;

  void _setState(MutationState<T, Param> state) {
    _ref.state = state.copyWithPrevious(_ref.state);
  }

  Future<MutationState<T, Param>> call(Param parameter) async {
    final cb = this._fn;
    _setState(MutationState<T, Param>._loading(_ref, cb));
    final result = await MutationState._guard<T, Param>(_ref, cb, parameter);
    _setState(result);
    return result;
  }

  R map<R>({
    required R Function(MutationInitial<T, Param> initial) initial,
    required R Function(MutationData<T, Param> data) data,
    required R Function(MutationError<T, Param> error) error,
    required R Function(MutationLoading<T, Param> loading) loading,
  });

  MutationState<T, Param> copyWithPrevious(MutationState<T, Param> previous);

  MutationState<T, Param> unwrapPrevious() {
    return map(
      initial: (i) => MutationInitial<T, Param>._(_ref, _fn),
      data: (d) {
        if (d.isLoading) return MutationLoading<T, Param>._(_ref, _fn);
        return MutationData._(_ref, _fn, d.value!);
      },
      error: (e) {
        if (e.isLoading) return MutationLoading._(_ref, _fn);
        return MutationError._(_ref, _fn, e.error, stackTrace: e.stackTrace);
      },
      loading: (l) => MutationLoading<T, Param>._(_ref, _fn),
    );
  }

  @override
  String toString() {
    final content = [
      if (isLoading && this is! MutationLoading) 'isLoading: $isLoading',
      if (hasValue) 'value: $value',
      if (hasError) ...[
        'error: $error',
        'stackTrace: $stackTrace',
      ],
      if (stackTrace != null) 'stackTrace: $stackTrace',
    ].join(', ');
    return '$runtimeType($content)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is MutationState<T, Param> &&
        other.isInitial == isInitial &&
        other.isLoading == isLoading &&
        other.hasValue == hasValue &&
        other.error == error &&
        other.stackTrace == stackTrace &&
        other.valueOrNull == valueOrNull;
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        isLoading,
        hasValue,
        // Fallback null values to 0, making sure Object.hash hashes all values
        valueOrNull ?? 0,
        error ?? 0,
        stackTrace ?? 0,
      );
}

class MutationInitial<T, F> extends MutationState<T, F> {
  const MutationInitial._(super._ref, super._fn) : super._();

  @override
  T? get value => null;

  @override
  bool get hasValue => false;

  @override
  bool get isLoading => false;

  @override
  StackTrace? get stackTrace => null;

  @override
  Object? get error => null;

  @override
  R map<R>(
      {required R Function(MutationInitial<T, F> initial) initial,
      required R Function(MutationData<T, F> data) data,
      required R Function(MutationError<T, F> error) error,
      required R Function(MutationLoading<T, F> loading) loading}) {
    return initial(this);
  }

  @override
  MutationState<T, F> copyWithPrevious(MutationState<T, F> previous) {
    // We shouldn't even have a previous value if we are initial
    return this;
  }
}

class MutationLoading<T, F> extends MutationState<T, F> {
  const MutationLoading._(super._ref, super._fn)
      : hasValue = false,
        value = null,
        error = null,
        stackTrace = null,
        super._();

  const MutationLoading.__(
    super._ref,
    super._fn, {
    required this.hasValue,
    required this.value,
    required this.error,
    required this.stackTrace,
  }) : super._();

  @override
  bool get isLoading => true;

  @override
  final bool hasValue;

  @override
  final T? value;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  @override
  R map<R>({
    required R Function(MutationInitial<T, F> initial) initial,
    required R Function(MutationData<T, F> data) data,
    required R Function(MutationError<T, F> error) error,
    required R Function(MutationLoading<T, F> loading) loading,
  }) {
    return loading(this);
  }

  @override
  MutationState<T, F> copyWithPrevious(
    MutationState<T, F> previous, {
    bool isRefresh = true,
  }) {
    if (isRefresh) {
      return previous.map(
        initial: (_) => this,
        data: (d) => MutationData.__(
          _ref,
          _fn,
          d.value,
          isLoading: true,
          error: d.error,
          stackTrace: d.stackTrace,
        ),
        error: (e) => MutationError.__(
          _ref,
          _fn,
          e.error,
          isLoading: true,
          value: e.valueOrNull,
          stackTrace: e.stackTrace,
          hasValue: e.hasValue,
        ),
        loading: (_) => this,
      );
    } else {
      return previous.map(
        initial: (_) => this,
        data: (e) => MutationLoading.__(
          _ref,
          _fn,
          hasValue: true,
          value: e.valueOrNull,
          error: e.error,
          stackTrace: e.stackTrace,
        ),
        error: (e) => MutationLoading.__(
          _ref,
          _fn,
          hasValue: e.hasValue,
          value: e.valueOrNull,
          error: e.error,
          stackTrace: e.stackTrace,
        ),
        loading: (e) => e,
      );
    }
  }
}

class MutationData<T, F> extends MutationState<T, F> {
  const MutationData._(super._ref, super._fn, this.value)
      : isLoading = false,
        error = null,
        stackTrace = null,
        super._();

  const MutationData.__(
    super._ref,
    super._fn,
    this.value, {
    required this.isLoading,
    required this.error,
    required this.stackTrace,
  }) : super._();

  @override
  final T value;

  @override
  bool get hasValue => true;

  @override
  final bool isLoading;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  @override
  R map<R>({
    required R Function(MutationInitial<T, F> initial) initial,
    required R Function(MutationData<T, F> data) data,
    required R Function(MutationError<T, F> error) error,
    required R Function(MutationLoading<T, F> loading) loading,
  }) {
    return data(this);
  }

  @override
  MutationState<T, F> copyWithPrevious(MutationState<T, F> previous) => this;
}

class MutationError<T, F> extends MutationState<T, F> {
  const MutationError.__(
    super._ref,
    super._fn,
    this.error, {
    required this.stackTrace,
    required this.isLoading,
    required T? value,
    required this.hasValue,
  })  : _value = value,
        super._();

  const MutationError._(super._ref, super._fn, this.error,
      {required this.stackTrace})
      : isLoading = false,
        hasValue = false,
        _value = null,
        super._();

  @override
  final bool isLoading;

  @override
  final bool hasValue;

  @override
  T? get value {
    if (!hasValue) {
      throwErrorWithCombinedStackTrace(error, stackTrace);
    }
    return _value;
  }

  final T? _value;

  @override
  final Object error;
  @override
  final StackTrace stackTrace;

  @override
  R map<R>({
    required R Function(MutationInitial<T, F> initial) initial,
    required R Function(MutationData<T, F> data) data,
    required R Function(MutationError<T, F> error) error,
    required R Function(MutationLoading<T, F> loading) loading,
  }) {
    return error(this);
  }

  @override
  MutationState<T, F> copyWithPrevious(MutationState<T, F> previous) {
    return MutationError.__(
      _ref,
      _fn,
      error,
      stackTrace: stackTrace,
      isLoading: isLoading,
      value: previous.valueOrNull,
      hasValue: previous.hasValue,
    );
  }
}

extension MutationValueX<T, F> on MutationState<T, F> {
  bool get isInitial => this is MutationInitial;
  T get requireValue {
    if (hasValue) return value as T;
    if (hasError) throwErrorWithCombinedStackTrace(error!, stackTrace!);
    throw StateError(
      'Tried to call `requireValue` on a `MutationValue`'
      ' that has no value: $this',
    );
  }

  T? get valueOrNull => hasValue ? value : null;
  bool get isRerunning =>
      isLoading && (hasValue || hasError) && this is! MutationLoading;

  bool get hasError => error != null;
  MutationData<T, F>? get asData =>
      maybeMap(data: (d) => d, orElse: () => null);

  MutationError<T, F>? get asError =>
      maybeMap(error: (e) => e, orElse: () => null);

  R maybeWhen<R>({
    bool skipLoadingOnRerun = false,
    bool skipError = false,
    R Function()? initial,
    R Function(T value)? data,
    R Function(Object error, StackTrace stackTrace)? error,
    R Function()? loading,
    required R Function() orElse,
  }) {
    return when(
      skipError: skipError,
      skipLoadingOnRerun: skipLoadingOnRerun,
      initial: initial ?? orElse,
      loading: loading ?? orElse,
      data: (d) {
        if (data != null) return data(d);
        return orElse();
      },
      error: (e, s) {
        if (error != null) return error(e, s);
        return orElse();
      },
    );
  }

  R when<R>({
    bool skipLoadingOnRerun = false,
    bool skipError = false,
    required R Function() initial,
    required R Function(T data) data,
    required R Function(Object error, StackTrace stackTrace) error,
    required R Function() loading,
  }) {
    if (isInitial) {
      return initial();
    }

    if (isLoading) {
      bool skip;
      if (isRerunning) {
        skip = skipLoadingOnRerun;
      } else {
        skip = false;
      }
      if (!skip) return loading();
    }

    if (hasError && (!hasValue || !skipError)) {
      return error(this.error!, stackTrace!);
    }

    return data(requireValue);
  }

  R? whenOrNull<R>({
    bool skipLoadingOnRerun = false,
    bool skipError = false,
    R? Function()? initial,
    R? Function(T data)? data,
    R? Function(Object error, StackTrace stackTrace)? error,
    R? Function()? loading,
  }) {
    return when(
      skipError: skipError,
      skipLoadingOnRerun: skipLoadingOnRerun,
      initial: initial ?? () => null,
      data: data ?? (_) => null,
      error: error ?? (err, stack) => null,
      loading: loading ?? () => null,
    );
  }

  R maybeMap<R>({
    R Function(MutationInitial<T, F> initial)? initial,
    R Function(MutationData<T, F> data)? data,
    R Function(MutationError<T, F> error)? error,
    R Function(MutationLoading<T, F> loading)? loading,
    required R Function() orElse,
  }) {
    return map(
      initial: (i) {
        if (initial != null) return initial(i);
        return orElse();
      },
      data: (d) {
        if (data != null) return data(d);
        return orElse();
      },
      error: (e) {
        if (error != null) return error(e);
        return orElse();
      },
      loading: (l) {
        if (loading != null) return loading(l);
        return orElse();
      },
    );
  }
}

Never throwErrorWithCombinedStackTrace(Object error, StackTrace stackTrace) {
  final chain = Chain([
    Trace.current(),
    ...Chain.forTrace(stackTrace).traces,
  ]).foldFrames((frame) => frame.package == 'riverpod');

  Error.throwWithStackTrace(error, chain);
}
