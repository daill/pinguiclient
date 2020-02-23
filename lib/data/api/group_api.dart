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

import 'package:pinguiclient/data/models/group_model.dart';
import 'package:pinguiclient/domain/entities/group.dart';
import 'package:http/http.dart' as http;

import '../../globals.dart';

class GroupApi {
  static Future<List<Group>> fetchGroupsByInstitutionId(String institutionId) async {
    assert (institutionId != null);
    String requestUrl = 'http://localhost:8080/institution/' + institutionId + "/groups";

    var result;
    var response;

    try {
      response = await http.get(requestUrl);
    } catch (e) {
      logger.e(e);
      throw("Technischer Fehler, bitte versuchen Sie es später erneut.");
    }

    if (response.statusCode == 200) {
      List<dynamic> jsonArray = json.decode(response.body);
      List<Group> groups = jsonArray.map((item) => new GroupModel.fromJSON(item)).toList();
      result = groups;
    } else {
      throw("Fehler in der Abarbeitung");
    }

    return result;
  }
}