# Memoriser

A word memoriser that works on android emulators. This document will be updated when a tutorial of hosting the app on AWS is ready.

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

You have now added a new language

## Hosting the app in AWS cloud ##
This section will be updated soon....