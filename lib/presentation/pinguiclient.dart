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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl_standalone.dart';
import 'package:pinguiclient/presentation/bloc/application/application_state_bloc.dart';
import 'package:pinguiclient/presentation/bloc/application/application_state_event.dart';
import 'package:pinguiclient/presentation/bloc/application/application_state_state.dart';
import 'package:pinguiclient/presentation/bloc/bloc_providing_widget.dart';
import 'package:pinguiclient/presentation/routes.dart';
import 'package:pinguiclient/presentation/screens/select_group_screen.dart';
import 'package:pinguiclient/presentation/screens/select_institution_screen.dart';
import 'package:pinguiclient/presentation/themedata.dart';
import 'package:pinguiclient/presentation/screens/add_notification_screen.dart';
import 'package:pinguiclient/presentation/screens/home_screen.dart';
import 'package:pinguiclient/presentation/screens/manage_account_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uuid/uuid.dart';

import '../globals.dart';
import '../service_locator.dart';
import 'localizations.dart';
import '../domain/entities/keys.dart';

/*
  Main widget
 */
class PinguiClient extends StatefulWidget {
  @override
  _PinguiClientState createState() => _PinguiClientState();
}

class _PinguiClientState extends State<PinguiClient> {
  SharedPreferences sharedPreferences;
  bool institutionsSelected = false;
  var bloc = ApplicationStateBloc(ApplicationStateState.notInitialized());

  @override
  Widget build(BuildContext context) {
    Widget screen = HomeScreen();

    Intl.defaultLocale = "de";

    return MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: PinguiTheme,
        supportedLocales: [
          const Locale('de', ''),
          const Locale('en', ''),
        ],
        routes: {
          AppRoute.addNotification: (context) => AddNotificationScreen(),
          AppRoute.manageAccount: (context) => ManageAccountScreen(),
          AppRoute.selectInstitution: (context) => SelectInstitutionScreen(),
          AppRoute.selectGroup: (context) => SelectGroupScreen(),
        },
        home: BlocProvidingWidget<ApplicationStateBloc>(
          bloc: bloc,
          child:Container(
            color: PinguiTheme.primaryColor,
              child: StreamBuilder<ApplicationStateState>(
                stream: bloc.stream,
                initialData: bloc.initialState,
                builder: (BuildContext context, AsyncSnapshot<ApplicationStateState> snapshot){
                  if (!snapshot.data.initialized && !snapshot.data.initializing) {
                    bloc.emitEvent(ApplicationStateEvent(type: ApplicationStateEventType.start));
                  }

                  if (snapshot.data.initializing && !snapshot.data.initialized) {
                    return Text("Initializng");
                  }

                  if (snapshot.data.initialized) {
                    return screen;
                  }

                  return Text("Nothing");
                },
              ),
          )
        )
    );
  }

  @override
  void initState() {
    super.initState();
    sharedPreferences = sl();
    if (sharedPreferences.getString(SP_PINGUID) == null) {
      var uuid = Uuid();
      sharedPreferences.setString(SP_PINGUID, uuid.v4());
    }
    logger.d("uuid id:" + sharedPreferences.getString("pinguid"));
  }
}
