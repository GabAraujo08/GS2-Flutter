import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:presente/services/phone_service.dart';
import 'package:presente/utils/formatters.dart';

Future<void> startCall(
  BuildContext context, {
  required String name,
  required String number,
}) async {
  final phone = PhoneService();

  if (kIsWeb) {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Ligar para $name',
            style: const TextStyle(fontSize: 24),
          ),
          content: Text(
            formatPhone(number),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Fechar', style: TextStyle(fontSize: 20)),
            ),
            ElevatedButton(
              onPressed: () {
                phone.call(number);
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Abrir telefone',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
    return;
  }

  final opened = await phone.call(number);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Não foi possível abrir o telefone neste aparelho.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
