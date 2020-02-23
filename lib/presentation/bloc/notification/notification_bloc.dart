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
import 'package:pinguiclient/data/models/notification_model.dart';
import 'package:pinguiclient/domain/usecases/notification_usecase.dart';
import 'package:pinguiclient/presentation/bloc/bloc_type.dart';
import 'package:pinguiclient/presentation/bloc/notification/notification_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pinguiclient/domain/entities/notification.dart' as pingui;

import '../../../database_helper.dart';
import '../bloc_event.dart';
import 'notification_event.dart';

class NotificationBloc extends SimpleBlocType {
  NotificationUseCase notificationUseCase;

  BehaviorSubject<NotificationBlocState> _notificationStateStream;
  PublishSubject<NotificationBlocEvent> _notificationEventStream;

  NotificationBlocState lastState;
  final NotificationBlocState initialState = NotificationBlocState.inactive();

  DatabaseHelper dbHelper;

  NotificationBloc({@required this.notificationUseCase, @required this.dbHelper}) {
    _notificationStateStream = new BehaviorSubject<NotificationBlocState>.seeded(NotificationBlocState.inactive());
    _notificationEventStream = new PublishSubject<NotificationBlocEvent>();

    _notificationEventStream.listen((NotificationBlocEvent event){
      NotificationBlocState currentState = lastState ?? initialState;
      handleEvent(event, currentState).forEach((NotificationBlocState newState){
        lastState = newState;
        _notificationStateStream.sink.add(newState);
      });
    });
  }

  Stream<NotificationBlocState> handleEvent(NotificationBlocEvent event, NotificationBlocState state) async* {

    if (event.type == NotificationBlocEventType.send) {
      yield NotificationBlocState.processing();


      // send message to the server
      // when finished -> done or error
    }

    if (event.type == NotificationBlocEventType.done) {
      yield NotificationBlocState.done();
    }

    if (event.type == NotificationBlocEventType.error) {
      yield NotificationBlocState.error();
    }
  }

  void emitEvent(BlocEvent event) {
    this._notificationEventStream.add(event);
  }

  Observable<NotificationBlocState> get stream => _notificationStateStream.stream;

  @override
  void dispose() {
    _notificationStateStream.close();
    _notificationEventStream.close();
  }
}