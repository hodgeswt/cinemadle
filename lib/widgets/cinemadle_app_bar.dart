import 'package:cinemadle/constants.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:flutter/material.dart';

AppBar get cinemadleAppbar {
  return AppBar(
    backgroundColor: Constants.darkGrey,
    title: Text(
      ResourceManager.instance.getResource(Resources.title),
      style: TextStyle(
        color: Constants.lightGrey,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    bottom: PreferredSize(
      preferredSize: Size.zero,
      child: Text(
        ResourceManager.instance.getResource(Resources.caption),
        style: TextStyle(
          color: Constants.lightGrey,
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
      ),
    ),
  );
}
