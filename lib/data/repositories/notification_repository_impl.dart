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

import 'dart:convert';
import 'package:pinguiclient/api_request_status.dart';
import 'package:pinguiclient/data/api/notification_api.dart';
import 'package:pinguiclient/domain/entities/institution.dart';
import 'package:http/http.dart' as http;
import 'package:pinguiclient/domain/entities/notification.dart';
import 'package:pinguiclient/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl with NotificationRepository{

  Future<List<Notification>> getAllNotifications(String uuid) async {
    return NotificationApi.getAllNotifications();
  }

  @override
  Future<ApiRequestStatus> addNotification(Notification notification) {
    ApiRequestStatus apiRequest;
    NotificationApi.addNotification(notification).then((status) => {
        apiRequest = status,
        Future<ApiRequestStatus>.value(apiRequest)
    });

    return null;
  }


}
