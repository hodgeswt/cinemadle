import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:flutter/material.dart';

class CinemadleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CinemadleAppBar({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: Constants.primaryGradientBox(),
          width: Utilities.widthCalculator(MediaQuery.of(context).size.width),
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Cinemadle",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              InkWell(
                onTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 24,
                        height: 2,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 24,
                        height: 2,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 24,
                        height: 2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(200, 75);
}
