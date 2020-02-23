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
import 'package:pinguiclient/domain/entities/institution.dart';

import '../bloc_event.dart';

class InstitutionBlocEvent extends BlocEvent {
  final InstitutionBlocEventType type;
  InstitutionBlocEvent({@required this.type: InstitutionBlocEventType.created}) : assert(type != null);
}

class InstitutionBlocEventFetch extends InstitutionBlocEvent {
  final String regex;
  InstitutionBlocEventFetch({@required this.regex}) : super(type: InstitutionBlocEventType.fetch);
}

class InstitutionBlocEventError extends InstitutionBlocEvent {
  final String errorMessage;
  InstitutionBlocEventError({@required this.errorMessage}) : super(type: InstitutionBlocEventType.error);
}

class InstitutionBlocEventDone extends InstitutionBlocEvent {
  final List<Institution> institutions;
  InstitutionBlocEventDone({@required this.institutions}) : super(type: InstitutionBlocEventType.done);
}

enum InstitutionBlocEventType {
  fetch,
  done,
  error,
  created
}