import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/layouts/listvew.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/reponsive_size.dart';

// New: Skills list widget
class SkillsList extends StatelessWidget {
  final List<String> skills;
  final bool isDark;
  final void Function(int) onDelete;

  const SkillsList({
    super.key,
    required this.skills,
    required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return HomeListView(
      sizedBoxHeight: screenHeight * 0.06,
      scrollDirection: Axis.horizontal,
      seperatorBuilder: (context, index) => SizedBox(width: responsiveSize(context, Sizes.xs)),
      itemCount: skills.length,
      itemBuilder: (context, index) => RoundedContainer(
        height: screenHeight * 0.08,
        backgroundColor: isDark
            ? Colors.white.withAlpha(30)
            : Colors.black.withAlpha(30),
        padding: EdgeInsets.all(responsiveSize(context, Sizes.xs)),
        child: Row(
          children: [
            Text(skills[index], style: Theme.of(context).textTheme.labelSmall),
            SizedBox(width: responsiveSize(context, Sizes.xs)),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDelete(index),
            ),
          ],
        ),
      ),
    );
  }
}