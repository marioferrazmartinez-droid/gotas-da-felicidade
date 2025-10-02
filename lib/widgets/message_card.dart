import 'package:flutter/material.dart';
import '../providers/quote_provider.dart';

class MessageCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  const MessageCard({
    super.key,
    required this.quote,
    required this.onFavorite,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quote.text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '- ${quote.author}',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    quote.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: quote.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: onFavorite,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: onShare,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}