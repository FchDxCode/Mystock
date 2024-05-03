import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onChanged;
  final double padding;
  final double width;
  final double height;

  const CustomCheckbox({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.padding = 0.0,
    this.width = 60.0,
    this.height = 60.0,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  void _toggleChecked() {
    setState(() {
      _isChecked = !_isChecked;
      widget.onChanged(_isChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: GestureDetector(
        onTap: _toggleChecked,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(219, 219, 219, 0.78),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.center,
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: _isChecked ? Colors.green : Colors.black,
                  width: 2.0,
                ),
              ),
              child: _isChecked
                  ? const Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.green,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
