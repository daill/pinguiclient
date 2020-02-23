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
import 'package:flutter/widgets.dart';
import 'package:pinguiclient/presentation/bloc/notification/notification_bloc.dart';
import 'package:pinguiclient/presentation/bloc/notification/notification_event.dart';
import 'package:pinguiclient/presentation/bloc/notification/notification_state.dart';
import 'package:pinguiclient/presentation/bloc/typeselect/type_select_bloc.dart';
import 'package:pinguiclient/domain/entities/message_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service_locator.dart';

class AddNotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddNotificationScreenState();
}


class AddNotificationScreenState extends State<AddNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _inputFieldController = TextEditingController();

  TypeSelectBloc typeSelectBloc = TypeSelectBloc();
  NotificationBloc notificationBloc = NotificationBloc();

  void sendMessage() {

  }

  void _showSnackbar(BuildContext context, String message) {
    Future.delayed(Duration.zero, () => {Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text(message)
        )
    )});
  }

  void typeSelected(MessageType type) {
    typeSelectBloc.sink(type);
  }

  @override
  Widget build(BuildContext context) {
    var uuid = sl<SharedPreferences>().get("pinguid");

    return Container(
      color: Theme.of(context).primaryColor,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Nachricht hinzufügen'),
          ),
          body: StreamBuilder(stream: notificationBloc.stream, builder: (context, AsyncSnapshot<NotificationBlocState> snapshot)
          {
            if (snapshot.hasData) {
              if (snapshot.data.processing) {
                _showSnackbar(context, "Sende Nachricht");
              } else if (snapshot.data.error) {
                _showSnackbar(context, "Fehler");
              } else if (snapshot.data.done) {
                _showSnackbar(context, "Nachricht gesendet");
              }
            }

            return SingleChildScrollView(
               child: Builder(
                builder: (BuildContext context) {
              // maybe not the best place to add the StreamBuilder but in the end it could be useful to have the whole ui redrawn
                  return  Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            child: SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                  ),
                                ),
                                height: 50),
                          ),
                          Positioned(
                              top: 20,
                              child: ClipOval(
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.white),
                                  child: FloatingActionButton(child: Icon(Icons.add, color: Colors.white,),),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(height: 50),
                      Form(
                        key: _formKey,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 0.0, left: 20.0, right: 20.0),
                          child: Card(
                            elevation: 8.0,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  child: Text("Nachrichtentyp"),
                                  padding: EdgeInsets.only(top: 20.0),
                                ),
                                Container(
                                  child: StreamBuilder(
                                      stream: typeSelectBloc.observable,
                                      builder: (context,
                                          AsyncSnapshot<MessageType> snapshot) {
                                        print(snapshot.data);
                                        return ButtonBar(
                                          alignment: MainAxisAlignment
                                              .spaceAround,
                                          children: <Widget>[
                                            RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              color: snapshot.data ==
                                                  MessageType.HINT ? Theme.of(context).primaryColor : Theme.of(context).buttonColor,
                                              onPressed: () =>
                                                  typeSelected(MessageType.HINT),
                                              child: Container(
                                                padding: EdgeInsets.all(6.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.chat_bubble_outline,
                                                      color: Colors.black26,
                                                    ),
                                                    Text('Hinweis',
                                                        style: TextStyle(
                                                            fontSize: 15, color: Theme.of(context).accentColor)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                ),
                                                color: (snapshot.data ==
                                                    MessageType.INFO) ? Theme
                                                    .of(context)
                                                    .primaryColor : Theme
                                                    .of(context)
                                                    .buttonColor,
                                                onPressed: () =>
                                                    typeSelected(
                                                        MessageType.INFO),
                                                child: Container(
                                                  padding: EdgeInsets.all(6.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Icon(Icons.info,
                                                        color: Colors.blue,),
                                                      Text(
                                                        'Info',
                                                        style: TextStyle(fontSize: 15, color: Theme.of(context).accentColor),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)),
                                              color: snapshot.data ==
                                                  MessageType.WARNING ? Theme
                                                  .of(context)
                                                  .primaryColor : Theme
                                                  .of(context)
                                                  .buttonColor,
                                              onPressed: () =>
                                                  typeSelected(
                                                      MessageType.WARNING),
                                              child: Container(
                                                padding: EdgeInsets.all(6.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Icon(Icons.warning,
                                                        color: Colors
                                                            .deepOrangeAccent),
                                                    Text('Warnung',
                                                        style: TextStyle(
                                                            fontSize: 15, color: Theme.of(context).accentColor)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Container(
                                      child: TextFormField(
                                        controller: _inputFieldController,
                                        minLines: 3,
                                        maxLines: 19,
                                        maxLength: 250,
                                        maxLengthEnforced: true,
                                        decoration: const InputDecoration(
                                          alignLabelWithHint: false,
                                          hintText: "Mitteilung",
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Die Nachricht darf nicht leer sein.';
                                          }
                                          return null;
                                        },
                                      )
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children: <Widget>[
                                      RaisedButton(
                                        color: Theme
                                            .of(context)
                                            .dialogTheme
                                            .backgroundColor,
                                        onPressed: () {
                                          if (_formKey.currentState.validate()) {
                                            notificationBloc.emitEvent(
                                                NotificationBlocEventSend(
                                                    message: _inputFieldController.text,
                                                    uuid: uuid,
                                                    targetInstitution: null,
                                                    targetGroup: null
                                                )
                                            );
                                          }
                                        },
                                        child: Text('Mitteilung senden'),
                                      ),
                                      RaisedButton(
                                        color: Theme
                                            .of(context)
                                            .canvasColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Zurück'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                )
              );
            },
          ),
        ),
    );
  }
}
