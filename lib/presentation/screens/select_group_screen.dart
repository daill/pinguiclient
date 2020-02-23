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
import 'package:pinguiclient/presentation/bloc/bloc_providing_widget.dart';
import 'package:pinguiclient/presentation/bloc/group/group_bloc.dart';
import 'package:pinguiclient/presentation/bloc/institution/institution_bloc.dart';

import '../../globals.dart';
import '../../service_locator.dart';

class SelectGroupScreen extends StatefulWidget {
  SelectGroupScreen({Key key}) : super(key: key);

  @override
  _SelectGroupScreenState createState() =>
      _SelectGroupScreenState();
}

class _SelectGroupScreenState extends State<SelectGroupScreen> {
  TextEditingController groupFieldController = TextEditingController();
  var groupBloc = GroupBloc(groupUseCase: sl());

  String groupName;

  @override
  Widget build(BuildContext context) {
    String institutionId = ModalRoute.of(context).settings.arguments;
    logger.d("selected institution id: " + institutionId);


    return BlocProvidingWidget<GroupBloc>(
      child: Container(
          color: Theme.of(context).primaryColor,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Gruppe wählen'),
            ),
            body: Column(children: <Widget>[],),
            floatingActionButton : FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.playlist_add),
                            ),
                            Text("Gruppe hinzufügen", style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 25,
                            ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: groupFieldController,
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'Name der Gruppe',
                                  hintText: 'z.B. Entengruppe'),
                              onChanged: (value) {
                                groupName = value;
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text('Hinzufügen'),
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.add, color: Colors.white,),
              label: Text("Neue Gruppe", style: TextStyle(color: Colors.white),),
            ),
          ),
      ),
      bloc: groupBloc,
    );
  }
}
