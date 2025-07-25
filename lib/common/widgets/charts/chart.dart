import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     height: 280,
     decoration: BoxDecoration(
       color: Colors.transparent,
       borderRadius: BorderRadius.circular(20)
     ),
     child: Center(
         child: SizedBox(
           height: 400,
           child: LineChart(
             LineChartData(
              
               gridData: FlGridData(
                 show: true,
                 getDrawingHorizontalLine: (value) {
                   return FlLine(
                     color: Colors.transparent,
                     strokeWidth: 0.5,
                   );
                 },
                 drawHorizontalLine: true,
                 getDrawingVerticalLine: (value) {
                   return FlLine(
                     color: Colors.transparent,
                     strokeWidth: 0.5,
                   );
                 }
               ),
               titlesData: FlTitlesData(
                 show: true,
                 bottomTitles: SideTitles(
                   showTitles: false,
                   reservedSize: 35,
                   getTextStyles: (context, value) {
                     return  TextStyle(
                       color: Colors.white,
                       fontSize: 12,
                       fontWeight: FontWeight.bold,
                     );
                   },
                   getTitles: (value) {
                     switch(value.toInt()){
                       case 0:
                         return 'Jan';
                       case 4:
                         return 'June';
                       case 8:
                         return 'Dec';
                     }
                     return '';
                   },
                   margin: 6,
                 ),
                 leftTitles: SideTitles(
                     showTitles: false,
                     reservedSize: 40,
                     getTextStyles: (context, value) {
                       return  TextStyle(
                         color: Colors.black,
                         fontSize: 10,
                         fontWeight: FontWeight.bold,
                       );
                     },
                     getTitles: (value) {
                       switch(value.toInt()){
                         case 0:
                           return '\$5,000';
                         // ignore: no_duplicate_case_values
                         case 2:
                           return '\$10,000';
                         case 4:
                           return '\$15,000';
                        case 6:
                           return '\$20,000';
                       }
                       return '';
                     },
                  //  margin: 10,
                 ),
                 rightTitles: SideTitles(),
                 topTitles: SideTitles(),
               ),
               maxY: 8,
               maxX: 8,
               minX: 0,
               minY: 0,
               lineBarsData: [
                 LineChartBarData(
                   spots: [
                     const FlSpot(0, 6),
                     const FlSpot(2, 4),
                     const FlSpot(2.5, 6.5),
                     const FlSpot(3, 5),
                     const FlSpot(4, 6),
                     const FlSpot(4.5, 3),
                     const FlSpot(5, 2),
                     const FlSpot(5.2, 7),
                     const FlSpot(6, 3),
                     const FlSpot(6.5, 2),
                     const FlSpot(7, 7),
                     const FlSpot(7.3, 6),
                     const FlSpot(7.5, 5),
                     const FlSpot(7.6, 3),
                     
                     const FlSpot(8, 0),
                   ],
                   isCurved: true,
                   colors: [Colors.yellow, Colors.yellow, Colors.amber],
                   dotData:  FlDotData(show: false),
                   barWidth: 5,
                   belowBarData: BarAreaData(
                     show: false,
                     colors: [Colors.blueAccent, Colors.blueGrey]
                   )
                 ),
               ],
           ),
               ),
         ),
     ),
               );
  }
}


