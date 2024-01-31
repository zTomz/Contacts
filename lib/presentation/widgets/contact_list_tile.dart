import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messenger/extensions/theme.dart';
import 'package:messenger/provider/contact_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  final String title;
  final bool _withTitle;

  const ContactListTile({
    super.key,
    required this.contact,
  })  : _withTitle = false,
        title = "";

  const ContactListTile.withTitle({
    super.key,
    required this.contact,
    required this.title,
  }) : _withTitle = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_withTitle)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: context.textTheme.bodySmall,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: ListTile(
            title: Text(contact.displayName),
            subtitle: Text(
              contact.phones.firstOrNull?.number ?? "No phone number",
            ),
            trailing: IconButton(
              onPressed: () async {
                // If is empty return
                if (contact.phones.isEmpty) return;

                await launchUrl(
                    Uri.parse("tel:${contact.phones.first.number}"));
              },
              color: context.colorScheme.primary,
              icon: const Icon(Icons.call_rounded),
            ),
            leading: contact.photo == null
                ? Container(
                    width: 56, // Size of the image if available
                    height: 56,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      contact.displayName.substring(0, 1),
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(
                      contact.photo!,
                    ),
                  ),
            onTap: () async {
              await FlutterContacts.openExternalEdit(contact.id);

              if (context.mounted) {
                context.read<ContactProvider>().updateContacts();
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
