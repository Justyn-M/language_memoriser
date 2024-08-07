# Memoriser

Memoriser is a word memoriser that works on android emulators. This document will outline its use and also provide a brief tutorial on
how to create this app from scratch. This document will be further updated when a tutorial of hosting the app on AWS is ready.

Created to show my knowledge on basic full stack development.

Tech stack used:

Flutter - Frontend
Json - Database
Python (Flask) - Backend

The current available languages are japanese and french.


# How to Use

(1) Ensure you have a working android emulator installed on the local device.

(2) Go through the dart files searching for the term 'IPv4' and replace it with your local device IP.
    Local device IP can be found in your local device's terminal using the command ipconfig.

(3) Navigate to the backend folder of this project in your code editor's terminal.

(4) Run command python app.py to start the backend server -> Install any libraries that may need to be installed

(5) Run the flutter frontend.

The app is now running using your device as the server.

## Database 

The current word database is stored in words.json. Both french and japanese databases are currently small.
There are 2 ways to add more words to the database:

    (1) Manually adding the english word, foreign translation & english pronunciation into the json file under the appropriate language database

    (2) Adding the english word, foreign translation & english pronunciation through the application UI in the (Manage Words) screen.
        The application has been designed so that words added using the app UI is saved across server restarts.



## Adding a new language

To add a new language:

    (1) Make a new dart file for your new language and copy any existing language file contents into your new file
    (2) Make appropriate changes to the new file such as changing japanese to russian and changing flutter TTS voice
    (3) Create a new button for the new language in main.dart
    (4) Add a new section for the new language in the json database such as 'Russian'
    (5) Populate database following template of {"english": "", "foreign": "", "pronunciation": ""}
    (6) Update manage_words.dart, at items: <String>['French', 'Japanese'] -> add the new language

You have now added a new language

## Basic full stack tutorial ##
This section provides a basic tutorial if you want to try create this app from scratch.

    (1) Create a new flutter project

    (2) Create backend folder at project root directory

    (3) At app/src/build.gradle change min&targetSdk versions to: 
        minSdkVersion 21
        targetSdkVersion 30

    (4) At settings.gradle, update id "org.jetbrains.kotlin.android" version "<Latest kotlin version>" apply false 

    (5) In android manifest.xml add permissions
        <uses-permission android:name="android.permission.INTERNET"/>
        <uses-permission android:name="android.permission.RECORD_AUDIO"/> 

            and update queries to accomodate TTS

        <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
        <intent>
            <action android:name="android.intent.action.TTS_SERVICE" />
        </intent>
    </queries> 

    (6) Update dependencies at pubspec.yaml to add:
        http: ^<latest version>
        flutter_tts: ^<latest version>

    (7) Create a venv in root directory & install:
        flask
        flask cors

    (8) Start coding the app -> Start from implementing basic functionalities.
        Due to this repository being a new repository that was aimed at saving an old corrupted repository,
        the commits in this repo do not show the process I took to implement each basic functionality into the app.
        Hence below shows the steps I took:

        // Note: Throughout this brief tutorial, change and update your classes, functions and files when needed to accomodate new functionalities

            (1) Create a basic front end for 1 language memoriser that includes the appbar & a background

            (2) Create a basic backend using python's flask that displays a word unto the UI, store the database on python as a list or dictionary for now.

            (3) Establish connection

            (4) Add a basic homepage with an appbar, background and button to go to the language memoriser screen

            (5) Add a few words to the python list/dictionary & create a button on the memoriser screen that changes the word shown everytime it is tapped.

            (6) Create a box for the words to go into and ensure shuffle works

            (7) Create 1 row of boxes where there are 2 columns for the words to go into and ensure shuffle works

            (8) Replace shuffle button to shuffle after the both boxes are tapped.

            (9) Create 5 rows of 2 columns that can shuffle after each pair is tapped.

            (10) Make new words in language list

            (11) Update classes and files as needed

            (12) Randomise which word appears in which row and ensure matching translation appears on the opposite side's boxes.

            (13) Add pronunciations to foreign words

            (14) Ensure first language memoriser works

            (15) Add a new language

            (16) Add Text to Speech functionality

            (17) Create manage words screen

            (18) Add view all words functionality to manage words screen

            (19) Change database struction from python list/dictionary to json

            (20) Create functionality in manage words screen to add words to database using UI

## Hosting the app in AWS cloud ##
This section will be updated soon....