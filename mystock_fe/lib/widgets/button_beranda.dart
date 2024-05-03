import 'package:flutter/material.dart';

class ButtonBeranda extends StatelessWidget {
  final IconData iconData;
  final String buttonText;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final double? iconSize;
  final Color? iconColor;

  const ButtonBeranda({
    Key? key,
    required this.iconData,
    required this.buttonText,
    required this.onPressed,
    this.buttonColor,
    this.iconSize,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 250, 250, 250),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(13.0),
        splashColor: const Color.fromRGBO(0, 0, 0, 0.151),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 105,
              height: 100,
              decoration: BoxDecoration(
                color: buttonColor ?? Colors.blue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(13.0),
              ),
              child: Icon(
                iconData,
                size: iconSize ?? 50,
                color: iconColor ?? Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              buttonText,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
