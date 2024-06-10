// Импортируем пакет для сериализации и десериализации JSON данных
import 'package:json_annotation/json_annotation.dart';

// Указываем, что part 'frecency.g.dart' будет содержать сгенерированный код
part 'frecency.g.dart';

// Аннотация @JsonSerializable указывает, что этот класс будет сериализован в JSON и из JSON
@JsonSerializable()
class FrecencyData {
  // Поле для хранения уникального идентификатора
  final String uuid;

  // Поле для хранения времени последнего использования
  final DateTime lastUsed;

  // Поле для хранения количества использований
  final int useCount;

  // Конструктор класса с обязательными параметрами
  const FrecencyData({
    required this.uuid,
    required this.lastUsed,
    required this.useCount,
  });

  // Метод для увеличения счетчика использования и обновления времени последнего использования
  FrecencyData incremented([int increment = 1]) {
    return FrecencyData(
      useCount: useCount + increment,
      lastUsed: DateTime.now(),
      uuid: uuid,
    );
  }

  // Поле для вычисления оценки на основе времени последнего использования и количества использований
  @JsonKey(includeFromJson: false, includeToJson: false)
  double get score {
    // Рассчитываем продолжительность с момента последнего использования
    final Duration sinceLastUsed = DateTime.now().difference(lastUsed);

    // Возвращаем оценку в зависимости от времени, прошедшего с последнего использования
    return switch (sinceLastUsed) {
      >= const Duration(days: 60) => useCount * 0.2, // Если прошло больше 60 дней, оценка уменьшается в 5 раз
      >= const Duration(days: 30) => useCount * 0.5, // Если прошло больше 30 дней, оценка уменьшается в 2 раза
      >= const Duration(days: 14) => useCount * 0.67, // Если прошло больше 14 дней, оценка уменьшается примерно на треть
      >= const Duration(days: 7) => useCount * 0.875, // Если прошло больше 7 дней, оценка уменьшается на восьмую часть
      >= const Duration(hours: 72) => useCount.toDouble(), // Если прошло больше 72 часов, оценка остается неизменной
      >= const Duration(hours: 24) => useCount * 2, // Если прошло больше 24 часов, оценка удваивается
      >= const Duration(hours: 8) => useCount * 3, // Если прошло больше 8 часов, оценка утраивается
      _ => useCount.toDouble(), // В остальных случаях оценка остается неизменной
    };
  }

  // Фабричный метод для создания экземпляра класса из JSON
  factory FrecencyData.fromJson(Map<String, dynamic> json) =>
      _$FrecencyDataFromJson(json);

  // Метод для сериализации объекта в JSON
  Map<String, dynamic> toJson() => _$FrecencyDataToJson(this);
}
