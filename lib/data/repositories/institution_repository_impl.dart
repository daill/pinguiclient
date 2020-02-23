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

import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:pinguiclient/api_request_status.dart';
import 'package:pinguiclient/data/api/institution_api.dart';
import 'package:pinguiclient/domain/entities/institution.dart';
import 'package:pinguiclient/domain/repositories/institution_repository.dart';
import 'package:pinguiclient/network_info.dart';

import '../../globals.dart';


class InstitutionRepositoryImpl implements InstitutionRepository {


  NetworkInfo networkInfo;
  InstitutionRepositoryImpl({@required this.networkInfo});

  @override
  Future<List<Institution>> getAllInstitutions(String regex) async {
    ConnectivityResult conn = await networkInfo.checkConn();
    var result;

    if (conn == ConnectivityResult.mobile || conn == ConnectivityResult.wifi) {
      logger.d("connection available");
      result = InstitutionApi.fetchInstitutions(regex);
    } else {
      logger.d("connection not available");
      throw("Keine Internetverbindung");
    }

    return result;
  }



}