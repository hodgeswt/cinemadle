import 'package:cinemadle/src/blocs/main_view/main_view_bloc.dart';
import 'package:cinemadle/src/constants.dart';
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

  bool preventSubmit = false;

  SuggestionsController<String> suggestionsController =
      SuggestionsController<String>();

  _submit(String data) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      int id = ids[data] ?? -1;
      widget.inputCallback(id);
      _textFieldController?.clear();
      _isClearButtonVisible = false;
      suggestionsController.refresh();
      autofillHints = [];
      widget.scrollController.animateTo(
        widget.scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  _onInputChanged(String value, MainViewState state) async {
    setState(() {
      autofillHints = [];
    });

    if (value.isEmpty) {
      setState(() {
        _isClearButtonVisible = false;
      });
      return;
    }

    setState(() {
      _isClearButtonVisible = true;
    });

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

    bool empty = false;

    if (newTitles.isEmpty) {
      empty = true;
      newTitles.add("No results found.");
    }

    setState(() {
      autofillHints = newTitles;
      ids.addAll(idMap);
      preventSubmit = empty;
    });

    suggestionsController.isLoading = false;
  }

  TextEditingController? _textFieldController;

  Stopwatch debounce = Stopwatch();

  bool _isClearButtonVisible = false;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      decorationBuilder: (context, child) {
        return Container(
          decoration: Constants.mediumGradientBox(),
          child: child,
        );
      },
      suggestionsCallback: (search) => autofillHints,
      suggestionsController: suggestionsController,
      builder: (context, controller, focusNode) {
        return BlocBuilder<MainViewBloc, MainViewState>(
          builder: (context, state) {
            _textFieldController ??= controller;
            return Container(
              padding: const EdgeInsets.all(4.0),
              decoration: Constants.darkGradientBox(),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText:
                            "${state.remainingGuesses} guesses remaining",
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) async {
                        _onInputChanged(value, state);
                      },
                    ),
                  ),
                  Visibility(
                    visible: _isClearButtonVisible,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isClearButtonVisible = false;
                          _textFieldController?.clear();
                        });

                        suggestionsController.refresh();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(Icons.clear, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loadingBuilder: (context) => const ListTile(
        title: Text(
          "Loading...",
          style: TextStyle(color: Colors.white),
        ),
      ),
      itemBuilder: (context, data) {
        return ListTile(
          title: Text(
            data,
            style: const TextStyle(color: Colors.white),
          ),
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
