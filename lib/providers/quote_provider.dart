import 'package:flutter/foundation.dart';

class Quote {
  final String text;
  final String author;
  final bool isFavorite;
  final DateTime createdAt;
  final bool isAIGenerated;
  final String? theme;

  Quote({
    required this.text,
    required this.author,
    this.isFavorite = false,
    required this.createdAt,
    this.isAIGenerated = false,
    this.theme,
  });

  Quote copyWith({
    String? text,
    String? author,
    bool? isFavorite,
    DateTime? createdAt,
    bool? isAIGenerated,
    String? theme,
  }) {
    return Quote(
      text: text ?? this.text,
      author: author ?? this.author,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
      theme: theme ?? this.theme,
    );
  }
}

class QuoteProvider with ChangeNotifier {
  final List<Quote> _quotes = [
    Quote(
      text: "A persistência é o caminho do êxito",
      author: "Charles Chaplin",
      createdAt: DateTime.now(),
    ),
    Quote(
      text: "A felicidade não é algo pronto. Ela vem de suas próprias ações",
      author: "Dalai Lama",
      createdAt: DateTime.now(),
    ),
    Quote(
      text: "O sucesso nasce do querer, da determinação e persistência",
      author: "Desconhecido",
      createdAt: DateTime.now(),
    ),
  ];

  List<Quote> get quotes => List.unmodifiable(_quotes);

  List<Quote> get favoriteQuotes => _quotes.where((quote) => quote.isFavorite).toList();

  void toggleFavorite(Quote quote) {
    final index = _quotes.indexWhere((q) => q.text == quote.text && q.author == quote.author);
    if (index != -1) {
      _quotes[index] = _quotes[index].copyWith(isFavorite: !_quotes[index].isFavorite);
      notifyListeners();
    }
  }

  void addQuote(Quote quote) {
    _quotes.insert(0, quote);
    notifyListeners();
  }

  void removeQuote(Quote quote) {
    _quotes.removeWhere((q) => q.text == quote.text && q.author == quote.author);
    notifyListeners();
  }
}