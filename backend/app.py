from flask import Flask, jsonify, request
from flask_cors import CORS
import random
import json

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Extend the list of words for each language with English pronunciations at your discretion in the JSON file

# Load words from JSON file
def load_words():
    with open('words.json', 'r', encoding='utf-8') as file:
        return json.load(file)

# Save words to JSON file
def save_words(data):
    with open('words.json', 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=2)

# Load the initial data
words_data = load_words()

# Get a random word pair for the given language
@app.route('/words', methods=['GET'])
def get_random_word_pair():
    language = request.args.get('language')
    if language in words_data:
        word_pair = random.choice(words_data[language])
        return jsonify(word_pair)
    else:
        return jsonify({'error': 'Invalid language'}), 400

# Function to add words to the list of words in the JSON file
@app.route('/add_word', methods=['POST'])
def add_word():
    data = request.json
    language = data.get('language')
    if language in words_data:
        words_data[language].append({
            'english': data['english'],
            'foreign': data['foreign'],
            'pronunciation': data['pronunciation']
        })
        save_words(words_data)
        return jsonify({'message': 'Word added successfully'})
    else:
        return jsonify({'error': 'Invalid language'}), 400

# Function to remove words from the list in the JSON file
@app.route('/remove_word', methods=['POST'])
def remove_word():
    data = request.json
    language = data.get('language')
    english_word = data.get('english')
    if language in words_data:
        words_data[language] = [word for word in words_data[language] if word['english'] != english_word]
        save_words(words_data)
        return jsonify({'message': 'Word removed successfully'})
    else:
        return jsonify({'error': 'Invalid language'}), 400

# Show all words for the selected language
@app.route('/all_words', methods=['GET'])
def get_all_words():
    language = request.args.get('language')
    if language in words_data:
        return jsonify(words_data[language])
    else:
        return jsonify({'error': 'Invalid language'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
