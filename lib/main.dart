import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(const CardMatching());
}

class CardMatching extends StatelessWidget {
  const CardMatching({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: ThemeData().textTheme.apply(
          fontFamily: 'Roboto',
        ),
      ),
      home: ChangeNotifierProvider(
        create: (_) => GameState(),
        child: const CardScreen(),
      ),
    );
  }
}

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Matching'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Game',
            onPressed: gameState.resetGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: gameState.cards.length,
          itemBuilder: (context, index) {
            return ChangeNotifierProvider.value(
              value: gameState.cards[index],
              child: const WidgetCard(),
            );
          },
        ),
      ),
    );
  }
}

class WidgetCard extends StatelessWidget {
  const WidgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final card = Provider.of<CardModel>(context);
    final gameState = Provider.of<GameState>(context, listen: false);

    return GestureDetector(
      onTap: () {
        if (!card.isFaceUp && !gameState.isChecking) {
          gameState.flipState(card);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: card.isFaceUp
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            card.isFaceUp ? card.frontDesign : card.rearDesign,
            style: TextStyle(
              fontSize: 24,
              color: card.isFaceUp
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class CardModel with ChangeNotifier {
  final String frontDesign;
  final String rearDesign;
  bool isFaceUp;

  CardModel({
    required this.frontDesign,
    required this.rearDesign,
    this.isFaceUp = false,
  });

  void flipState() {
    isFaceUp = !isFaceUp;
    notifyListeners();
  }
}

class GameState with ChangeNotifier {
  List<CardModel> flippedCards = [];
  bool isChecking = false;

  final List<CardModel> cards = List.generate(
    16,
    (index) => CardModel(
      frontDesign: (index % 8).toString(),
      rearDesign: 'click to flip',
    ),
  )..shuffle();

  void flipState(CardModel card) {
    card.flipState();
    flippedCards.add(card);

    if (flippedCards.length == 2) {
      isChecking = true;
      _checkForMatch();
    }

    notifyListeners();
  }

  void _checkForMatch() async {
    await Future.delayed(const Duration(seconds: 1));

    if (flippedCards[0].frontDesign != flippedCards[1].frontDesign) {
      flippedCards[0].flipState();
      flippedCards[1].flipState();
    }

    flippedCards.clear();
    isChecking = false;
    notifyListeners();
  }

  void resetGame() {
    for (var card in cards) {
      if (card.isFaceUp) {
        card.flipState();
      }
    }
    cards.shuffle();
    flippedCards.clear();
    isChecking = false;
    notifyListeners();
  }
}
