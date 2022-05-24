import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controllerLogin.dart';

class screenProfile extends StatefulWidget {
  @override
  State<screenProfile> createState() => _screenProfileState();
}

class _screenProfileState extends State<screenProfile> {
  final controller = Get.put(loginController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(controller.googleAccount.value?.photoUrl ?? '')
                  .image,
          radius: 100,
        ),
        Text(
          controller.googleAccount.value?.displayName ?? '',
          style: Get.textTheme.bodyMedium,
        ),
        Text(
          controller.googleAccount.value?.email ?? '',
          style: Get.textTheme.bodyText1,
        ),
        ActionChip(
            avatar: Icon(Icons.logout),
            label: Text('Logout'),
            onPressed: () {
              controller.logout();
            }),
      ],
    );
  }
}
