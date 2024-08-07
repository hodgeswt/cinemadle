# Gameplay Requirements

## User Requirements

### User Characteristics

See [User Characteristics](./README.md#user-characteristics)

### User Interfaces

The user will interact with Cinemadle through a web browser on mobile or
desktop. The game will present the user with a text input. The user will type
their guess into the input and submit it to the system. The system will provide
feedback to the user in the form of hints. These hints will indicate if the user
is close to the correct answer or if they are far off. The system will also
provide the user with a way to restart the game, view their score history, and
view the instructions for the game.

The hints will be presented in a 2x3 grid of squares. Each square will contain
a hint, such as the year the movie was released, the genre of the movie, or the
the best-known actor in the movie. The user will be able to click on a square to
reveal details about hint and what it means. Each square will be colored to
indicate how accurate the information is. Green squares will indicate that the
information is correct, yellow squares will indicate that the information
is nearly correct, and grey squares will indicate that the information is not
correct. The colors of these squares can change to make them easier for
colorblind users to distinguish.

## System Requirements

### Functional Requirements

1. The system must know the hidden movie the user must guess
1. The system must allow the user to make a guess
1. The system must limit the number of guesses the user can make
1. The system must provide the user with hints about the hidden movie
1. The hint categories are: genre, year, actor, director, writer, and rating
1. The hint data will come from the movie the user guessed
1. The hints will be clored to indicate how accurate they are, with green
   indicating correct, yellow indicating nearly correct, and grey indicating
   incorrect. Criteria for accuracy will be determined during story planning.
1. The system must allow the user to share their results in either a win or a
   loss
1. The system must not allow the user to restart the game

### Non-Functional Requirements

1. The system must be responsive and work on both mobile and desktop browsers
1. The system must be fast and responsive, with minimal loading times
1. The system must be easy to understand
1. The system must be visually appealing and engaging for the user
1. The information must be presented in a way that is easy to understand

## Use Cases

### Use Case 1: User Makes an Incorrect Guess

1. The user loads Cinemadle
1. The system presents the user with a text box
1. The user types their guess into the text box. It does not match the hidden
   movie
1. The user submits their guess
1. The system checks the guess against the hidden movie
1. The system provides the user with their six hints
1. The remaining guesses counter decreases by one

### Use Case 2: User Makes a Correct Guess

1. The user loads Cinemadle
1. The system presents the user with a text box
1. The user types their guess into the text box. It matches the hidden movie
1. The user submits their guess
1. The system checks the guess against the hidden movie
1. The system indicates to the user that they have won

### Use Case 3: User is Incorrect on their Last Guess

1. The user loads Cinemadle
1. The system presents the user with a text box
1. The user makes many incorrect guesses (see
   [Use Case 1](#use-case-1-user-makes-an-incorrect-guess))
1. The user makes their last guess
1. The system checks the guess against the hidden movie
1. The system indicates to the user that they have lost

### Use Case 4: User Shares Their Results

1. The user loads Cinemadle
1. The user plays a game
1. The user wins the game
1. The system indicates to the user that they have won
1. The user shares their results
