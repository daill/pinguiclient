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
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:pinguiclient/data/repositories/notification_repository_impl.dart';
import 'package:pinguiclient/database_helper.dart';
import 'package:pinguiclient/domain/repositories/institution_repository.dart';
import 'package:pinguiclient/domain/repositories/notification_repository.dart';
import 'package:pinguiclient/domain/usecases/institution_usecase.dart';
import 'package:pinguiclient/domain/usecases/notification_usecase.dart';
import 'package:pinguiclient/network_info.dart';
import 'package:pinguiclient/presentation/bloc/group/group_bloc.dart';
import 'package:pinguiclient/presentation/bloc/institution/institution_bloc.dart';
import 'package:pinguiclient/presentation/bloc/notification/notification_bloc.dart';
import 'package:pinguiclient/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'data/repositories/group_repository_impl.dart';
import 'data/repositories/institution_repository_impl.dart';
import 'domain/repositories/group_repository.dart';
import 'domain/usecases/group_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerSingleton<DatabaseHelper>(await DatabaseHelper.initDatabase());


  sl.registerSingleton<NetworkInfo>(NetworkInfo());

  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl());
  sl.registerLazySingleton<InstitutionRepository>(() => InstitutionRepositoryImpl(networkInfo: sl()));
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(networkInfo: sl()));

  sl.registerLazySingleton<NotificationUseCase>(() => NotificationUseCase(repository: sl()));
  sl.registerLazySingleton<InstitutionUseCase>(() => InstitutionUseCase(institutionRepository: sl()));
  sl.registerLazySingleton<GroupUseCase>(() => GroupUseCase(groupRepository: sl()));

  sl.registerFactory(() => GroupBloc(
    groupUseCase: sl(),
  ));

  sl.registerFactory(() => NotificationBloc(
    notificationUseCase: sl(),
    dbHelper: sl(),
  ));

  sl.registerFactory(() => NotificationsBloc(
      notificationUseCase: sl(),
      dbHelper: sl(),
  ));

  sl.registerFactory(() => InstitutionBloc(
      institutionUseCase: sl()
  ));

  sl.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());

}
