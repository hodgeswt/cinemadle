import 'package:cinemadle/src/utilities.dart';
import 'package:flutter/material.dart';

class CinemadleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CinemadleAppBar({
    super.key,
    this.onMenuPressed,
  });

  final Function()? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(71 * 3.1415927 / 180),
              colors: [Color(0xFFA9FFEA), Color(0xFF00B288)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
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
                onTap: onMenuPressed ?? () {},
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
