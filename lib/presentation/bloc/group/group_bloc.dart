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
import 'package:pinguiclient/domain/usecases/group_usecase.dart';
import 'package:pinguiclient/domain/usecases/institution_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../bloc_event.dart';
import '../bloc_state.dart';
import '../bloc_type.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends BlocType {
  GroupUseCase groupUseCase;

  BehaviorSubject<GroupBlocState> _groupStateStream = new BehaviorSubject<GroupBlocState>();
  PublishSubject<GroupBlocEvent> _groupEventStream = new PublishSubject<GroupBlocEvent>();

  GroupBlocState lastState;
  final GroupBlocState initialState = GroupBlocState.empty();

  GroupBloc({@required this.groupUseCase}) {
    _groupEventStream.listen((GroupBlocEvent event){
      GroupBlocState currentState = lastState ?? initialState;
      handleEvent(event, currentState).forEach((GroupBlocState newState){
        _groupStateStream.sink.add(newState);
      });
    });
  }

  PublishSubject<GroupBlocEvent> get eventStream => _groupEventStream;
  Observable<GroupBlocState> get stream => _groupStateStream.stream;


  @override
  void emitEvent(BlocEvent event) {
    this._groupEventStream.add(event);
  }


  Future<void> gatherNewsReports() async {
    Future.delayed(Duration(seconds: 10), () => this.emitEvent(GroupBlocEvent(type: GroupBlocEventType.done)));
  }

  Stream<GroupBlocState> handleEvent(GroupBlocEvent event, GroupBlocState state) async* {
    if (event.type == GroupBlocEventType.fetch) {
      yield GroupBlocState.fetching();
    }

    if (event.type == GroupBlocEventType.done) {
      yield GroupBlocState.done((event as GroupBlocEventDone).institutions);
    }

    if (event.type == GroupBlocEventType.error) {
      yield GroupBlocState.error((event as GroupBlocEventError).errorMessage);
    }
  }

  @override
  void dispose() {
    _groupStateStream.close();
    _groupEventStream.close();
  }
}