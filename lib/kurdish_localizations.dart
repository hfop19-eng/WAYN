
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class KurdishMaterialDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const KurdishMaterialDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return GlobalMaterialLocalizations.delegate.load(
      const Locale('ar'),
    );
  }

  @override
  bool shouldReload(KurdishMaterialDelegate old) => false;
}

class KurdishWidgetsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const KurdishWidgetsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ku';

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    return GlobalWidgetsLocalizations.delegate.load(
      const Locale('ar'),
    );
  }

  @override
  bool shouldReload(KurdishWidgetsDelegate old) => false;
}

class KurdishCupertinoDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const KurdishCupertinoDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ku';

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return GlobalCupertinoLocalizations.delegate.load(
      const Locale('ar'),
    );
  }

  @override
  bool shouldReload(KurdishCupertinoDelegate old) => false;
}
