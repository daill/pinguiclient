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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pinguiclient/globals.dart';
import 'package:pinguiclient/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:pinguiclient/domain/entities/notification.dart';
import 'package:pinguiclient/domain/entities/notification.dart' as pingui;
import 'package:pinguiclient/presentation/bloc/notifications/notifications_event.dart';
import 'package:pinguiclient/presentation/bloc/notifications/notifications_state.dart';
import '../../service_locator.dart';
import '../widgets/tiles_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State {
  // on creation call fetching initially
  NotificationsBloc _notificationsBloc = sl();
  bool alreadyRefreshing = false;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _onRefresh() async {
    Completer _completer = new Completer();
    _notificationsBloc.emitEvent(FetchNotifications(completer: _completer));
    return _completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Color(0xffd5d6d2)),
        child: Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: RefreshIndicator(
                key: _refreshKey,
                onRefresh: this._onRefresh,
                child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: StreamBuilder(
                    stream: _notificationsBloc.observable,
                    builder: (context, AsyncSnapshot<NotificationsBlocState> snapshot) {
                      List<Widget> widgets = [];

                      if (snapshot.data is Loaded) {
                        (snapshot.data as Loaded).notifications.forEach((element) {
                          if (!element.hidden) {
                            widgets.add(NotificationTile(
                              notification: element,
                            ));
                          }
                        });
                        widgets.add(ShowHiddenButtonTile());
                      }

                      if (snapshot.data is Loading) {
                        widgets.add(Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          ],
                        ));
                      }

                      if (snapshot.data is Error) {
                        return Text((snapshot.data as Error).message);
                      }

                      return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: widgets);
                    }),
              ),
        ))));
  }

  @override
  void initState() {
    super.initState();
    _notificationsBloc.emitEvent(FetchNotificationsLocally());
  }
}
