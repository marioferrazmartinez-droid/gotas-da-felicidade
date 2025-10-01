import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> setupPushNotifications() async {
    try {
      // Solicita permissão para notificações
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Obtém o token do dispositivo (útil para enviar notificações específicas)
      await _messaging.getToken();

      // Configura handlers para notificações
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Notificação recebida com o app em primeiro plano
        // Você pode mostrar um snackbar ou dialog aqui
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // Notificação clicada quando o app estava em segundo plano
        // Você pode navegar para uma tela específica aqui
      });
    } catch (e) {
      // Erro silencioso - em produção você pode registrar em um serviço de analytics
    }
  }
}