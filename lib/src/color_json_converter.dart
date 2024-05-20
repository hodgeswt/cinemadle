import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorJsonConverter extends JsonConverter<Color?, String> {
  const ColorJsonConverter() : super();

  @override
  Color? fromJson(String json) {
    if (json == "") {
      return null;
    }

    return Color(int.parse(json));
  }

  @override
  String toJson(Color? object) {
    return object?.value.toString() ?? "";
  }
}
