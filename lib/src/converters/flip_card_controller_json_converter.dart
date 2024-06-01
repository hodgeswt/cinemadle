import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:json_annotation/json_annotation.dart';

class FlipCardControllerJsonConverter
    extends JsonConverter<FlipCardController, String> {
  const FlipCardControllerJsonConverter() : super();

  @override
  FlipCardController fromJson(String json) {
    return FlipCardController();
  }

  @override
  String toJson(FlipCardController object) {
    return "true";
  }
}
