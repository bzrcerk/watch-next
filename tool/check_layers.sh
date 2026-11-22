#!/usr/bin/env bash
# R10: prints nothing when the layers are clean, lists the leaking files otherwise.
cd "$(dirname "$0")/.." || exit 1

# package:http only in core/api/* and *_repository.dart
# (main.dart is the composition root and builds http.Client()).
http_leaks=$(grep -rl "package:http" lib/ \
  | grep -v -e '^lib/core/api/' -e '_repository\.dart$' -e '^lib/main\.dart$')

# No Flutter UI in core/api, repositories or ChangeNotifier models.
ui_leaks=$(grep -rl "package:flutter/material" lib/core/api lib/features \
  | grep -e '^lib/core/api/' -e '_repository\.dart$' -e '_model\.dart$')

[ -z "$http_leaks$ui_leaks" ] || { printf '%s\n' $http_leaks $ui_leaks; exit 1; }
