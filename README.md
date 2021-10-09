# LET'S MEET!

## Description

Let's Meet! has been created for the one month challenge given under Microsoft Engage Mentorship Program 2021. 
The challenge was to create a fully functional prototype with at least one mandatory functionality - a minimum of two participants should be able connect with each other using your product to have a video conversation.
The adapt feature given in the 3rd week was to include a chat feature in your application where meeting participants can share info without disrupting the flow of the meeting. The apk and video demo can be found at: https://drive.google.com/drive/folders/162EsFWw1Z8litX411l2qW6maQ3frsUPk

Technologies Used:
- Front End: Flutter (MVVM Architecture)
- Back End: Node.js, Express.js (MVC Architecture)
- DBMS: Mongo DB
- Real-time Communication: Socket IO, Agora IO

All the features included in Let's Meet! are:
- User Sign Up/Login with Email Authentication 
- Displaying all contacts
- Displaying chats with other contacts
- Searching users
- One-to-one video call
- Conference video call (max. 4 people)
- One-to-one chat
- Chatting during video call
- Call Logs
- User Profile
- Colour Themes

## Agile Implementation
- Week 1: Design (June 14-20)
    * Technological Stack finalized. 
    * Researched on WebRTC, web sockets and other video calling methods. Finalised agora.

- Week 2: Build (June 21-27)
    * Created basic login/signup and search. 
    * Embedded agora to frontend and backend.
    * Source code: Agora one-to-one video call: https://github.com/JaimilPatel/AgoraVideoCall

- Week 3: Build (June 28-July 04)
    * Video Conference call tried and implemented.
    * Keep user logged in feature added.
    * Call records added. 
    * Agora conference call source: https://github.com/Meherdeep/agora-group-calling

- Week 4: Adapt (July 05-12)
    * Chat implemented one-to-one first. For chat, using socket.io and streambuilder in flutter to keep a constant stream of chats flowing.
    * Integrated chat in video but chat wasn’t working properly as either the chat was glitching or the video. However, on making a few socket changes and creating a new instance just before starting the chat fixed it.
    * While calling or receiving call, names weren’t being displayed. Fixed that by passing it to the next screen for the user calling and passing it as a socket parameter for the user receiving.


## Pre-requisites 

- Flutter should be installed
- npm should be installed
- Gain App id and certificate from Agora console and paste in .env as 'APP_ID' and 'APP_CERTIFICATE'.
- Gain Mongo access link from from Mongo DB and paste in .env as 'MONGO_URI'

## How to Run

- On creating project on Agora and inserting App ID in front-end(api_constants) and back-end(.env), MongoDB link, changing url in frontend(app_constants) to http://localhost:3000 , run:

- "flutter pub get" to install all the dependencies. And use "flutter run" to run the project in debug mode. 

- Run npm init and then npm start

## Features Details

### User Sign Up/Login
In Sign Up, user is asked to enter their Email which on verifying takes them to the details page where they have to enter First Name, Last Name, Username and password. Username entered is checked in database for uniqueness and only if unique, user account is created. Login requires correct username and password.

### Displaying all contacts
This screen displays all contacts signed up on this app and gives the option of messaging or video calling them.

### Displaying chats with other contacts
This screen displays any chats that the user may have with other users. If the user has no chats, the screen prompts them to begin a new chat.

### Searching users
A search functionality is provided for easy searching of desired user. Search can be carried out by providing username, first name or last name. Even on clicking 'Add User' during a video call, the user is prompted to the search page.

### One-to-one video call
This feature has been implemented using Agora IO and Socket IO. There are multiple features in the video call: Muting microphone, Switching off Camera, Toggling Camera View, Messaging without interrupting the video call

### Conference video call (max. 4 people)
This feature is an extension of the one-to-one video call. 4 users can conference video call at a time.

### One-to-one chat
Users can carry out smooth one-to-one chat with any other user on the app. From the chat screen, the 2 users can connect via video call.

### Chatting during video call
During a one-to-one video call, users can chat without disrupting the video meeting. Moreover, the messages are saved for further reference and can be viewed in the respective user's chat. 

### Call Logs
This screen shows all call logs of the user. It shows if the call was accepted or rejected. If the call was accepted, it shows whether it was incoming or outgoing as well as displays duration.

### User Profile
This is used to show user information and allows user to edit First Name and Last Name. Username is unique and hence is not allowed to be edited.

### Colour Themes
There are various themes in the app. By default, the app theme is teal. It can be changed to user's choice.

## Limitations
- The app must be open to receive a call, currently doesn’t support push notifications.
- Chat doesn’t work for conference calls.
- Conferencing is limited to 4 people only.

## Future Scope
- Include group chat
- Creating teams and scheduling calls
- Conference call for more than 4 people
