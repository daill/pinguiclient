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
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pinguiclient/domain/entities/notification.dart' as pingui;

import 'domain/entities/group.dart';
import 'domain/entities/institution.dart';
import 'globals.dart';

final String sqlInstitutionsTable = 'CREATE TABLE institutions(id STRING PRIMARY KEY, name TEXT, postal_code INTEGER)';
final String sqlGroupsTable = 'CREATE TABLE groups(id STRING PRIMARY KEY, name TEXT)';
final String sqlNotificationsTable = 'CREATE TABLE notifications(id STRING PRIMARY KEY, type INTEGER, text STRING, institution_id STRING, group_id STRING, date INTEGER, hidden BOOL)';
final String sqlDeleteOverdueNotifications = 'DELETE FROM notifications WHERE name = ?';

class DatabaseHelper {
  Database currentDatabase;

  static Future<DatabaseHelper> initDatabase() async {
    //await deleteDatabase('pingui.db');

    Database db = await openDatabase(join(
      await getDatabasesPath(), 'pingui.db'),
        version: 1,
        onCreate: (db, version) {
          return Future.wait(
              [
                db.execute(sqlInstitutionsTable),
                db.execute(sqlGroupsTable),
                db.execute(sqlNotificationsTable),
              ]
          );
        },
      );
    return Future<DatabaseHelper>.value(DatabaseHelper(currentDatabase: db));
  }

  DatabaseHelper({@required this.currentDatabase});

  Future<List<pingui.Notification>> getNotifications() async {
    final List<Map<String, dynamic>> maps = await this.currentDatabase.query('notifications');

    List<pingui.Notification> notifications = List(maps.length);
    for (var i = 0; i < maps.length; i++) {

      notifications[i]= pingui.Notification(
        id: maps[i]['id'],
        type: maps[i]['type'],
        text: maps[i]['text'],
        institution: await this.getInstitutionById(id: maps[i]['institution_id']),
        group: await this.getGroupById(id: maps[i]['group_id']),
        date: DateTime.fromMicrosecondsSinceEpoch(maps[i]['date']),
        hidden: maps[i]['hidden'] == 1,
      );
    }

    return notifications;
  }

  Future<Group> getGroupById({@required String id}) async {
    final List<Map<String, dynamic>> maps = await this.currentDatabase.query('groups', where: 'id = ?', whereArgs: [id], limit: 1);

    return Group(
      id: maps[0]['id'],
      name: maps[0]['name'],
    );
  }


  Future<Institution> getInstitutionById({@required String id}) async {
    final List<Map<String, dynamic>> maps = await this.currentDatabase.query('institutions', where: 'id = ?', whereArgs: [id], limit: 1);
    var i = Institution(
      id: maps[0]['id'],
      name: maps[0]['name'],
      postalCode: maps[0]['postal_code'],
    );
    return i;
  }

  insertNotifications(List<pingui.Notification> notifications) {
    notifications.forEach((notification) => {
      insertNotification(notification),
    });
    deleteOverdueNotifications().then((deletedCount){
      logger.d("deleted " + deletedCount.toString() + " messages");
    });
  }

  Future<void> insertNotification(pingui.Notification notification) async {
    await insertInstitution(notification.institution);

    await insertGroup(notification.group);

    await this.currentDatabase.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //
  //Deletes overdue notifications from the local database and return the count of deleted rows
  //
  Future<int> deleteOverdueNotifications() async {
    int currentDate = DateTime.now().millisecondsSinceEpoch;
    String whereQry = "(date < ? and type = ?) or (date < ? and type = ?) or (date < ? and type = ?)";
    List<dynamic> qryArgs = [currentDate-pingui.NotificationType.warning.getValidityInMs(), pingui.NotificationType.warning.getId(),
      currentDate-pingui.NotificationType.info.getValidityInMs(), pingui.NotificationType.info.getId(),
      currentDate-pingui.NotificationType.hint.getValidityInMs(), pingui.NotificationType.hint.getId()];
    return await this.currentDatabase.delete('notifications', where: whereQry, whereArgs: qryArgs);
  }

  Future<void> insertInstitution(Institution institution) async {
    await this.currentDatabase.insert(
      'institutions',
      institution.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertGroup(Group group) async {
    await this.currentDatabase.insert(
      'groups',
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}