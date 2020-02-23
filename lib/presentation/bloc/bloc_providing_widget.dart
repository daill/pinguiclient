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
import 'package:pinguiclient/presentation/bloc/bloc_type.dart';

/*

 */
class BlocProvidingWidget<T extends BlocType> extends StatefulWidget {
  final Widget child;
  final T bloc;

  const BlocProvidingWidget({Key key, @required this.bloc, @required this.child}) : super(key: key);

  @override
  _BlocProvidingWidgetState<T> createState() => _BlocProvidingWidgetState<T>();

  static T of<T extends BlocType>(BuildContext context) {
    _BlocInheritedWidget<T> inherited = context.ancestorInheritedElementForWidgetOfExactType(T)?.widget;
    return inherited?.bloc;
  }
}

class _BlocProvidingWidgetState<T extends BlocType> extends State<BlocProvidingWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return _BlocInheritedWidget(bloc: widget.bloc, child: widget.child,);
  }
}

class _BlocInheritedWidget<T> extends InheritedWidget {
  final T bloc;

  _BlocInheritedWidget({Key key,
      @required Widget child,
      @required this.bloc}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {return true;}
}