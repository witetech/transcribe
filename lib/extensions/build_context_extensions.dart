// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}
