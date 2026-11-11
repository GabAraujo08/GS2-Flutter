import 'package:flutter/material.dart';
import 'package:presente/app/theme.dart';
import 'package:presente/models/contact.dart';
import 'package:presente/services/contact_service.dart';
import 'package:presente/utils/formatters.dart';
import 'package:presente/widgets/call_helper.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactService _service = ContactService();

  List<Contact> _contacts = <Contact>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final contacts = await _service.list();
    if (!mounted) return;
    setState(() {
      _contacts = contacts;
      _loading = false;
    });
  }

  Future<void> _toggleFavorite(Contact contact) async {
    final updated = await _service.toggleFavorite(contact.id);
    if (!mounted) return;
    setState(() => _contacts = updated);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _contacts.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Toque no telefone para ligar. A estrela marca quem é avisado primeiro.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return _buildContactCard(_contacts[index - 1]);
      },
    );
  }

  Widget _buildContactCard(Contact contact) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withAlpha(40),
              child: Text(
                contact.initials,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    contact.relation,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    formatPhone(contact.phone),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            IconButton(
              iconSize: 32,
              tooltip: contact.favorite
                  ? 'Remover dos avisados primeiro'
                  : 'Avisar primeiro',
              onPressed: () => _toggleFavorite(contact),
              icon: Icon(
                contact.favorite ? Icons.star : Icons.star_border,
                color: contact.favorite ? Colors.amber.shade700 : Colors.black45,
              ),
            ),
            IconButton(
              iconSize: 36,
              tooltip: 'Ligar para ${contact.name}',
              onPressed: () => startCall(
                context,
                name: contact.name,
                number: contact.phone,
              ),
              icon: const Icon(Icons.call, color: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }
}
