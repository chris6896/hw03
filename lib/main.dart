import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const CardMatching());
}
class CardModel with ChangeNotifier{
  final String frontDesign;
  final String rearDesign;
  bool isFaceup;

  CardModel({
    required this.frontDesign,
    required this.rearDesign,
    this.isFaceup = false,
  });

  void flipState() {
    isFaceup = !isFaceup;
    notifyListeners();
  }
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
        textTheme: ThemeData().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: const Scaffold(
        body: Center(child: Text('Card Matching')),
      ),
    );
  }
}

class CardScreen extends StatelessWidget {
  const  CardScreen({super.key});

  @override 
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Matching"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Game",
            onPressed: gameState.resetGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: gameState.cards.length,
          itemBuilder: (context, index){
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