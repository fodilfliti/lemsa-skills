import 'package:flutter/material.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';

/// Size tokens — call once from [main] before [runApp].
void initLabScaleKit() {
  setPaddingSizes(
    SizeValues.custom(xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48),
  );
  setMarginSizes(
    SizeValues.custom(xs: 4, sm: 8, md: 12, lg: 16, xl: 24, xxl: 32),
  );
  setRadiusSizes(
    SizeValues.custom(xs: 4, sm: 8, md: 12, lg: 16, xl: 20, xxl: 28),
  );
  setSpacingSizes(
    SizeValues.custom(xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48),
  );
  setDefaultPadding(16);
  setDefaultMargin(8);
  setDefaultRadius(12);
  setDefaultSpacing(8);
}

/// FVM 3.35.7 reference — design canvas for ScaleKitBuilder.
const labDesignWidth = 375.0;
const labDesignHeight = 812.0;
