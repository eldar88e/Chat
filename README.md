## README

Chat is a real-time messaging application

Things you may want to cover:

* Ruby version: 3.2.2

* Rails version: 7.1.2

* Instruction for Production
    - go to the folder of Chat
    - run command: docker compose up --build
    - for first run this project need open the new window terminal and go to the Chat folder and run the next command: docker compose exec chat rails db:setup
    - login information:
      1. login: john@gmail.com, pass: 12356
      2. login: jack@gmail.com, pass: 12356
      3. login: bob@gmail.com, pass: 12356

* Instruction for run Tests
    - go to the folder of Chat
    - docker compose -f docker-compose-test.yml up --build
