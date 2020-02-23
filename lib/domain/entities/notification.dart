/*
 * Copyright 2019 Christian Kramer
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 *  (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge,
 *  publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do
 *  so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
 * LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
 * EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:flutter/widgets.dart';
import 'package:pinguiclient/domain/entities/group.dart';
import 'package:pinguiclient/domain/entities/institution.dart';

class Notification {

  final String id;
  final String text;
  final int type;
  final Institution institution;
  final Group group;
  DateTime date = DateTime.now();
  bool hidden = false;

  Notification({@required this.id, @required this.type, @required this.text, @required this.institution, @required this.group, this.date,
      this.hidden});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'text': text,
      'institution_id': institution.id,
      'group_id': group.id,
      'date': date.millisecondsSinceEpoch,
      'hidden': hidden,
    };
  }
}

enum NotificationType {
  info,
  warning,
  hint,
}

extension NotificationTypeExtension on NotificationType {
  int getId() {
    switch(this) {
      case NotificationType.hint:
        return 3;
      case NotificationType.info:
        return 2;
      case NotificationType.warning:
        return 1;
      default:
        return 0;
    }
  }

  int getValidityInMs() {
    var validity = 0;
    switch(this) {
      case NotificationType.hint:
        validity = 3;
        break;
      case NotificationType.info:
        validity = 5;
        break;
      case NotificationType.warning:
        validity = 7;
        break;
    }
    return Duration(days: validity).inMilliseconds;
  }
}