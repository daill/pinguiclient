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
import 'package:pinguiclient/database_helper.dart';
import 'package:pinguiclient/domain/usecases/notification_usecase.dart';
import 'package:pinguiclient/presentation/bloc/bloc_type.dart';
import 'package:pinguiclient/presentation/bloc/notifications/notifications_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pinguiclient/domain/entities/notification.dart' as pingui;

import '../../../globals.dart';
import '../bloc_event.dart';
import 'notifications_event.dart';



class NotificationsBloc extends SimpleBlocType {
  DatabaseHelper dbHelper;

  NotificationsBlocState currentState;
  NotificationUseCase notificationUseCase;


  BehaviorSubject<NotificationsBlocState> _notificationsStateStream;
  PublishSubject<NotificationsBlocEvent> _notificationsEventStream;

  // load local notifications before fetch update
  NotificationsBlocState _initialState;

  // ignore: non_constant_identifier_names
  NotificationsBloc({@required this.notificationUseCase, @required this.dbHelper}) {
    this._notificationsStateStream = new BehaviorSubject<NotificationsBlocState>.seeded(this._initialState);
    this._notificationsEventStream = new PublishSubject<NotificationsBlocEvent>();
    this._initialState = Loaded(notifications: []);

    this._notificationsEventStream.listen((NotificationsBlocEvent event){
      //logger.d(event.toString());

      handleEvent(event, currentState).forEach((NotificationsBlocState newState){
        currentState = newState;
        this._notificationsStateStream.sink.add(newState);
      });
    });


  }

  void emitEvent(BlocEvent event) {
    this._notificationsEventStream.sink.add(event);
  }

  Stream<NotificationsBlocState> handleEvent(NotificationsBlocEvent event, NotificationsBlocState currentState) async* {
    if (event is FetchNotifications) {
      // trigger fetching
      logger.d("fetching notifications");

      yield Loading();
      try {
        await Future.delayed(Duration(seconds: 10));
        var notificationList = await this.notificationUseCase.getAllActiveNotifications();
        yield Loaded(notifications: notificationList);
        event.completer.complete();
        this.dbHelper.insertNotifications(notificationList);
      } catch(e) {
        logger.e(e);
        event.completer.completeError(e);
        yield Error();
      }
    }

    if (event is FetchNotificationsLocally) {
      // trigger fetching
      logger.d("fetching notifications locally");

      try {
        var notificationList = await this.dbHelper.getNotifications();
        logger.d("retrieved notifications from database");
        yield Loaded(notifications: notificationList);
        //this._notificationsEventStream.sink.add(FetchNotifications());
      } catch(e) {
        logger.e(e);
      }
    }
  }

  Observable<NotificationsBlocState> get observable => _notificationsStateStream.stream;

  @override
  void dispose() {
    _notificationsStateStream.close();
    _notificationsEventStream.close();
  }

}