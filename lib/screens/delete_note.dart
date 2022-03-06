import 'package:flutter/material.dart';

class DeleteNote extends StatelessWidget {
  const DeleteNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Warning"),
      content: const Text("Are you sure you want to delete?"),
      actions: [
        TextButton(onPressed: (){ Navigator.of(context).pop(true); }, child: const Text("Yes")),
        TextButton(onPressed: (){ Navigator.of(context).pop(false); }, child: const Text("No")),
      ],
    );
  }
}
