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

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:pinguiclient/api_request_status.dart';
import 'package:pinguiclient/data/models/notification_model.dart';
import 'package:pinguiclient/domain/entities/notification.dart' as pingui;

import '../../globals.dart';

class NotificationApi {


  static Future<ApiRequestStatus> addNotification(pingui.Notification notification) {
    // do stuff
    return Future<ApiRequestStatus>.value(ApiRequestStatus<String>(payload: "test", status: ApiRequestStatusIndicator.ok));
  }

  static Future<List<pingui.Notification>> getAllNotifications() {
    var _notificationStub = (id, text, hidden) {return {"id" : id, "text": text, "date": DateTime.now(), "hidden": hidden,
      "group": {"id": "123abc", "name": "Kleine gruppe"},
      "institution": {"id": "1234hgz", "name": "Institution 1", "plz": 12345}};};

    var dummy = <pingui.Notification>[];

    for (var i = 0; i < 10; i++) {
      dummy.add(NotificationModel.fromJson(_notificationStub("id" + i.toString(), "text " + i.toString(), Random(i).nextBool())));
    }

    return Future<List<pingui.Notification>>.value(dummy);
  }
}