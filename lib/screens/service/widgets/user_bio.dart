import 'package:flutter/material.dart';

import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/sizes.dart';

class UserBio extends StatelessWidget {
  final String bio;
  const UserBio({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const TSectionHeading(
              title: 'About',
              showActionButton: false,
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
            SizedBox(
              width: screenWidth * 0.90,
              child: Text(
                bio,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
      ],
    );
  }
}