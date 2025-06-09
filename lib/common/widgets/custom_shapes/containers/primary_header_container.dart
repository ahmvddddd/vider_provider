// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../utils/constants/custom_colors.dart';
import '../../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        color: CustomColors.primary,
        padding: EdgeInsets.all(0),
        child: Stack(
    children: [
      Positioned(top: -150, right: -250, child: CircularContainer(backgroundColor: CustomColors.textWhite.withValues(alpha: 0.1))),
      Positioned(top: 100, right: -300, child: CircularContainer(backgroundColor: CustomColors.textWhite.withValues(alpha: 0.1))),
      child,
      
    ],
        )
      ),
    );
  }
}