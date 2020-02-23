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
import 'package:pinguiclient/data/models/institution_model.dart';
import 'package:pinguiclient/domain/entities/institution.dart';
import 'package:http/http.dart' as http;
import 'package:pinguiclient/domain/i18n/messages_de.dart';

import '../../globals.dart';

class InstitutionApi {

  static Future addInstitution(String name, int postal) async {
    String requestUrl = 'http://localhost:8080/institution';
    var request = http.MultipartRequest("POST", Uri.parse(requestUrl));
    request.fields['name'] = name;
    request.fields['postal'] = postal.toString();
    final response =  await request.send();

    if (response.statusCode == 200) {
      return ApiRequestStatus.noPayload(ApiRequestStatusIndicator.ok);
    }
    throw("could not load institutions");
  }

  static Future<List<Institution>> fetchInstitutions(String regex) async {
    String requestUrl = 'http://localhost:8080/institutions';
    var result;

    if (regex != null ) {
      requestUrl = 'http://localhost:8080/institutions/'+regex;
    }
    var response;
    try {
      response = await http.get(requestUrl);
    } catch (e) {
      logger.e(e);
      throw("Technischer Fehler, bitte versuchen Sie es später erneut.");
    }

    if (response.statusCode == 200) {
      List<dynamic> jsonArray = json.decode(response.body);
      List<Institution> institutions = jsonArray.map((item) => new InstitutionModel.fromJSON(item)).toList();
      result = institutions;
    } else {
      throw("Fehler in der Abarbeitung");
    }

    return result;
  }
}