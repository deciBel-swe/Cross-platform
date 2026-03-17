import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

const _templatePath = 'assets/html/auth_complete.html';
const _iconPath = 'assets/icon/white_app_icon_trans.png';
const _iconPlaceholder = '{{ICON_DATA_URL}}';

Future<String> buildAuthSuccessHtml() async {
  final template = await rootBundle.loadString(_templatePath);
  final iconData = await rootBundle.load(_iconPath);
  final iconBytes = iconData.buffer.asUint8List();
  final iconBase64 = base64Encode(iconBytes);

  final iconDataUrl = 'data:image/png;base64,$iconBase64';

  return template.replaceAll(_iconPlaceholder, iconDataUrl);
}

