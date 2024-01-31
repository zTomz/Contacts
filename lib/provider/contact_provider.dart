import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messenger/model/contact_filter.dart';

class ContactProvider extends ChangeNotifier {
  ContactProvider(List<Contact> contacts) {
    _contacts = contacts;
  }

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  Future<void> updateContacts() async {
    _contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
      withThumbnail: true,
      withAccounts: true,
      withGroups: true,
    );

    notifyListeners();
  }

  // ignore: prefer_final_fields
  Set<ContactFilter> _contactFilters = {};
  Set<ContactFilter> get contactFilters => _contactFilters;
  List<Contact> getFilteredContacts() {
    return contacts.where((contact) {
      if (_contactFilters.contains(ContactFilter.withPhoneNumber) &&
          contact.phones.isEmpty) {
        return false;
      }

      if (_contactFilters.contains(ContactFilter.withEMail) &&
          contact.emails.isEmpty) {
        return false;
      }

      if (_filteredOrganization != null) {
        if (!contact.organizations.contains(_filteredOrganization)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<Contact> get favouriteContacts =>
      getFilteredContacts().where((contact) => contact.isStarred).toList();

  // ignore: prefer_final_fields
  Organization? _filteredOrganization;
  Organization? get filteredOrganization => _filteredOrganization;

  void addFilter(ContactFilter filter) {
    _contactFilters.add(filter);

    notifyListeners();
  }

  void removeFilter(ContactFilter filter) {
    _contactFilters.remove(filter);

    notifyListeners();
  }

  void setContacts(List<Contact> newContacts) {
    _contacts = newContacts;

    notifyListeners();
  }

  List<Organization> getOrganizatonsFromContacts() {
    List<Organization> orgs = [];

    for (final contact in contacts) {
      for (final organization in contact.organizations) {
        if (!orgs.contains(organization)) {
          orgs.add(organization);
        }
      }
    }

    return orgs;
  }

  void setOrganization(Organization? organization) {
    _filteredOrganization = organization;

    notifyListeners();
  }
}
