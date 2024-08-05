import 'package:flutter/material.dart';
import 'jap_memoriser.dart';
import 'french_memoriser.dart';
import 'manage_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Select Language',
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Memoriser', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Choose your language',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              languageButton(context, 'Japanese', Icons.translate),
              const SizedBox(height: 20),
              languageButton(context, 'French', Icons.language),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ManageWordsPage()),
                  );
                },
                child: const Text('Manage Words'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget languageButton(BuildContext context, String language, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _getPage(language),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 10),
              Text(
                language,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPage(String language) {
    switch (language) {
      case 'Japanese':
        return const JapaneseTranslationPage();
      case 'French':
        return const FrenchTranslationPage();
      default:
        return const WelcomePage();
    }
  }
}
