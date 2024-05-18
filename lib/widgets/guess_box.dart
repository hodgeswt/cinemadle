import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/data_model/paginated_results.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class GuessBox extends StatefulWidget {
  const GuessBox({
    super.key,
    required this.userGuessRecords,
    required this.inputCallback,
  });

  final Function(int) inputCallback;

  final List<int> userGuessRecords;

  @override
  State<GuessBox> createState() => _GuessBoxState();
}

class _GuessBoxState extends State<GuessBox> {
  final ResourceManager rm = ResourceManager.instance;
  final MovieData md = MovieData.instance;

  List<String> autofillHints = [];
  Map<String, int> ids = {};

  SuggestionsController<String> suggestionsController =
      SuggestionsController<String>();

  TextField? _guessBoxField;

  _submit(String data) {
    int id = ids[data] ?? -1;
    widget.inputCallback(id);
    _guessBoxField?.controller?.clear();
    suggestionsController.refresh();
    autofillHints = [];
  }

  TextField _getGuessBoxField(
      TextEditingController? controller, FocusNode? focusNode) {
    _guessBoxField = TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: rm.getResource(Resources.inputBoxHintText),
      ),
      onSubmitted: (data) {
        _submit(data);
      },
      onChanged: (value) async {
        setState(() {
          autofillHints = [];
        });
        if (value.isNotEmpty) {
          suggestionsController.refresh();
          suggestionsController.isLoading = true;
          PaginatedResults search = await md.searchMovie(value);

          List<String> newTitles = [];
          for (MovieRecord movie in search.results.take(4)) {
            if (!widget.userGuessRecords.any((x) {
              return x == movie.id;
            })) {
              String title =
                  "${movie.title}${rm.getResource(Resources.popularityLabel)} ${movie.popularity.round()}";
              ids[title] = movie.id;
              newTitles.add(title);
            }
          }

          setState(() {
            autofillHints = newTitles;
          });

          suggestionsController.isLoading = false;
        }
      },
    );

    return _guessBoxField!;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      suggestionsCallback: (search) => autofillHints,
      suggestionsController: suggestionsController,
      builder: (context, controller, focusNode) {
        return _getGuessBoxField(controller, focusNode);
      },
      loadingBuilder: (context) =>
          ListTile(title: Text(rm.getResource(Resources.loading))),
      itemBuilder: (context, data) {
        return ListTile(
          title: Text(data),
        );
      },
      onSelected: (data) {
        _submit(data);
      },
      hideOnEmpty: true,
    );
  }
}
