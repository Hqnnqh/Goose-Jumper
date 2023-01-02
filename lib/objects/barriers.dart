import 'package:flutter/material.dart';

class Barrier extends StatefulWidget {
  final double barrierX;
  final double widht, height;

  const Barrier({
    Key? key,
    required this.barrierX,
    required this.widht,
    required this.height,
  }) : super(key: key);

  @override
  State<Barrier> createState() => _BarrierState();
}

class _BarrierState extends State<Barrier> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(widget.barrierX, 1),
      child: Container(
        width: widget.widht,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3.0),
        ),
        child: Container(
          color: Colors.green[700],
        ),
      ),
    );
  }
}
