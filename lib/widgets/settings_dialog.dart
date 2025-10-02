import 'package:flutter/material.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configurações'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações Diárias'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.nightlight_round),
            title: const Text('Tema Escuro'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            trailing: DropdownButton<String>(
              value: 'pt',
              items: const [
                DropdownMenuItem(value: 'pt', child: Text('Português')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}