import 'package:flutter/material.dart';
import 'package:liquidlibrary/widgets/instanceSources.dart';

class AddInstance extends StatelessWidget {
  const AddInstance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center children horizontally
          children: [
            InstanceSources(
              label: 'Local',
              icon: Icons.folder_outlined,
            ),
            InstanceSources(
              label: 'AuthorToday',
              icon: Icons.highlight_off,
            ),
          ],
        ),
      )
    );
  }
}