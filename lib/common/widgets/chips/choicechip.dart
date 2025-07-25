import 'package:flutter/material.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/helpers/helper_function.dart';
import '../custom_shapes/containers/circular_container.dart';

class TChoiceChip extends StatelessWidget {
  const TChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor = HelperFunction.getColor(text) != null;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        label: isColor ? const SizedBox() :  Text(text),
        selected: selected, 
        onSelected: onSelected,
        labelStyle: TextStyle(color: selected ? CustomColors.white : null),
        avatar: isColor ? CircularContainer(width:50, height: 50, backgroundColor: HelperFunction.getColor(text)!)
                : null,
        labelPadding: isColor ? const EdgeInsets.all(0) : null,
        padding: isColor ? const EdgeInsets.all(0) : null,
        shape: isColor ? const CircleBorder() : null,
        backgroundColor: isColor ? HelperFunction.getColor(text): null,
        ),
    );
  }
}