import 'package:flutter/material.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/reponsive_size.dart';

class AllClientsScreen extends StatelessWidget {
  final Widget childWidget;
  const AllClientsScreen({
    super.key,
  required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: TAppBar(
        title: Text('All Clients',
        style: Theme.of(context).textTheme.headlineSmall,),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(responsiveSize(context, Sizes.spaceBtwItems)),
          child: Column(
            children: [
              childWidget
            ],
          )
        ),
      ),
    );
  }
}