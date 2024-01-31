import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messenger/extensions/navigator.dart';
import 'package:messenger/extensions/scaffold_messanger.dart';
import 'package:messenger/extensions/theme.dart';
import 'package:messenger/model/contact_filter.dart';
import 'package:messenger/presentation/widgets/contact_list_tile.dart';
import 'package:messenger/provider/contact_provider.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late ScrollController scrollController;
  bool showFloatingActionButton = true;

  bool show = false;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showFloatingActionButton) {
          setState(() {
            showFloatingActionButton = false;
          });
        }
      } else if (!showFloatingActionButton) {
        setState(() {
          showFloatingActionButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = context.watch<ContactProvider>();
    final filteredContacts = contactProvider.getFilteredContacts();
    final contactFilters = contactProvider.contactFilters;
    final favouriteContacts = contactProvider.favouriteContacts;

    return Scaffold(
      floatingActionButton: showFloatingActionButton
          ? FloatingActionButton.extended(
              onPressed: () async {
                // context.push(
                //   const CreateContactPage(),
                // );
                await FlutterContacts.openExternalInsert();
              },
              label: const Text("Create"),
              icon: const Icon(Icons.add_rounded),
            )
          : FloatingActionButton(
              onPressed: () async {
                // context.push(
                //   const CreateContactPage(),
                // );
                await FlutterContacts.openExternalInsert();
              },
              child: const Icon(Icons.add_rounded),
            ),
      body: RefreshIndicator(
        onRefresh: () async {
          contactProvider.updateContacts();
        },
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchAnchor.bar(
                barHintText: "Search",
                suggestionsBuilder: (context, suggestions) {
                  return contactProvider.contacts
                      .where(
                        (element) => element.displayName.toLowerCase().contains(
                              suggestions.text.toLowerCase(),
                            ),
                      )
                      .map(
                        (contact) => ContactListTile(
                          contact: contact,
                        ),
                      )
                      .toList();
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 5),
                    child: FilterChip(
                      label: const Text("Contacts with phone number"),
                      avatar: !contactFilters.contains(
                        ContactFilter.withPhoneNumber,
                      )
                          ? Icon(
                              Icons.phone_outlined,
                              color: context.colorScheme.primary,
                            )
                          : null,
                      selected: contactFilters
                          .contains(ContactFilter.withPhoneNumber),
                      onSelected: (value) {
                        if (contactFilters
                            .contains(ContactFilter.withPhoneNumber)) {
                          contactProvider.removeFilter(
                            ContactFilter.withPhoneNumber,
                          );
                        } else {
                          contactProvider.addFilter(
                            ContactFilter.withPhoneNumber,
                          );
                        }

                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: FilterChip(
                      label: const Text("Contacts with email"),
                      avatar: !contactFilters.contains(
                        ContactFilter.withEMail,
                      )
                          ? Icon(
                              Icons.mail_outline,
                              color: context.colorScheme.primary,
                            )
                          : null,
                      selected: contactFilters.contains(
                        ContactFilter.withEMail,
                      ),
                      onSelected: (value) {
                        if (contactFilters.contains(ContactFilter.withEMail)) {
                          contactProvider.removeFilter(
                            ContactFilter.withEMail,
                          );
                        } else {
                          contactProvider.addFilter(
                            ContactFilter.withEMail,
                          );
                        }

                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 5),
                    child: contactProvider.filteredOrganization == null
                        ? FilterChip(
                            label: const Text("Organizations"),
                            avatar: Icon(
                              Icons.domain_outlined,
                              color: context.colorScheme.primary,
                            ),
                            onSelected: (value) {
                              final organizations =
                                  contactProvider.getOrganizatonsFromContacts();

                              if (organizations.isEmpty) {
                                context.showSnackBar("No organizations found");
                                return;
                              }

                              showModalBottomSheet(
                                context: context,
                                builder: (_) => SizedBox(
                                  height: 300,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                          top: 16,
                                          bottom: 8,
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Organizations",
                                            style: context.textTheme.titleLarge,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: organizations.length,
                                          itemBuilder: (context, index) {
                                            final organization =
                                                organizations[index];

                                            return ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 5,
                                              ),
                                              onTap: () {
                                                contactProvider.setOrganization(
                                                  organization,
                                                );
                                                context.pop();
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              title: Text(organization.company),
                                              subtitle: organization
                                                      .jobDescription.isNotEmpty
                                                  ? Text(organization
                                                      .jobDescription)
                                                  : null,
                                              leading: const Icon(
                                                Icons.domain_rounded,
                                              ),
                                              trailing: Radio(
                                                value: true,
                                                groupValue: false,
                                                onChanged: (_) {
                                                  contactProvider
                                                      .setOrganization(
                                                    organization,
                                                  );
                                                  context.pop();
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Chip(
                            label: Text(
                              contactProvider.filteredOrganization?.company ??
                                  "No organization found",
                              style: TextStyle(
                                color: context.colorScheme.primaryContainer,
                              ),
                            ),
                            avatar: Icon(
                              Icons.domain_rounded,
                              color: context.colorScheme.primaryContainer,
                            ),
                            deleteIcon: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: context.colorScheme.primaryContainer,
                            ),
                            onDeleted: () {
                              contactProvider.setOrganization(null);
                            },
                            color: MaterialStateProperty.all(
                              context.colorScheme.primary,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                controller: scrollController,
                itemCount: filteredContacts.length + favouriteContacts.length,
                itemBuilder: (context, index) {
                  if (index < favouriteContacts.length) {
                    if (index == 0) {
                      return ContactListTile.withTitle(
                        contact: favouriteContacts[index],
                        title: "Favourites: ${favouriteContacts.length}",
                      );
                    }

                    return ContactListTile(
                      contact: favouriteContacts[index],
                    );
                  }

                  final contact =
                      filteredContacts[index - favouriteContacts.length];

                  if (index - favouriteContacts.length == 0) {
                    return ContactListTile.withTitle(
                      contact: contact,
                      title: "Contacts: ${filteredContacts.length}",
                    );
                  }

                  return ContactListTile(contact: contact);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
