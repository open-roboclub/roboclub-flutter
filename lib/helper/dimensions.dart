import 'package:flutter/material.dart';

double getViewportHeight(BuildContext context) {
  MediaQueryData data = MediaQuery.of(context);

  return data.size.height - data.padding.bottom - data.padding.top;
}

double getViewportWidth(BuildContext context) {
  MediaQueryData data = MediaQuery.of(context);

  return data.size.width - data.padding.left - data.padding.right;
}

double getDeviceWidth(BuildContext context) {
  MediaQueryData data = MediaQuery.of(context);

  return data.size.width;
}

double getDeviceHeight(BuildContext context) {
  MediaQueryData data = MediaQuery.of(context);

  return data.size.height;
}
