import 'package:flutter/material.dart';

/// иконки эмодзи и тд для  [Account] or [Category]
abstract class FinIconData {
  const FinIconData();

  factory FinIconData.icon(IconData iconData) => IconFinIcon(iconData);
  factory FinIconData.emoji(String char) => CharacherFinIcon(char);
  factory FinIconData.image(String path) => ImageFinIcon.ImageFinIcon(path);

  static FinIconData parse(String serialized) {
    final String? type = serialized.split(":").firstOrNull;

    return switch (type) {
      "IconFlowIcon" => IconFinIcon.parse(serialized),
      "ImageFlowIcon" => ImageFinIcon.parse(serialized),
      "CharacterFlowIcon" => CharacherFinIcon.parse(serialized),
      _ => throw UnimplementedError()
    };
  }

  static FinIconData? tryParse(String serialized) {
    try {
      return parse(serialized);
    } catch (e) {
      return null;
    }
  }
}

///   [FinIconData]
///
///
class CharacherFinIcon extends FinIconData {
  final String character;

  CharacherFinIcon._constructor(this.character)
      : assert(character.characters.length == 1);


  factory CharacherFinIcon(String character) {
    return CharacherFinIcon._constructor(
      character.characters.first.toString(),
    );
  }

  @override
  String toString() => "CharacterFlowIcon:$character";

  static FinIconData parse(String serialized) =>
      FinIconData.emoji(serialized.split(":").last);

  static FinIconData? tryParse(String serialized) {
    try {
      return parse(serialized);
    } catch (e) {
      return null;
    }
  }
}

class IconFinIcon extends FinIconData {
  final IconData iconData;

  const IconFinIcon(this.iconData);

  @override
  String toString() {
    return "IconFlowIcon:${iconData.fontFamily},${iconData.fontPackage},${iconData.codePoint.toRadixString(16)}";
  }

  static FinIconData parse(String serialized) {
    final payload = serialized.split(":")[1];

    final [fontFamily, fontPackage, codePointHex] = payload.split(",");

    return FinIconData.icon(IconData(
      int.parse(codePointHex, radix: 16),
      fontFamily: fontFamily,
      fontPackage: fontPackage,
    ));
  }

  static FinIconData? tryParse(String serialized) {
    try {
      return parse(serialized);
    } catch (e) {
      return null;
    }
  }
}

class ImageFinIcon extends FinIconData {

  final String imagePath;

  const ImageFinIcon.ImageFinIcon(this.imagePath);

  @override
  String toString() => "ImageFlowIcon:$imagePath";

  static FinIconData parse(String serialized) {
    final [_, path] = serialized.split(":");
    return FinIconData.image(path);
  }

  static FinIconData? tryParse(String serialized) {
    try {
      return parse(serialized);
    } catch (e) {
      return null;
    }
  }
}
