# cinemadle
A movie-guessing game powered by The Movie Database

## This project is incomplete

## Building
1. Provide an environment variable `API_KEY` containing your
TheMovieDb.org API key, or a root-level `.env` file with
this.

1. Run `dart run build_runner build`

1. Run `flutter build web --release --source-maps` and then edit
the generated `flutter.js` file in the output directory to remove
the final line referencing a source map.