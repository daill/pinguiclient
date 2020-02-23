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

import 'package:flutter/cupertino.dart';
import 'package:pinguiclient/data/api/institution_api.dart';
import 'package:pinguiclient/domain/entities/group.dart';
import 'package:pinguiclient/domain/entities/institution.dart';
import 'package:pinguiclient/domain/usecases/institution_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../bloc_event.dart';
import '../bloc_state.dart';
import '../bloc_type.dart';
import 'institution_event.dart';
import 'institution_state.dart';

class InstitutionBloc extends BlocType {
  String institutionName = '';
  int plz;
  bool plzValid = true;
  InstitutionUseCase institutionUseCase;

  BehaviorSubject<InstitutionBlocState> _institutionStateStream = new BehaviorSubject<InstitutionBlocState>();
  PublishSubject<InstitutionBlocEvent> _institutionEventStream = new PublishSubject<InstitutionBlocEvent>();

  InstitutionBlocState lastState;
  final InstitutionBlocState initialState = InstitutionBlocState.empty();

  InstitutionBloc({@required this.institutionUseCase}) {
    _institutionEventStream.listen((InstitutionBlocEvent event){
      InstitutionBlocState currentState = lastState ?? initialState;
      handleEvent(event, currentState).forEach((InstitutionBlocState newState){
        _institutionStateStream.sink.add(newState);
      });
    });
  }

  PublishSubject<InstitutionBlocEvent> get eventStream => _institutionEventStream;
  Observable<InstitutionBlocState> get stream => _institutionStateStream.stream;


  @override
  void emitEvent(BlocEvent event) {
    this._institutionEventStream.add(event);
  }


  Future<void> gatherNewsReports() async {
    Future.delayed(Duration(seconds: 10), () => this.emitEvent(InstitutionBlocEvent(type: InstitutionBlocEventType.done)));
  }

  Stream<InstitutionBlocState> handleEvent(InstitutionBlocEvent event, InstitutionBlocState state) async* {
    if (event.type == InstitutionBlocEventType.fetch) {
      yield InstitutionBlocState.fetching();
      institutionUseCase.getAllInstitutions((event as InstitutionBlocEventFetch).regex).then((institutions) => {
        this._institutionEventStream.sink.add(InstitutionBlocEventDone(institutions: institutions))
      }).catchError((e) => {
        this._institutionEventStream.sink.add(InstitutionBlocEventError(errorMessage: e))
      });
    }

    if (event.type == InstitutionBlocEventType.done) {
      yield InstitutionBlocState.done((event as InstitutionBlocEventDone).institutions);
    }

    if (event.type == InstitutionBlocEventType.error) {
      yield InstitutionBlocState.error((event as InstitutionBlocEventError).errorMessage);
    }
  }

  @override
  void dispose() {
    _institutionStateStream.close();
    _institutionEventStream.close();
  }
}