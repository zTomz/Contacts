import 'package:flutter/material.dart';
import 'package:messenger/extensions/navigator.dart';

class CreateContactPage extends StatefulWidget {
  const CreateContactPage({super.key});

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create new contact",
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.clear_rounded),
        ),
        actions: [
          FilledButton(
            onPressed: () {},
            child: const Text("Save"),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
