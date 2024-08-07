import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

// French memoriser page - Uses same functions as other memoriser screens but with different names
class FrenchTranslationPage extends StatefulWidget {
  const FrenchTranslationPage({super.key});

  @override
  FrenchTranslationPageState createState() => FrenchTranslationPageState();
}

class FrenchTranslationPageState extends State<FrenchTranslationPage> {
  // Declaring global variables
  List<Map<String, String>> wordPairs = [];
  List<Map<String, String>> shuffledFrenchPairs = [];
  int? selectedEnglishIndex;
  int? selectedFrenchIndex;
  FlutterTts flutterTts = FlutterTts(); // Flutter text to speech

  @override
  void initState() {
    super.initState();
    initializeTts(); // Initialise text to speech 
    fetchWords();
  }

  void initializeTts() async {
    await flutterTts.setLanguage('fr-FR'); // French setting for TTS
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    flutterTts.setCompletionHandler(() {
      print("TTS playback finished."); // Debug code -> remove if using AWS to host
    });
    flutterTts.setErrorHandler((msg) {
      print("TTS error: $msg");
    });
  }

// Get words from backend
  Future<void> fetchWords() async {
    List<Map<String, String>> newWordPairs = [];
    while (newWordPairs.length < 5) {
      final response = await http.get(Uri.parse('http://IPv4:5000/words?language=French')); // Replace Ipv4 with local device IP
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newPair = {
          'english': data['english'] as String,
          'french': data['foreign'] as String,
          'pronunciation': data['pronunciation'] as String
        };

        if (!containsPair(newPair, newWordPairs)) {
          newWordPairs.add(newPair);
        }
      } else {
        throw Exception('Failed to load words');
      }
    }

    setState(() {
      wordPairs = newWordPairs;
      shuffleFrenchWords();
    });
  }

// Gets the right pairs from the database
  bool containsPair(Map<String, String> pair, List<Map<String, String>> list) {
    return list.any((item) =>
        item['english'] == pair['english'] &&
        item['foreign'] == pair['foreign']);
  }


// Gets a new word pair after 1 pair has been pressed on UO
  Future<void> fetchSingleWordPair(int index) async {
    Map<String, String> newPair;
    bool isDuplicate;
    do {
      final response = await http.get(Uri.parse('http://Ipv4:5000/words?language=French')); // Replace Ipv4 with local device IP
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        newPair = {
          'english': data['english'] as String,
          'french': data['foreign'] as String,
          'pronunciation': data['pronunciation'] as String
        };

        isDuplicate = containsPair(newPair, wordPairs);
      } else {
        throw Exception('Failed to load words');
      }
    } while (isDuplicate);

    setState(() {
      wordPairs[index] = newPair;
      shuffleFrenchWords(); // Shuffle right side foreign language translations
    });
  }

// Shuffles foreign language translations
  void shuffleFrenchWords() {
    shuffledFrenchPairs = List.from(wordPairs);
    shuffledFrenchPairs.shuffle();
  }

// Function for tap logic
  void handleTap(bool isLeft, int index) {
    setState(() {
      if (isLeft) {
        selectedEnglishIndex = index;
      } else {
        selectedFrenchIndex = index;
        if (shuffledFrenchPairs[index]['french'] != null) {
          flutterTts.speak(shuffledFrenchPairs[index]['french']!).then((_) {
            print("Speaking ${shuffledFrenchPairs[index]['french']}");
          });
        }
      }

      if (selectedEnglishIndex != null && selectedFrenchIndex != null) {
        if (wordPairs[selectedEnglishIndex!]['french'] ==
            shuffledFrenchPairs[selectedFrenchIndex!]['french']) {
          fetchSingleWordPair(selectedEnglishIndex!).then((_) {
            setState(() {
              selectedEnglishIndex = null;
              selectedFrenchIndex = null;
            });
          });
        } else {
          selectedEnglishIndex = null;
          selectedFrenchIndex = null;
        }
      }
    });
  }

// Word box widget
  Widget buildWordContainer(String word, {bool selected = false}) {
    final lines = word.split('\n');
    final pronunciation = lines.length > 1 ? lines[0] : '';
    final frenchWord = lines.length > 1 ? lines[1] : word;

    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: selected ? Colors.yellow : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              pronunciation,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              frenchWord,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Word Memoriser French',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: wordPairs.isNotEmpty &&
                    shuffledFrenchPairs.length == wordPairs.length
                ? List.generate(wordPairs.length, (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => handleTap(true, index),
                          child: buildWordContainer(
                            wordPairs[index]['english'] ?? '',
                            selected: selectedEnglishIndex == index,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => handleTap(false, index),
                          child: buildWordContainer(
                            '${shuffledFrenchPairs[index]['pronunciation'] ?? ''}\n${shuffledFrenchPairs[index]['french'] ?? ''}',
                            selected: selectedFrenchIndex == index,
                          ),
                        ),
                      ],
                    );
                  })
                : [
                    const CircularProgressIndicator()
                  ],
          ),
        ),
      ),
    );
  }
}
