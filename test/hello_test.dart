// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:pinguiclient/domain/usecases/notification_usecase.dart';
import 'package:pinguiclient/service_locator.dart';

void main() {
  init();
  NotificationUseCase useCase = sl();
  print(useCase);
}
