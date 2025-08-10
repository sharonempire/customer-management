import 'package:flutter/material.dart';

const height5 = SizedBox(height: 5);
const height10 = SizedBox(height: 10);
const height20 = SizedBox(height: 20);
const height30 = SizedBox(height: 30);

const width5 = SizedBox(width: 5);
const width10 = SizedBox(width: 10);
const width20 = SizedBox(width: 20);
const width30 = SizedBox(width: 30);

double getEachContainerWidth(double screenWidth, int numberOfContainers) {
  const double gap = 4.0;
  final double totalGap = 2 * gap;
  final double availableWidth = screenWidth - totalGap - 200;
  return availableWidth / numberOfContainers;
}
