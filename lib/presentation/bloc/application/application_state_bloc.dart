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

import 'package:flutter/cupertino.dart';
import 'package:pinguiclient/presentation/bloc/application/application_state_event.dart';
import 'package:pinguiclient/presentation/bloc/application/application_state_state.dart';
import 'package:pinguiclient/presentation/bloc/bloc_event.dart';
import 'package:pinguiclient/presentation/bloc/bloc_state.dart';
import 'package:pinguiclient/presentation/bloc/bloc_type.dart';
import 'package:pinguiclient/domain/entities/group.dart';
import 'package:pinguiclient/domain/entities/institution.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

/**
 * load app state from sharedprefs
 *
 */
class ApplicationStateBloc extends BlocType {
  BehaviorSubject<ApplicationStateState> _applicationStateFetcher = new BehaviorSubject<ApplicationStateState>();
  PublishSubject<ApplicationStateEvent> _eventStream = new PublishSubject<ApplicationStateEvent>();

  ApplicationStateState lastState;
  final ApplicationStateState initialState;

  ApplicationStateBloc(this.initialState) {
    _eventStream.listen((ApplicationStateEvent event){
      ApplicationStateState currentState = lastState ?? initialState;
      handleEvent(event, currentState).forEach((ApplicationStateState newState){
        _applicationStateFetcher.sink.add(newState);
      });
    });
  }

  PublishSubject<ApplicationStateEvent> get eventStream => _eventStream;
  Observable<ApplicationStateState> get applicationStateObservable => _applicationStateFetcher.stream;
  Stream<BlocState> get stream => _applicationStateFetcher.stream;


  @override
  void emitEvent(BlocEvent event) {
    this._eventStream.add(event);
  }


  Future<void> gatherNewsReports() async {
    Future.delayed(Duration(seconds: 0), () => this.emitEvent(ApplicationStateEvent(type: ApplicationStateEventType.done)));
  }

  Stream<ApplicationStateState> handleEvent(ApplicationStateEvent event, ApplicationStateState state) async* {
    if (event.type == ApplicationStateEventType.start) {
      gatherNewsReports();
      yield ApplicationStateState.initializing();
    }

    if (event.type == ApplicationStateEventType.done) {
      yield ApplicationStateState.initialized();
    }
  }


  @override
  void dispose() {
    _applicationStateFetcher.close();
    _eventStream.close();
  }

}
