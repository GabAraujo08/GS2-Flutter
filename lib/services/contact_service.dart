import 'package:presente/models/contact.dart';
import 'package:presente/services/storage_service.dart';

class ContactService {
  ContactService({StorageService? storage})
      : _storage = storage ?? StorageService();

  final StorageService _storage;

  Future<List<Contact>> list() async {
    final contacts = await _storage.loadContacts();
    return _sorted(contacts);
  }

  Future<List<Contact>> toggleFavorite(String id) async {
    final contacts = await _storage.loadContacts();
    final updated = contacts
        .map((c) => c.id == id ? c.copyWith(favorite: !c.favorite) : c)
        .toList();
    await _storage.saveContacts(updated);
    return _sorted(updated);
  }

  List<Contact> contactsToNotify(List<Contact> contacts) {
    final favorites = contacts.where((c) => c.favorite).toList();
    return favorites.isEmpty ? contacts : favorites;
  }

  List<Contact> _sorted(List<Contact> contacts) {
    final copy = List<Contact>.of(contacts);
    copy.sort((a, b) {
      if (a.favorite == b.favorite) return a.name.compareTo(b.name);
      return a.favorite ? -1 : 1;
    });
    return copy;
  }
}
