import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

class JapaneseTranslationPage extends StatefulWidget {
  const JapaneseTranslationPage({super.key});

  @override
  JapaneseTranslationPageState createState() => JapaneseTranslationPageState();
}

class JapaneseTranslationPageState extends State<JapaneseTranslationPage> {
  List<Map<String, String>> wordPairs = [];
  List<Map<String, String>> shuffledJapanesePairs = [];
  int? selectedEnglishIndex;
  int? selectedJapaneseIndex;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initializeTts();
    fetchWords();
  }

  void initializeTts() async {
    await flutterTts.setLanguage('ja-JP'); // Japanese TTS
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    flutterTts.setCompletionHandler(() {
      print("TTS playback finished.");
    });
    flutterTts.setErrorHandler((msg) {
      print("TTS error: $msg");
    });
  }

  Future<void> fetchWords() async {
    List<Map<String, String>> newWordPairs = [];
    while (newWordPairs.length < 5) {
      final response = await http.get(Uri.parse('http://IPv4:5000/words?language=Japanese')); // Replace Ipv4 with local device IP
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newPair = {
          'english': data['english'] as String,
          'japanese': data['foreign'] as String,
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
      shuffleJapaneseWords();
    });
  }

  bool containsPair(Map<String, String> pair, List<Map<String, String>> list) {
    return list.any((item) =>
        item['english'] == pair['english'] &&
        item['foreign'] == pair['foreign']);
  }

  Future<void> fetchSingleWordPair(int index) async {
    Map<String, String> newPair;
    bool isDuplicate;
    do {
      final response = await http.get(Uri.parse('http://Ipv4:5000/words?language=Japanese')); // Replace Ipv4 with local device IP
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        newPair = {
          'english': data['english'] as String,
          'japanese': data['foreign'] as String,
          'pronunciation': data['pronunciation'] as String
        };

        isDuplicate = containsPair(newPair, wordPairs);
      } else {
        throw Exception('Failed to load words');
      }
    } while (isDuplicate);

    setState(() {
      wordPairs[index] = newPair;
      shuffleJapaneseWords();
    });
  }

  void shuffleJapaneseWords() {
    shuffledJapanesePairs = List.from(wordPairs);
    shuffledJapanesePairs.shuffle();
  }

  void handleTap(bool isLeft, int index) {
    setState(() {
      if (isLeft) {
        selectedEnglishIndex = index;
      } else {
        selectedJapaneseIndex = index;
        if (shuffledJapanesePairs[index]['japanese'] != null) {
          flutterTts.speak(shuffledJapanesePairs[index]['japanese']!).then((_) {
            print("Speaking ${shuffledJapanesePairs[index]['japanese']}");
          });
        }
      }

      if (selectedEnglishIndex != null && selectedJapaneseIndex != null) {
        if (wordPairs[selectedEnglishIndex!]['japanese'] ==
            shuffledJapanesePairs[selectedJapaneseIndex!]['japanese']) {
          fetchSingleWordPair(selectedEnglishIndex!).then((_) {
            setState(() {
              selectedEnglishIndex = null;
              selectedJapaneseIndex = null;
            });
          });
        } else {
          selectedEnglishIndex = null;
          selectedJapaneseIndex = null;
        }
      }
    });
  }

  Widget buildWordContainer(String word, {bool selected = false}) {
    final lines = word.split('\n');
    final pronunciation = lines.length > 1 ? lines[0] : '';
    final japaneseWord = lines.length > 1 ? lines[1] : word;

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
              japaneseWord,
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
          'Word Memoriser Japanese',
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
                    shuffledJapanesePairs.length == wordPairs.length
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
                            '${shuffledJapanesePairs[index]['pronunciation'] ?? ''}\n${shuffledJapanesePairs[index]['japanese'] ?? ''}',
                            selected: selectedJapaneseIndex == index,
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
