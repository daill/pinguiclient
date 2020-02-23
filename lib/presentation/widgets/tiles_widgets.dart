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
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pinguiclient/domain/entities/notification.dart' as pingui;

enum MenuItems { hide }

abstract class Tile extends StatelessWidget {}

class ShowHiddenButtonTile extends Tile {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        child: FlatButton(
          child: Text("Verstecke Nachrichten anzeigen"),
          onPressed: () => {print("bla")},
        ),
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

class NotificationTile extends Tile {
  final pingui.Notification notification;

  NotificationTile({@required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Container(
        child: Row(
          children: <Widget>[
            Padding(
              child: Icon(Icons.notifications, color: Colors.black),
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(notification.institution.name,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    Text(notification.group.name,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
                      child: Text(notification.text),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(DateFormat.yMMMd().format(notification.date),
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                    )
                  ],
                ),
              ),
            ),
            PopupMenuButton<MenuItems>(
              onSelected: (MenuItems result) {
                if (MenuItems.hide == result) {
                  notification.hidden = true;

                }
              },
              child: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: MenuItems.hide,
                  child: Text("Ausblenden"),
                ),
              ],
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

/*
Container(
          padding: new EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
          margin: EdgeInsets.symmetric(vertical: 6.0),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Insititution 1", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text("Gruppe A", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Icon(Icons.more_vert, color: Colors.black),
                ],
              ),
              Padding(
                child: Text("long text with asjaijasd asjidja sidj asd asdasdasdasd hhhghgfhghgh"),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              ),

              Align(
                child: Text("Date of notifications", style: TextStyle(fontSize: 10, color: Colors.grey)),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
      ),
    );
 */
