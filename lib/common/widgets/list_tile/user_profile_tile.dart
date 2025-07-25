import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/custom_colors.dart';
import '../images/circular_image.dart';


class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircularImage(
        image: 'Images.darkAppLogo',
        width: 50,
        height: 50, padding: 0,
      ),
      title: Text('', style: Theme.of(context).textTheme.headlineSmall!.apply(color: CustomColors.white)),
      subtitle: Text('', style: Theme.of(context).textTheme.bodyMedium!.apply(color: CustomColors.white)),
      trailing: IconButton(onPressed: () {}, icon: Icon(Iconsax.edit, color:CustomColors.white))
    );
  }
}