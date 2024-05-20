// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductionCountry _$ProductionCountryFromJson(Map<String, dynamic> json) =>
    ProductionCountry(
      iso: json['iso_3166_1'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProductionCountryToJson(ProductionCountry instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso,
      'name': instance.name,
    };
