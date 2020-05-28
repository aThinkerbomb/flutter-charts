import 'dart:math';
import 'package:flutter/material.dart';

class RadarChart extends StatefulWidget {
  final List datas;
  final List features;

  const RadarChart({
    @required this.datas,
    @required this.features,
  });

  @override
  _RadarChartState createState() => _RadarChartState();
}

class _RadarChartState extends State<RadarChart> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 300),
      painter: RadarChartPainter(
        datas: widget.datas,
        features: widget.features,
        animation: _controller,
      ),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List datas;
  final List features;
  final Animation<double> animation;

  RadarChartPainter({
    @required this.datas,
    @required this.features,
    @required this.animation,
  }) : super(repaint: animation);

  void _drawCircles(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    Offset centerOffset = Offset(centerX, centerY);
    double radius = centerX * 0.8;

    Paint outlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    canvas.drawCircle(centerOffset, radius, outlinePaint);
  }

  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    Offset centerOffset = Offset(centerX, centerY);
    double radius = centerX * 0.8;

    _drawCircles(canvas, size);

    var ticks = [10, 20, 30];
    var tickDistance = radius / (ticks.length + 1);
    const double tickLabelFontSize = 12;

    var ticksPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    ticks.sublist(0, ticks.length).asMap().forEach(
      (index, tick) {
        double tickRadius = tickDistance * (index + 1);

        canvas.drawCircle(centerOffset, tickRadius, ticksPaint);

        TextPainter(
          text: TextSpan(
            text: tick.toString(),
            style: TextStyle(color: Colors.grey, fontSize: tickLabelFontSize),
          ),
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: 0, maxWidth: size.width)
          ..paint(
            canvas,
            Offset(centerX, centerY - tickRadius - tickLabelFontSize),
          );
      },
    );

    var angle = (2 * pi) / features.length;
    const double featureLabelFontSize = 16;
    const double featureLabelFontWidth = 12;

    features.asMap().forEach(
      (index, feature) {
        var xAngle = cos(angle * index - pi / 2);
        var yAngle = sin(angle * index - pi / 2);

        var featureOffset = Offset(
          centerX + radius * xAngle,
          centerY + radius * yAngle,
        );

        canvas.drawLine(centerOffset, featureOffset, ticksPaint);

        var labelYOffset = yAngle < 0 ? -featureLabelFontSize : 0;
        var labelXOffset =
            xAngle < 0 ? -featureLabelFontWidth * feature.length : 0;

        TextPainter(
          text: TextSpan(
            text: feature,
            style:
                TextStyle(color: Colors.black, fontSize: featureLabelFontSize),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: 0, maxWidth: size.width)
          ..paint(
            canvas,
            Offset(
              featureOffset.dx + labelXOffset,
              featureOffset.dy + labelYOffset,
            ),
          );
      },
    );

    const graphColors = [Colors.green, Colors.blue];
    var scale = radius / ticks.last;

    datas.asMap().forEach(
      (index, graph) {
        var graphPaint = Paint()
          ..color = graphColors[index % graphColors.length].withOpacity(0.3)
          ..style = PaintingStyle.fill;

        var graphOutlinePaint = Paint()
          ..color = graphColors[index % graphColors.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..isAntiAlias = true;

        // Start the graph on the initial point
        var scaledPoint = scale * graph[0];
        var path = Path();

        path.moveTo(centerX, centerY - scaledPoint);

        graph.sublist(1).asMap().forEach(
          (index, point) {
            var xAngle = cos(angle * (index + 1) - pi / 2);
            var yAngle = sin(angle * (index + 1) - pi / 2);
            var scaledPoint = scale * point;

            path.lineTo(
                centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
          },
        );

        path.close();
        canvas.drawPath(path, graphPaint);
        canvas.drawPath(path, graphOutlinePaint);
      },
    );
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return false;
  }
}
