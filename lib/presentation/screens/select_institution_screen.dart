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
import 'package:pinguiclient/data/models/institution_model.dart';
import 'package:pinguiclient/presentation/bloc/bloc_providing_widget.dart';
import 'package:pinguiclient/presentation/bloc/institution/institution_bloc.dart';
import 'package:pinguiclient/presentation/bloc/institution/institution_event.dart';
import 'package:pinguiclient/presentation/bloc/institution/institution_state.dart';
import 'package:pinguiclient/domain/entities/institution.dart';
import 'package:pinguiclient/presentation/routes.dart';

import '../../globals.dart';
import '../../service_locator.dart';

const Pattern pattern = r'^([0]{1}[1-9]{1}|[1-9]{1}[0-9]{1})[0-9]{3}$';

class SelectInstitutionScreen extends StatefulWidget {
  SelectInstitutionScreen({Key key}) : super(key: key);

  @override
  _SelectInstitutionScreenState createState() =>
      _SelectInstitutionScreenState();
}

class _SelectInstitutionScreenState extends State {
  InstitutionBloc _institutionBloc = sl();
  TextEditingController searchFieldController = TextEditingController();
  TextEditingController institutionFieldController = TextEditingController();
  TextEditingController postalcodeFieldController = TextEditingController();

  bool plzValid = true;
  String institutionName;
  int plz;

  @override
  void dispose() {
    _institutionBloc.dispose();
    super.dispose();
  }

  _clearField() {
    this.searchFieldController.clear();
  }


  int _validate(String value) {
    plzValid = true;
    try {
      if (value.length > 5) {
        plzValid = false;
        print("Error 1");
        return null;
      }

      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) {
        plzValid = false;
        print("Error 2");

        return null;
      }

      plz = int.parse(value);

      return plz;
    } on Exception catch (_) {
      print("Error transform postal code");
      plzValid = false;
      return null;
    }
  }

  _onInput() {
    var value = searchFieldController.text;
    if (value.length > 3) {
      _institutionBloc.emitEvent(InstitutionBlocEventFetch(regex: value));
    }
  }

  _clickedElement(Institution i) {
    // open group selection
    Navigator.pushNamed(context, AppRoute.selectGroup, arguments: i.id);
  }

  _createInstitutionElement(Institution i) {
    return RawMaterialButton(
      onPressed: () => _clickedElement(i),
      child: Card(
        elevation: 8.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(i.name),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(i.postalCode.toString())),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    searchFieldController.addListener(_onInput);

    return BlocProvidingWidget<InstitutionBloc>(
      child: Container(
        color: Theme.of(context).primaryColor,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Institution suchen'),
            ),
            body: Column(
              children: <Widget>[
                TextField(
                    decoration: InputDecoration(
                      hintText: 'Name oder PLZ der Institution',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => _clearField()),
                    ),
                    controller: this.searchFieldController),
                Expanded(child: StreamBuilder<InstitutionBlocState>(
                    stream: _institutionBloc.stream,
                    initialData: InstitutionBlocState.empty(),
                    builder: (BuildContext context, AsyncSnapshot<InstitutionBlocState> snapshot) {
                      if (snapshot.data.done &&
                          snapshot.data.institutions.length > 0) {
                        List<Widget> widgets = snapshot.data.institutions.map((i) => _createInstitutionElement(i)).cast<Widget>().toList();
                          return ListView(
                            children: widgets,
                          );
                      }

                      if (snapshot.data.error) {
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.warning, size: MediaQuery.of(context).size.height * 0.1),
                                  Text(snapshot.data.errorMessage),
                                ],
                              )
                            ],
                          ),
                        );
                      }

                      var generated = <Widget>[];
                      if (snapshot.data != null && snapshot.data.institutions != null) {
                        generated = List<Widget>.from(snapshot.data.institutions.map((i) => _createInstitutionElement(i)));
                      }

                      return Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: ListView(
                          children: generated
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
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
                            Text("Institution hinzufügen", style: TextStyle(
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
                              controller: institutionFieldController,
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'Name der Institution',
                                  hintText: 'z.B. Kindertagesstätte Wabern'),
                              onChanged: (value) {
                                institutionName = value;
                              },
                            ),
                            TextField(
                              controller: postalcodeFieldController,
                              decoration: InputDecoration(
                                  labelText: 'Postleitzahl',
                                  errorText: plzValid ? null : 'Nur Zahlen verwenden' ,
                                  hintText: 'z.B. 34590'),
                              onChanged: (value) {
                                plz = _validate(value);
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              searchFieldController.text = institutionFieldController.text;
                              institutionFieldController.clear();
                              postalcodeFieldController.clear();
                              print("test");
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text('Hinzufügen'),
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.add, color: Colors.white,),
              label: Text("Neue Institution", style: TextStyle(color: Colors.white),),
            ),
          ),
      ),
      bloc: _institutionBloc,
    );
  }
}
