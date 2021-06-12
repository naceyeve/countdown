import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController _counterController = TextEditingController();
  Timer? _timer;

  void _decreaseCounter() {
    setState(() {
      _counter--;
    });
  }

  //开始
  void _start() {
    if (_counterController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "请输入有效值",
        gravity: ToastGravity.CENTER,
      );
    } else {
      setState(() {
        if (_timer != null) {
          _timer!.cancel();
        }
      });

      setState(() {
        _counter = int.parse(_counterController.text);
      });

      _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
        _decreaseCounter();
        if (_counter <= 0) {
          setState(() {
            timer.cancel();
          });
        }
      });
    }
  }

  //结束
  void _stop() {
    setState(() {
      _timer!.cancel();
      _counter = 0;
    });
  }

  // 时分秒
  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '输入倒计时长，点击【开始】，开始倒计时，点击【结束】，停止倒计时。',
            ),
            Text(
              '${formatHHMMSS(_counter)}',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextField(
                autofocus: true,
                controller: _counterController,
                decoration: InputDecoration(
                  labelText: "倒计时长",
                  hintText: "请输入倒计时长",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('^[0-9]*\$'))
                ]),
            Row(
              children: [
                TextButton(
                  child: Text("开始"),
                  onPressed: _start,
                ),
                TextButton(
                  child: Text("结束"),
                  onPressed: _stop,
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
