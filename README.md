# cinemadle

A movie guessing game that is still in development.

## Building

To build cinemadle, do the following:

1. Ensure you have an `API_KEY` defined in a root-level `.env` file.
1. Run `dart run build_runner build`
1. Run `flutter build web --release --source-maps --web-renderer canvaskit`
1. Open the build `flutter.js` file and remove the source map off the final line.
