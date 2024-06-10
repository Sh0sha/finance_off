import 'package:flutter/material.dart';

class FinColors extends ThemeExtension<FinColors> {
  /// Цвет для дохода
  final Color dohod;

  /// Цвет для расхода
  final Color rashod;

  /// Цвет меток и дополнительного основного текста
  final Color semi;

  const FinColors({
    required this.dohod,
    required this.rashod,
    required this.semi,
  });

  @override
  FinColors copyWith({
    Color? dohod,
    Color? rashod,
    Color? semi,
  }) {
    return FinColors(
      dohod: dohod ?? this.dohod,
      rashod: rashod ?? this.rashod,
      semi: semi ?? this.semi,
    );
  }

  @override
  FinColors lerp(FinColors? other, double t) {
    if (other is! FinColors) return this;

    return FinColors(
      dohod: Color.lerp(dohod, other.dohod, t)!,
      rashod: Color.lerp(rashod, other.rashod, t)!,
      semi: Color.lerp(semi, other.semi, t)!,
    );
  }
}
