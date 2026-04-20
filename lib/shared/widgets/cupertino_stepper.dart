import 'package:flutter/cupertino.dart';

class CupertinoStepper extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final double stepValue;
  final ValueChanged<double> onChanged;

  const CupertinoStepper({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.stepValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: value > min
              ? () => onChanged((value - stepValue).clamp(min, max))
              : null,
          child: const Icon(CupertinoIcons.minus_circle, size: 28),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: value < max
              ? () => onChanged((value + stepValue).clamp(min, max))
              : null,
          child: const Icon(CupertinoIcons.plus_circle, size: 28),
        ),
      ],
    );
  }
}