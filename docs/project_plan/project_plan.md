# Project Plan

## Introduction

Cinemadle is a simple guessing game centered around popular, well-rated movies.
The game is designed to be played by a single player, who will be presented with
no information at the beginning of the game. The system selects a movie at random
which the user must guess within their limited number of guesses.

After each guess, the user will be presented a collection of hints about the hidden
movie. These hints are based on data from the movie the user guesses and their relation
to the same category of data from the hidden movie. The user must use this information
to make educated guesses about the hidden movie, and the game will end when the user
either guesses the movie correctly or runs out of guesses.

## Description

### Overview

Cinemadle will be developed for use in a web browser, either mobile or desktop.
Two early iterations have been developed and released to rapidly refine the game.
A third iteration is currently in development and will be released in the near future.
It will incorporate a clearer hint system, improved performance, a better UI and UX,
and an increased feature set.

### Details

Cinemadle v3 will be developed using the following technologies:

- Vue.js and TailwindCSS for the frontend
- Golang using Gearbox for the backend

Cinemadle will be hosted on a cloud server and will be accessible via a web browser.

The initial release of Cinemadle v3 will include the following:

- A simple, intuitive UI, designed for mobile and desktop
- A clear, concise hint system, with instructions
- The ability to track and share scores
- The core game: guessing a movie based on hints

## Project Organization

### Roles

- **Project Manager**: Responsible for overseeing the project and ensuring that it
  is completed on time and within budget (if applicable).
- **Lead Developer**: Responsible for the technical aspects of the project, including
  the design, development, and testing of the software.
- **UI/UX Designer**: Responsible for the design of the user interface and user
  experience of the software.
- **QA Tester**: Responsible for testing the software to ensure that it meets the
  requirements and is free of bugs.

For early-stage development, it is expected that the core contributors will embody all
of these roles to some extent.

Internal QA testing is essential and must be completed before any release.
However, Cinemadle will rely extensively on volunteer user feedback to locate elusive
bugs, improve the hint system, and refine the game's difficulty.

All tasks will be organized in a GitHub project and monitored using GitHub issues and pull requests.

## Timeline

### Phase 1: Planning and Design

- **Duration**: 2 weeks
- **Tasks**:
  - Define project requirements
  - Develop user stories
  - Determine project timeline
  - Refine existing documentation
  - Create GitHub project
- **Deliverables**:
  - Requirements document
  - User stories
  - Remainder of the timeline
