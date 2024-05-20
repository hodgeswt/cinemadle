import 'package:cinemadle/src/blocs/main_view/main_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class GuessBox extends StatefulWidget {
  const GuessBox({
    super.key,
    required this.inputCallback,
    required this.scrollController,
  });

  final Function(int) inputCallback;
  final ScrollController scrollController;

  @override
  State<GuessBox> createState() => _GuessBoxState();
}

class _GuessBoxState extends State<GuessBox> {
  List<String> autofillHints = [];
  Map<String, int> ids = {};

  SuggestionsController<String> suggestionsController =
      SuggestionsController<String>();

  _submit(String data) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      int id = ids[data] ?? -1;
      widget.inputCallback(id);
      _textFieldController?.clear();
      suggestionsController.refresh();
      autofillHints = [];
      widget.scrollController.animateTo(
        widget.scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  TextEditingController? _textFieldController;

  Stopwatch debounce = Stopwatch();

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      suggestionsCallback: (search) => autofillHints,
      suggestionsController: suggestionsController,
      builder: (context, controller, focusNode) {
        return BlocBuilder<MainViewBloc, MainViewState>(
          builder: (context, state) {
            _textFieldController ??= controller;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: "Enter guess...",
              ),
              onChanged: (value) async {
                setState(() {
                  autofillHints = [];
                });
                if (value.isEmpty) {
                  return;
                }

                suggestionsController.refresh();
                suggestionsController.isLoading = true;

                List<SearchResult> search = await TmdbRepository()
                    .search(value, List.from(state.userGuessesIds ?? []));

                List<String> newTitles = [];
                Map<String, int> idMap = {};

                for (SearchResult res in search) {
                  newTitles.add(res.title);
                  idMap[res.title] = res.id;
                }

                if (newTitles.isEmpty) {
                  newTitles.add("No results found.");
                }

                setState(() {
                  autofillHints = newTitles;
                  ids.addAll(idMap);
                });

                suggestionsController.isLoading = false;
              },
            );
          },
        );
      },
      loadingBuilder: (context) => const ListTile(title: Text("Loading...")),
      itemBuilder: (context, data) {
        return ListTile(
          title: Text(data),
        );
      },
      onSelected: (data) {
        FocusManager.instance.primaryFocus?.unfocus();
        _submit(data);
      },
      hideOnEmpty: true,
    );
  }
}
