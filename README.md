<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A simple package to implement mutations for riverpod
- Intended to be a stop-gap measure intended to be replaced by official riverpod mutations, once they are implemented.
- Intended to be hopefully api-compatible with riverpod mutations once they are implemented.

## Features

Simply and intuitively handle the state of any async function

## Getting started

```yaml
dependencies:
  riverpod_mutations: ^1.0.0
  # or flutter_riverpod or hooks_riverpod
  riverpod: ^2.2.0
  # For generator
  riverpod_annotation: ^1.2.1

# Generator
dev_dependencies:
  riverpod_generator: ^1.2.0
  build_runner: ^2.3.3
```

## Usage

```dart
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations/riverpod_mutations.dart';

part 'riverpod_mutations_example.g.dart';

@riverpod
MutationState<double, String> stringToDouble(StringToDoubleRef ref) {
  // user passes in a String
  // the string gets parsed.
  // if successful, you get a MutationData
  // if failed (invalid input) you get a MutationError
  return MutationState.create(ref, (something) async {
    await Future.delayed(Duration(seconds: 1));
    print('Got $something');
    return double.parse(something);
  });
}

example(ref) {
  final stringToDouble = ref.watch(stringToDoubleProvider);
  stringToDouble('4.7');
}
```

## Additional information

File issues on github.

This package is intended to be superseded by riverpod's own eventual implementation
