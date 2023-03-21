import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HeaderBanner extends StatelessWidget {
  const HeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Image.asset("assets/Ground-Vector.png",
        //         width: width * 0.7, height: 210.0)),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 35.0,
            vertical: 8.0,
          ),
          child: Container(
            height: height * 0.15,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(80, 148, 160, 255),
                  Color.fromARGB(69, 223, 159, 234)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            // padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const AutoSizeText(
                  "Welcome to Cram.AI!",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(width: 50),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/Banner-Image.png",
                    width: 225.0,
                    height: 175.0,
                    fit: BoxFit.cover,
                  ),
                ),
                // Image.asset("assets/Ground-Vector.png",
                //     width: 200.0, height: 200.0),
              ],
            ),
          ),
        ),
        // Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Image.asset("assets/Ground-Vector.png",
        //         width: width * 0.7, height: 200.0)),
      ],
    );
  }
}
