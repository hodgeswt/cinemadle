import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/data_model/paginated_results.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:flutter/material.dart';

class GuessBox extends StatefulWidget {
  const GuessBox({
    super.key,
    required this.inputCallback,
  });

  final Function(String) inputCallback;
  @override
  State<GuessBox> createState() => _GuessBoxState();
}

class _GuessBoxState extends State<GuessBox> {
  final ResourceManager rm = ResourceManager.instance;
  final MovieData md = MovieData.instance;

  List<String> autofillHints = [];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.length < 4) {
          return const Iterable<String>.empty();
        }

        setState(() {
          autofillHints = [];
        });

        PaginatedResults searchResults =
            await md.searchMovie(textEditingValue.text);

        for (MovieRecord movie in searchResults.results) {
          setState(() {
            autofillHints = [...autofillHints, movie.title];
          });
        }

        return autofillHints.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
    );
  }
}
