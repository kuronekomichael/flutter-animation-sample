import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

const kAssetImagePath = "images/nigaoe_daruma_taishi.png";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new MaterialApp(
        home: new MyHomePage(),
      );
}

class SkewBorder extends StatelessWidget {
  final double borderWidth;
  SkewBorder([this.borderWidth = 30.0]);

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new ChartPainter(borderWidth),
    );
  }
}

class ChartPainter extends CustomPainter {
  final double borderWidth;
  ChartPainter(this.borderWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      //..color = Colors.blue[400]
      ..color = Colors.white
      ..strokeWidth = borderWidth;
    Offset startEntryOffset = new Offset(0.0, 400.0);
    Offset endEntryOffset = new Offset(2000.0, -2000.0);
    canvas.drawLine(startEntryOffset, endEntryOffset, paint);
  }

  @override
  bool shouldRepaint(ChartPainter old) => true;
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _animationController;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          new Timer(const Duration(seconds: 3), () {
            _animationController.forward();
          });
        }
      })
      ..repeat();

    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController.dispose();
      _animationController = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Stack(
        children: <Widget>[
          Align(child: Image.asset(kAssetImagePath)),
          Align(
              child: SkewBorder(_curvedAnimation.value * 1500.0),
              alignment: Alignment.bottomLeft),
        ],
      ),
    );
  }

  Widget _buildAppBar() => new AppBar(title: new Text("Animation Demo"));

  Widget _buildFloatingActionButton() => new FloatingActionButton(
        onPressed: null,
        child: new Icon(Icons.add),
      );
}
