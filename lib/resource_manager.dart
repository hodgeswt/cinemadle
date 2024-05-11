import 'dart:convert';

import 'package:cinemadle/resources.dart';
import 'package:cinemadle/utils.dart';
import 'package:json_schema/json_schema.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/services.dart' show rootBundle;

class ResourceManager {
  static ResourceManager? _instance;

  String get panicModeMessage {
    if (panicMode) {
      return _panicModeMessage;
    } else {
      return Utils.emptyString;
    }
  }

  bool resourcesLoaded = false;
  bool panicMode = false;

  bool _resourcesFileExists = false;

  late String culture;

  late String _panicModeMessage;

  final Map<String, String> _resources = <String, String>{};

  static ResourceManager get instance {
    _instance ??= ResourceManager._();

    return _instance!;
  }

  ResourceManager._() {
    culture = Platform.localeName;
  }

  String getResource(Resources name, {String? defaultReturn}) {
    return _getResourceInternal(name.toString().split('.').last,
        defaultReturn: defaultReturn);
  }

  String getResourceByString(String name, {String? defaultReturn}) {
    return _getResourceInternal(name, defaultReturn: defaultReturn);
  }

  String _getResourceInternal(String name, {String? defaultReturn}) {
    defaultReturn ??= Utils.emptyString;

    if (panicMode) {
      return defaultReturn;
    }

    if (_resources.containsKey(name)) {
      return _resources[name]!;
    }

    return defaultReturn;
  }

  Future<bool> loadResources() async {
    if (resourcesLoaded) {
      return true;
    }

    if (panicMode) {
      return false;
    }

    String currentError = "Failed loading asset manifest";

    // We just have to trust these two exist
    String manifestAssetName = "manifest.json";
    String manifestSchemaAssetName = "manifest.schema.json";

    try {
      String manifestData = await rootBundle.loadString(manifestAssetName);

      currentError = "Failed loading asset manifest schema";
      String manifestSchemaData =
          await rootBundle.loadString(manifestSchemaAssetName);

      JsonSchema manifestSchema = JsonSchema.create(manifestSchemaData);
      var results = manifestSchema.validate(manifestData, parseJson: true);

      if (!results.isValid) {
        _enterPanicMode("Manifest failed to validate against schema.");
        return false;
      }

      currentError = "Failed deserializing manifest data.";
      Map<String, dynamic> manifest = jsonDecode(manifestData);

      currentError = "Failed accessing manifest data.";
      List<String> assets = List.from(manifest["assets"] as List);

      String resourcesAssetName = "resources/strings_$culture.json";
      String defaultResourcesAssetName = "resources/strings.json";
      String resourcesSchemaAssetName = "resources/strings.schema.json";

      if (!assets.contains(resourcesSchemaAssetName)) {
        _enterPanicMode("Resource schema file not found in asset data");
        return false;
      }

      String resourcesSchemaData =
          await rootBundle.loadString(resourcesSchemaAssetName);

      JsonSchema resourcesSchema = JsonSchema.create(resourcesSchemaData);

      if (assets.contains(resourcesAssetName)) {
        // Load stuff
        _resourcesFileExists = true;
        _loadResourcesFromExistingAsset(resourcesAssetName, resourcesSchema);
        return true;
      }

      if (!assets.contains(defaultResourcesAssetName)) {
        _enterPanicMode(
            "Unable to find culture-specific resources or default resources");
        return false;
      }

      _resourcesFileExists = true;
      _loadResourcesFromExistingAsset(
          defaultResourcesAssetName, resourcesSchema);

      return true;
    } catch (err) {
      _enterPanicMode(currentError);
      return false;
    }
  }

  _enterPanicMode(String message) {
    panicMode = true;
    _panicModeMessage = message;
  }

  _loadResourcesFromExistingAsset(
      String assetName, JsonSchema resourcesSchema) async {
    resourcesLoaded = false;

    if (!_resourcesFileExists) {
      _enterPanicMode("Attempted to load unvalidated resources");
    }

    String currentError = "Unable to load resource";

    try {
      String resourcesData = await rootBundle.loadString(assetName);
      var results = resourcesSchema.validate(resourcesData, parseJson: true);

      if (!results.isValid) {
        _enterPanicMode("Resources file did not validate against the schema.");
        _resourcesFileExists = false;

        return;
      }

      currentError = "Unable to parse resource data";
      Map<String, dynamic> resourceDefinitions = jsonDecode(resourcesData);

      currentError = "Failed accessing resource data.";
      String resourcesCulture = resourceDefinitions["culture"];

      if (resourcesCulture != "any" && resourcesCulture != culture) {
        _enterPanicMode("Resource file culture did not match locale.");
        return;
      }

      currentError = "Failed mapping resource data.";
      List<dynamic> uncastResources =
          List.from(resourceDefinitions["resources"] as List);
      List<Map<String, String>> resourcesList = uncastResources
          .map((item) => Map<String, String>.from(item))
          .toList();

      for (Map<String, String> res in resourcesList) {
        MapEntry<String, String> resource = res.entries.first;
        _resources[resource.key] = resource.value;
      }

      resourcesLoaded = true;
    } catch (_) {
      resourcesLoaded = false;
      _enterPanicMode(currentError);
    }
  }
}
