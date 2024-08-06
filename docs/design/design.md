# Design

## Considerations

1. Minimal business logic will be implemented in the frontend
   to reduce the footprint of the system and improve performance.
1. The frontend for the system will be developed using
   Vue.js and TailwindCSS.
1. The backend for the system will be developed using
   Golang and Gearbox.
1. The backend for the system will communicate with
   TheMovieDB.org API to retrieve movie data.
1. The backend will run natively on a Unix-based operating
   system or containerized via Docker.

## Architecture

### Overview

The system will be divided into two main components:

1. The frontend, which will be responsible for presenting
   the user with the game and handling user input.
1. The backend, which will be responsible for selecting
    movies, generating hints, and tracking user scores.

The frontend and backend will communicate via a RESTful API.

### Frontend

The frontend will be developed using Vue.js and TailwindCSS.

The frontend will be responsible for:

1. Presenting the user with the game
1. Handling user input and sending it to the backend
1. Displaying hints to the user based on their input
1. Displaying the correct answer if the user runs out of guesses
1. Displaying the user's score and history
1. Displaying instructions for the game
1. Allowing the user to share their score and achievements

In the early stages of development, the frontend will also be responsible
for maintaining the game state, to remove the need for a database.
Depending on performance, scalability, user feedback, and product direction,
this may change in future iterations. As such, the frontend will be designed
to be easily decoupled from its state. The user interface should be agnostic
to the source of the data it displays.

### Backend

The backend will be developed using Golang and Gearbox.

The backend will be responsible for:

1. Selecting a movie for the user to guess
1. Ensuring the selected movie is the same for all users
1. Generating hints based on a guessed movie
1. Communicating with TheMovieDB.org API to retrieve only necessary data

The backend will run natively on a Unix-based operating system or
containerized via Docker. The backend will be designed to be stateless,
to allow for easy scaling, deployment, and reliability.

The backend will consist of four main components:

1. The API, which will handle requests from the frontend
1. The movie selector, which will select a movie for the user to guess
1. The hint generator, which will generate hints based on a guessed movie
1. The repository, which will communicate with TheMovieDB.org API to retrieve movie data

Each of these should be decoupled from the others to allow for ease of testing,
maintenance, and future development.
