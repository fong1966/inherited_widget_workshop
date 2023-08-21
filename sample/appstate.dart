import 'package:flutter/material.dart';

class AppState {
  List<String> productList;
  Set<String> itemsInCart;

  AppState({
    required this.productList,
    this.itemsInCart = const <String>{},
  });

  AppState copyWith({
    List<String>? productList,
    Set<String>? itemsInCart,
  }) =>
      AppState(
        productList: productList ?? this.productList,
        itemsInCart: itemsInCart ?? this.itemsInCart,
      );
}

class AppStateScope extends InheritedWidget {
  final AppState data;

  const AppStateScope(this.data, {super.key, required super.child});

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    return data != oldWidget.data;
  }
}
