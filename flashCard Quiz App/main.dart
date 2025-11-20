import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

void main() {
  runApp(FlashcardQuizApp());
}

class Flashcard {
  String question;
  String answer;

  Flashcard({required this.question, required this.answer});
}

class FlashcardQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: FlashcardHomePage(),
    );
  }
}

class FlashcardHomePage extends StatefulWidget {
  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  List<Flashcard> cards = [
    Flashcard(question: "Flutter is built using which language?", answer: "Dart"),
    Flashcard(question: "What widget shows text on screen?", answer: "Text"),
    Flashcard(question: "Which widget is scrollable?", answer: "ListView"),
  ];

  int currentIndex = 0;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  void nextCard() {
    setState(() {
      if (cardKey.currentState?.isFront == false) {
        cardKey.currentState?.toggleCard();
      }
      if (currentIndex < cards.length - 1) {
        currentIndex++;
      }
    });
  }

  void prevCard() {
    setState(() {
      if (cardKey.currentState?.isFront == false) {
        cardKey.currentState?.toggleCard();
      }
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  void addCard(String question, String answer) {
    setState(() {
      cards.add(Flashcard(question: question, answer: answer));
      currentIndex = cards.length - 1;
    });
  }

  void editCard(int index, String question, String answer) {
    setState(() {
      cards[index].question = question;
      cards[index].answer = answer;
    });
  }

  void deleteCard(int index) {
    setState(() {
      cards.removeAt(index);
      if (currentIndex >= cards.length) {
        currentIndex = cards.length - 1;
      }
    });
  }

  void showAddEditDialog({bool isEdit = false}) {
    final qController =
    TextEditingController(text: isEdit ? cards[currentIndex].question : '');
    final aController =
    TextEditingController(text: isEdit ? cards[currentIndex].answer : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit Flashcard' : 'Add Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: qController,
              decoration: InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 16),
              minLines: 1,
              maxLines: 2,
            ),
            SizedBox(height: 12),
            TextField(
              controller: aController,
              decoration: InputDecoration(
                labelText: "Answer",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 16),
              minLines: 1,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
              child: Text(isEdit ? 'Save' : 'Add'),
              onPressed: () {
                if (qController.text.isNotEmpty &&
                    aController.text.isNotEmpty) {
                  if (isEdit) {
                    editCard(currentIndex, qController.text, aController.text);
                  } else {
                    addCard(qController.text, aController.text);
                  }
                  Navigator.pop(ctx);
                }
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Flashcard Quiz App')),
        body: Center(child: Text('No flashcards yet! Add your first one.')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showAddEditDialog(),
          child: Icon(Icons.add),
        ),
      );
    }

    final card = cards[currentIndex];
    final colorFront = Colors.indigo[100]!;
    final colorBack = Colors.green[100]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Quiz App'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: "Edit Card",
            onPressed: () => showAddEditDialog(isEdit: true),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: "Delete Card",
            onPressed: () {
              deleteCard(currentIndex);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlipCard(
              key: cardKey,
              front: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                color: colorFront,
                elevation: 10,
                child: Container(
                  width: 320,
                  height: 220,
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.question_mark,
                          size: 40, color: Colors.indigo[900]),
                      SizedBox(height: 14),
                      Text(
                        card.question,
                        style: TextStyle(
                            fontSize: 22, color: Colors.indigo[800]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Tap to flip for answer",
                        style: TextStyle(
                            fontSize: 14, color: Colors.indigo[600]),
                      )
                    ],
                  ),
                ),
              ),
              back: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                color: colorBack,
                elevation: 10,
                child: Container(
                  width: 320,
                  height: 220,
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb,
                          size: 40, color: Colors.green[900]),
                      SizedBox(height: 14),
                      Text(
                        card.answer,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.green[800],
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Tap to flip for question",
                        style: TextStyle(
                            fontSize: 14, color: Colors.green[600]),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.arrow_left),
                  label: Text('Previous'),
                  onPressed: prevCard,
                  style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 18, vertical: 10)),
                ),
                SizedBox(width: 20),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.indigo[50],
                  elevation: 2,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      '${currentIndex + 1} / ${cards.length}',
                      style:
                      TextStyle(fontSize: 18, color: Colors.indigo[900]),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.arrow_right),
                  label: Text('Next'),
                  onPressed: nextCard,
                  style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 18, vertical: 10)),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddEditDialog(),
        icon: Icon(Icons.add),
        label: Text('Add Card'),
        backgroundColor: Colors.green[600],
      ),
    );
  }
}