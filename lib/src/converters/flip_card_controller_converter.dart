import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:json_annotation/json_annotation.dart';

class FlipCardControllerListConverter
    extends JsonConverter<List<FlipCardController>?, String> {
  const FlipCardControllerListConverter() : super();

  @override
  List<FlipCardController>? fromJson(String json) {
    int? parsed = int.tryParse(json);
    if (json == "" || parsed == null) {
      return [];
    }

    List<FlipCardController> controllers = [];

    for (int i = 0; i < parsed; i++) {
      controllers.add(FlipCardController());
    }

    return controllers;
  }

  @override
  String toJson(List<FlipCardController>? object) {
    return object?.length.toString() ?? "0";
  }
}
