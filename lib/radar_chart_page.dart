import 'package:flutter/material.dart';

import 'charts/radar_chart.dart';

class RadarChartPage extends StatefulWidget {
  @override
  _RadarChartPageState createState() => _RadarChartPageState();
}

class _RadarChartPageState extends State<RadarChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RadarChart(
          datas: [
            [30, 20, 28, 15, 16],
            // [15, 30, 8, 24, 23]
          ],
          features: ["学习能力", "英语水平", "编码能力", "解决问题能力", "工作态度"],
        ),
      ),
    );
  }
}
