import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final bool circularLoader;
  final VoidCallback? onTap;
  const RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.circularLoader = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 280,
        decoration: BoxDecoration(
          color: Color.fromRGBO(5, 50, 150, 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: circularLoader
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
