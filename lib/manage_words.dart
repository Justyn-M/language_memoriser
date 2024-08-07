import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Manage words screen

class ManageWordsPage extends StatefulWidget {
  const ManageWordsPage({super.key});

  @override
  ManageWordsPageState createState() => ManageWordsPageState();
}

class ManageWordsPageState extends State<ManageWordsPage> {
  List<Map<String, String>> words = [];
  // Automatically set French to be the first language that appears
  String selectedLanguage = 'French';

  @override
  void initState() {
    super.initState();
    fetchWords();
  }

  // Shows all words in that specific language database
  Future<void> fetchWords() async {
    final response = await http.get(Uri.parse(
        'http://Ipv4:5000/all_words?language=$selectedLanguage')); // Replace Ipv4 with local device IP
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        words = data.map((word) => Map<String, String>.from(word)).toList();
      });
    } else {
      throw Exception('Failed to load words');
    }
  }

  // Function to remove a word through the UI
  Future<void> removeWord(String english) async {
    final response = await http.post(
      Uri.parse('http://IPv4:5000/remove_word'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'language': selectedLanguage, 'english': english}),
    );
    if (response.statusCode == 200) {
      fetchWords();
    } else {
      throw Exception('Failed to remove word');
    }
  }

  // Function to allow users to add words
  void showAddWordDialog() {
    String english = '';
    String foreign = '';
    String pronunciation = '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Word'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'English'),
              onChanged: (value) => english = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Foreign'),
              onChanged: (value) => foreign = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Pronunciation'),
              onChanged: (value) => pronunciation = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final response = await http.post(
                Uri.parse('http://IPv4:5000/add_word'), // Replace Ipv4 with local device IP
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'language': selectedLanguage,
                  'english': english,
                  'foreign': foreign,
                  'pronunciation': pronunciation,
                }),
              );
              if (response.statusCode == 200) {
                if (mounted) {
                  fetchWords();
                  Navigator.of(ctx).pop();
                }
              } else {
                throw Exception('Failed to add word');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Words'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddWordDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue!;
                  fetchWords();
                });
              },
              items: <String>['French', 'Japanese'] //add new languages here
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                return ListTile(
                  title: Text(word['english'] ?? ''),
                  subtitle:
                      Text('${word['foreign']} (${word['pronunciation']})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeWord(word['english'] ?? ''),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
