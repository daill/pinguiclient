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
import 'package:pinguiclient/domain/entities/notification.dart' as pingui;

import 'group_model.dart';
import 'institution_model.dart';

class NotificationModel extends pingui.Notification {

  NotificationModel({@required String id, @required int type, @required String text, @required Institution institution, @required Group group, @required DateTime date,
    bool hidden}) : super(id: id, type: type, text: text, institution: institution, group: group, date: date, hidden: hidden);

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id'],
        type: json['type'],
        text: json['text'],
        date: json['date'],
        hidden: json['hidden'],
        institution: InstitutionModel.fromJSON(json['institution']),
        group: GroupModel.fromJSON(json['group'])
    );
  }



}