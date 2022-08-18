// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// An immutable object that can provide functional copies of itself.
///
/// All implementers are expected to be immutable as defined by the annotation.
// TODO(bparrishMines): Uncomment annotation once
// https://github.com/flutter/plugins/pull/5831 lands or when making a breaking
// change for https://github.com/flutter/flutter/issues/107199.
// @immutable
mixin Copyable {
  /// Instantiates and returns a functionally identical object to oneself.
  ///
  /// Outside of tests, this method should only ever be called by
  /// [InstanceManager].
  ///
  /// Subclasses should always override their parent's implementation of this
  /// method.
  @protected
  Copyable copy();
}

/// Maintains instances used to communicate with the native objects they
/// represent.
///
/// Added instances are stored as weak references and their copies are stored
/// as strong references to maintain access to their variables and callback
/// methods. Both are stored with the same identifier.
///
/// When a weak referenced instance becomes inaccessible,
/// [onWeakReferenceRemoved] is called with its associated identifier.
///
/// If an instance is retrieved and has the possibility to be used,
/// (e.g. calling [getInstanceWithWeakReference]) a copy of the strong reference
/// is added as a weak reference with the same identifier. This prevents a
/// scenario where the weak referenced instance was released and then later
/// returned by the host platform.
class InstanceManager {
  /// Constructs an [InstanceManager].
  InstanceManager({required void Function(int) onWeakReferenceRemoved}) {
    this.onWeakReferenceRemoved = (int identifier) {
      debugPrint('Releasing weak reference with identifier: $identifier');
      _weakInstances.remove(identifier);
      onWeakReferenceRemoved(identifier);
    };
    _finalizer = Finalizer<int>(this.onWeakReferenceRemoved);
  }

  // Identifiers are locked to a specific range to avoid collisions with objects
  // created simultaneously by the host platform.
  // Host uses identifiers >= 2^16 and Dart is expected to use values n where,
  // 0 <= n < 2^16.
  static const int _maxDartCreatedIdentifier = 65536;

  // Expando is used because it doesn't prevent its keys from becoming
  // inaccessible. This allows the manager to efficiently retrieve an identifier
  // of an instance without holding a strong reference to that instance.
  //
  // It also doesn't use `==` to search for identifiers, which would lead to an
  // infinite loop when comparing an object to its copy. (i.e. which was caused
  // by calling instanceManager.getIdentifier() inside of `==` while this was a
  // HashMap).
  final Expando<int> _identifiers = Expando<int>();
  final Map<int, WeakReference<Object>> _weakInstances =
      <int, WeakReference<Object>>{};
  final Map<int, Object> _strongInstances = <int, Object>{};
  final Map<int, Function> _copyCallbacks = <int, Function>{};
  late final Finalizer<int> _finalizer;
  int _nextIdentifier = 0;

  /// Called when a weak referenced instance is removed by [removeWeakReference]
  /// or becomes inaccessible.
  late final void Function(int) onWeakReferenceRemoved;

  /// Adds a new instance that was instantiated by Dart.
  ///
  /// In other words, Dart wants to add a new instance that will represent
  /// an object that will be instantiated on the host platform.
  ///
  /// Throws assertion error if the instance has already been added.
  ///
  /// Returns the randomly generated id of the [instance] added.
  int addDartCreatedInstance<T extends Object>(
    T instance, {
    required T Function(T original) onCopy,
  }) {
    assert(getIdentifier(instance) == null);

    final int identifier = _nextUniqueIdentifier();
    _addInstanceWithIdentifier(instance, identifier, onCopy: onCopy);
    return identifier;
  }

  /// Removes the instance, if present, and call [onWeakReferenceRemoved] with
  /// its identifier.
  ///
  /// Returns the identifier associated with the removed instance. Otherwise,
  /// `null` if the instance was not found in this manager.
  ///
  /// This does not remove the the strong referenced instance associated with
  /// [instance]. This can be done with [remove].
  int? removeWeakReference(Object instance) {
    final int? identifier = getIdentifier(instance);
    if (identifier == null) {
      return null;
    }

    _identifiers[instance] = null;
    _finalizer.detach(instance);
    onWeakReferenceRemoved(identifier);

    return identifier;
  }

  /// Removes [identifier] and its associated strongly referenced instance, if
  /// present, from the manager.
  ///
  /// Returns the strong referenced instance associated with [identifier] before
  /// it was removed. Returns `null` if [identifier] was not associated with
  /// any strong reference.
  ///
  /// This does not remove the the weak referenced instance associtated with
  /// [identifier]. This can be done with [removeWeakReference].
  T? remove<T extends Object>(int identifier) {
    debugPrint('Releasing strong reference with identifier: $identifier');
    _copyCallbacks.remove(identifier);
    return _strongInstances.remove(identifier) as T?;
  }

  /// Retrieves the instance associated with identifier.
  ///
  /// The value returned is chosen from the following order:
  ///
  /// 1. A weakly referenced instance associated with identifier.
  /// 2. If the only instance associated with identifier is a strongly
  /// referenced instance, a copy of the instance is added as a weak reference
  /// with the same identifier. Returning the newly created copy.
  /// 3. If no instance is associated with identifier, returns null.
  ///
  /// This method also expects the host `InstanceManager` to have a strong
  /// reference to the instance the identifier is associated with.
  T? getInstanceWithWeakReference<T extends Object>(int identifier) {
    final Object? weakInstance = _weakInstances[identifier]?.target;

    if (weakInstance == null) {
      final Object? strongInstance = _strongInstances[identifier];
      if (strongInstance != null) {
        final Object copy =
            _copyCallbacks[identifier]!(strongInstance)! as Object;
        _identifiers[copy] = identifier;
        _weakInstances[identifier] = WeakReference<Object>(copy);
        _finalizer.attach(copy, identifier, detach: copy);
        return copy as T;
      }
      return strongInstance as T?;
    }

    return weakInstance as T;
  }

  /// Retrieves the identifier associated with instance.
  int? getIdentifier(Object instance) {
    return _identifiers[instance];
  }

  /// Adds a new instance that was instantiated by the host platform.
  ///
  /// In other words, the host platform wants to add a new instance that
  /// represents an object on the host platform. Stored with [identifier].
  ///
  /// Throws assertion error if the instance or its identifier has already been
  /// added.
  ///
  /// Returns unique identifier of the [instance] added.
  void addHostCreatedInstance<T extends Object>(
    T instance,
    int identifier, {
    required T Function(T original) onCopy,
  }) {
    assert(!containsIdentifier(identifier));
    assert(getIdentifier(instance) == null);
    assert(identifier >= 0);
    _addInstanceWithIdentifier(instance, identifier, onCopy: onCopy);
  }

  void _addInstanceWithIdentifier<T extends Object>(
    T instance,
    int identifier, {
    required T Function(T original) onCopy,
  }) {
    _identifiers[instance] = identifier;
    _weakInstances[identifier] = WeakReference<Object>(instance);
    _finalizer.attach(instance, identifier, detach: instance);

    final Object copy = onCopy(instance);
    _identifiers[copy] = identifier;
    _strongInstances[identifier] = copy;
    _copyCallbacks[identifier] = onCopy;
  }

  /// Whether this manager contains the given [identifier].
  bool containsIdentifier(int identifier) {
    return _weakInstances.containsKey(identifier) ||
        _strongInstances.containsKey(identifier);
  }

  int _nextUniqueIdentifier() {
    late int identifier;
    do {
      identifier = _nextIdentifier;
      _nextIdentifier = (_nextIdentifier + 1) % _maxDartCreatedIdentifier;
    } while (containsIdentifier(identifier));
    return identifier;
  }
}
