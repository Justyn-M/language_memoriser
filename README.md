# Memoriser

Memoriser is a word memoriser that works on android emulators and physical phone devices. This document will outline its use and also provide a brief tutorial on
how to create this app from scratch. This document also includes a tutorial of hosting the app on AWS.

Created to show my knowledge on basic full stack development.

Tech stack used:

Flutter - Frontend

Json - Database

Python (Flask) - Backend

Amazon Web Servies

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
        targetSdkVersion 31

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
This section outlines the steps needed for hosting the backend on Amazon Web Services

1) Go to EC2 in AWS

2) Go to launch instance

3) Configure instance as follows:
    Give appropriate name
    Under application & OS Images select Amazon Linux
    Select t2.micro instance type
    Create a new key pair & select RSA key type & .ppk key file format
    Press Edit on security group, create a security group, give an appropriate name, allow inbound rules ssh on port 22, http on port 80 & custom tcp on 5000

4) Launch Instance

5) Create an elastic IP & Associate it with your new instance

6) Find the .ppk file that is downloaded

7) Launch PuTTY & configure:
    Session -> host name -> enter ec2-user@<EC2PublicIPAddress>
    Connection -> SSH -> Auth -> Private key file for authentication -> browse & select .ppk file
    Connection -> put 15 secs between keepalives -> enable TCP keepalives
    Click open at bottom of window
    Press yes to confirm host key

8) In PuTTY do:
    sudo yum update -y
    sudo yum install python3 -y
    sudo yum install python3-pip -y
    pip3 install Flask Flask-CORS
    sudo yum install git -y

9) Go back to the flutter code and at every point in the code that calls an IP address, replace it with the public ip address of your EC2 instance

10) Use WinSCP to upload project files:
    set up new session
    select SFTP in file protocol dropdown menu
    In hostname enter EC2 public IP
    Keep port number as 22
    enter ec2-user in username
    Save & Login
    Upload entire flutter project from device to AWS cloud server by dragging and dropping

11) In PuTTY, navigate to the backend folder

12) Start flask server using command:
    flask run --host=0.0.0.0 --port=5000

13) Check server status by entering http://your-ec2-public-ip:5000 into a browser

14) Test application connection using an emulator on flutter 

15) If app is fully functional run command:
    flutter build apk --release

    Resolve any issues if needed

16) Navigate to the apk file in /build folder.

17) Send it to your phone

18) The app is fully completed and functional!


## Adding Additional Security & Automatic Server Run ##

1) Go back to PuTTy & Run Commands:
    sudo yum update -y
    sudo yum install nginx -y
    sudo pip install gunicorn
   
2) Navigate to backend folder
   
3) Find number of CPU cores on server using command: nproc
   
4) Run gunicorn -w X -b 0.0.0.0:5000 app:app
    Where X = workers=(2×CPU cores)+1
   
5) If it is working, stop the server
   
6) Run command: which gunicorn -> output should be /usr/local/bin/gunicorn
   
7) Create a Systemd Service to run Gunicorn as a service: sudo nano /etc/systemd/system/gunicorn.service
    
8) In gunicorn.service fill in with:
[Unit]
Description=Gunicorn instance to serve Flask app
After=network.target

[Service]
User=ec2-user
Group=ec2-user
WorkingDirectory=/home/ec2-user/language_memoriser/backend
ExecStart=/usr/local/bin/gunicorn -w X -b 0.0.0.0:5000 app:app

[Install]
WantedBy=multi-user.target

9) Reload and start gunicorn:
sudo systemctl daemon-reload
sudo systemctl start gunicorn
sudo systemctl enable gunicorn

10) Configure Nginx as a Reverse Proxy
    sudo nano /etc/nginx/conf.d/flask_app.conf

11) Add configurations:
server {
    listen 80;
    server_name instance_public_ip;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

12) Test and run Nginx:
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

13) Check status using:
    sudo systemctl status gunicorn
    sudo systemctl status nginx

14) If you have followed all steps, the Server should be running properly and will automatically restart each time AWS instance is restarted, if not debug as needed.

