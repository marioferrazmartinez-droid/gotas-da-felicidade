import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SocialLoginButton extends StatelessWidget {
  final String type; // 'google', 'apple', 'facebook'
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> config = _getButtonConfig(context);

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: config['color'],
        side: BorderSide(color: config['color']!),
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(config['color']!),
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(config['icon'], size: 24),
          const SizedBox(width: 12),
          Text(
            config['text'],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getButtonConfig(BuildContext context) {
    switch (type) {
      case 'google':
        return {
          'icon': Icons.g_mobiledata,
          'text': AppLocalizations.of(context).continueWithGoogle,
          'color': Colors.red.shade700,
        };
      case 'apple':
        return {
          'icon': Icons.apple,
          'text': AppLocalizations.of(context).continueWithApple,
          'color': Colors.black,
        };
      case 'facebook':
        return {
          'icon': Icons.facebook,
          'text': AppLocalizations.of(context).continueWithFacebook,
          'color': Colors.blue.shade800,
        };
      default:
        return {
          'icon': Icons.login,
          'text': 'Continuar',
          'color': Colors.blue.shade700,
        };
    }
  }
}