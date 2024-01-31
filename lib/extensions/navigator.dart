import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  Future<T?> push<T extends Object?>(Widget page, {bool withAnimation = true}) {
    return navigator.push<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },
        transitionDuration: withAnimation
            ? const Duration(
                milliseconds: 300,
              )
            : Duration.zero,
        reverseTransitionDuration: withAnimation
            ? const Duration(
                milliseconds: 300,
              )
            : Duration.zero,
      ),
    );
  }

  void pop<T extends Object?>([T? result]) => navigator.pop<T>(result);
}
