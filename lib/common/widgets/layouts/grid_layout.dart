// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';

class GridLayout extends StatelessWidget {
  const GridLayout({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 2,
    required this.itemBuilder,
    this.mainAxisExtent = 288,
  });

  final int itemCount;
  final double? mainAxisExtent;
  final int crossAxisCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount:  itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: Sizes.gridViewSpacing / 1.5,
        crossAxisSpacing: Sizes.gridViewSpacing / 1.5,
        mainAxisExtent: mainAxisExtent,
        ),
      itemBuilder: itemBuilder,
      );
  }
}

