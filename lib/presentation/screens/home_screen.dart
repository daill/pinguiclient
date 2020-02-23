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

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pinguiclient/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:pinguiclient/presentation/routes.dart';
import 'package:pinguiclient/presentation/screens/add_notification_screen.dart';
import 'package:pinguiclient/presentation/screens/notifications_screen.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  NavigationBloc _navigationBloc = new NavigationBloc();
  var _screens = [NotificationsScreen(), AddNotificationScreen()];


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(stream: _navigationBloc.navigationObservable, builder: (context, AsyncSnapshot<int> snapshot){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pingui'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.playlist_add),
              onPressed: () => {
                Navigator.pushNamed(context, AppRoute.selectInstitution)
              },
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(child: const Icon(Icons.add, color: Colors.white,), onPressed: () => Navigator.pushNamed(context, AppRoute.addNotification)),
        body: _screens[snapshot.data ?? 0],
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.home), onPressed: () => this._navigationBloc.changeScreen(0)),
              IconButton(icon: Icon(Icons.account_box), onPressed: () => Navigator.pushNamed(context, AppRoute.manageAccount)),
            ],
          ),
        ),
      );
    });
  }
}