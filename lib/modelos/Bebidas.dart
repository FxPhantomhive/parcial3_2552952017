import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Bebidas {
  String strDrink = "";
  String strDrinkThumb = "";
  String strCategory = "";
  String strInstructions = "";

  Bebidas(strDrink, strDrinkThumb, strCategory, strInstructions) {
    this.strDrink = strDrink;
    this.strDrinkThumb = strDrinkThumb;
    this.strCategory = strCategory;
    this.strInstructions = strInstructions;
  }
}
