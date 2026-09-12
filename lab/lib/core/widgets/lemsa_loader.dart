import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

/// Thin wrapper — promotes to flutter_page_kit or core/widgets in consumer apps.
class LemsaLoader extends StatelessWidget {
  const LemsaLoader({
    super.key,
    this.size = 32,
    this.indicatorType = Indicator.lineScale,
  });

  final double size;
  final Indicator indicatorType;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: LoadingIndicator(
        indicatorType: indicatorType,
        colors: [color],
        strokeWidth: 2,
      ),
    );
  }
}
