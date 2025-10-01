import 'package:flutter/material.dart';
import 'package:gotas_da_felicidade/utils/notifications.dart'; // Mantemos o import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Chama o método correto da classe NotificationService
    NotificationService.setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gotas da Felicidade'),
      ),
      body: const Center(
        child: Text('Tela Principal'),
      ),
    );
  }
}