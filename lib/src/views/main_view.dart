import 'package:cinemadle/src/blocs/main_view/main_view_bloc.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:cinemadle/src/views/failed_loading_view.dart';
import 'package:cinemadle/src/widgets/cinemadle_app_bar.dart';
import 'package:cinemadle/src/widgets/drawer.dart';
import 'package:cinemadle/src/widgets/guess_box.dart';
import 'package:cinemadle/src/widgets/guess_list.dart';
import 'package:cinemadle/src/widgets/header_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class MainView extends StatefulWidget {
  const MainView({
    super.key,
    required this.targetMovie,
    required this.uuid,
  });

  final Movie targetMovie;
  final int uuid;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _showShareSheet(String results) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constants.primary,
          title: const Text('Share', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: results,
                    style: const TextStyle(
                        fontFamily: 'NotoEmoji', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Copy', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: results)).then(
                  (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Results copied to clipboard!"),
                      ),
                    );

                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: Constants.darkGradientBox(hasBorderRadius: false),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: CinemadleAppBar(
              scaffoldKey: _scaffoldKey,
            ),
            endDrawer: drawer(context, Views.game),
            body: _buildBody(),
          ),
        ),
      ],
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: Constants.stdPad,
      child: BlocProvider<MainViewBloc>(
        create: (context) => MainViewBloc(widget.targetMovie, widget.uuid)
          ..add(ValidateCurrentRequested(widget.uuid)),
        child: BlocConsumer<MainViewBloc, MainViewState>(
          buildWhen: (previous, current) {
            return previous.status != current.status ||
                previous.userGuessesIds != current.userGuessesIds;
          },
          listener: (context, state) {
            if (state.status == MainViewStatus.fatalError) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FailedLoadingView(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == MainViewStatus.fatalError) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == MainViewStatus.playing ||
                state.status == MainViewStatus.guessNotFound ||
                state.status == MainViewStatus.guessLoading) {
              return Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: Utilities.widthCalculator(
                      MediaQuery.of(context).size.width / 2),
                  child: Column(
                    children: [
                      GuessBox(
                        inputCallback: (int x) async {
                          MainViewBloc bloc = context.read<MainViewBloc>();
                          bloc.add(const FlipAllRequested());

                          await bloc.stream.firstWhere(
                              (x) => x.status != MainViewStatus.guessLoading);

                          bloc.add(
                            UserGuessAdded(x),
                          );
                        },
                        scrollController: _scrollController,
                      ),
                      GuessList(
                        targetMovie: widget.targetMovie,
                        scrollController: _scrollController,
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.status == MainViewStatus.win ||
                state.status == MainViewStatus.loss) {
              final bool isWin = state.status == MainViewStatus.win;
              return Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: Utilities.widthCalculator(
                      MediaQuery.of(context).size.width / 2),
                  child: Column(
                    children: [
                      HeaderCard(
                        text: isWin ? "You win!" : "You lost :(",
                        isWin: isWin,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    _showShareSheet(state.results ?? "");
                                  },
                                  child: Container(
                                    padding: Constants.stdPad,
                                    decoration: Constants.primaryGradientBox(),
                                    child: const Center(
                                      child: Text(
                                        "Share Your Results",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GuessList(targetMovie: widget.targetMovie),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<MainViewBloc>()
                                      .add(const ResetRequested());
                                },
                                child: Container(
                                  padding: Constants.stdPad,
                                  decoration: Constants.primaryGradientBox(),
                                  child: const Center(
                                    child: Text(
                                      "Reset",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
