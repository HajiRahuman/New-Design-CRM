import 'dart:convert';

import 'package:crm/AppStaticData/logger.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';



class Live_Graph extends StatefulWidget {
  final int subscriberId;

  const Live_Graph({
    Key? key,
    required this.subscriberId,
  }) : super(key: key);

  @override
  State<Live_Graph> createState() => _LiveGraphState();
}

class _LiveGraphState extends State<Live_Graph> {
  late WebSocketChannel channel;
  final List<FlSpot> txDataPoints = [];
  final List<FlSpot> rxDataPoints = [];

  @override

  int selectedMin = 5;
  String selectedMinutesDisplay = '5 mins';

  void initState() {
    super.initState();
    setUpConnection(selectedMin);
  }



  Future<void> setUpConnection(selectedMin) async {
    final pref = await SharedPreferences.getInstance();
    String authToken = pref.getString('authToken') ?? '';
    String cookieToken = pref.getString('cookies') ?? '';
    channel = IOWebSocketChannel.connect(
      Uri.parse(
          'wss://crm.gsisp.in/api/subscriber/${widget.subscriberId}/live_graph/${selectedMin}'),
      headers: {
        'authorization': 'Bearer $authToken',
        'Cookie': cookieToken,
      },
    );
    channel.stream.listen((message) {
      logger.i('Message---$message');
      if (message != null) {
        Map<String, dynamic> data = jsonDecode(message);

        double txValue = data['tx'] == 0 ? 0 : double.parse(data['tx']);
        double rxValue = data['rx'] == 0 ? 0 : double.parse(data['rx']);
        setState(() {
          txDataPoints.add(FlSpot(txDataPoints.length.toDouble(), txValue));
          rxDataPoints.add(FlSpot(rxDataPoints.length.toDouble(), rxValue));
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
      final notifier = Provider.of<ColorNotifire>(context);
    return  SingleChildScrollView(
      child: Column(
        children: [
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Live Graph',
                       style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.05,),
                    ),
                  CircleAvatar(
                                                                        radius: 20,
                                                                        child: IconButton(
                                                                          onPressed: () {
                                                                            Navigator.of(
                                                                                context)
                                                                                .pop();
                                                                          },
                                                                          icon:  Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                                color: notifier.getMainText,
                                                                          ),
                                                                        ),
                                                                      ),
                  ],
                ),
              ),
            
          
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title:  Text('5',
                  
                   style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.02,),),
                  leading: Radio<int>(
                    value: 5,
                    groupValue: selectedMin,
                    onChanged: (value) {
                      setState(() {
                        selectedMin = value!;
                        selectedMinutesDisplay = '$value mins';
                        print("Button value: $value");
                      });
                      setUpConnection(selectedMin);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title:  Text('10',
                   style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.02,)),
                  leading: Radio<int>(
                    value: 10,
                    groupValue: selectedMin,
                    onChanged: (value) {
                      setState(() {
                        selectedMin = value!;
                        selectedMinutesDisplay = '$value mins';
                        print("Button value: $value");
                      });
                      setUpConnection(selectedMin);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title:  Text('15',  style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.02,)),
                  leading: Radio<int>(
                    value: 15,
                    groupValue: selectedMin,
                    onChanged: (value) {
                      setState(() {
                        selectedMin = value!;
                        selectedMinutesDisplay = '$value mins';
                        print("Button value: $value");
                      });
                      setUpConnection(selectedMin);
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selected Minutes: $selectedMinutesDisplay', // Display selected minutes
               style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize:16),
            ),
          ),
          const SizedBox(height: 25),
          AspectRatio(
            aspectRatio: 2.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child:
              LineChart(
                LineChartData(
                  minX: txDataPoints.isNotEmpty ? txDataPoints.first.x : 0,
                  maxX: txDataPoints.isNotEmpty ? txDataPoints.last.x : 10,
                  lineTouchData: LineTouchData(enabled: false),
                  clipData: FlClipData.all(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),

                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                       txLine(txDataPoints),
                       rxLine(rxDataPoints),
                      ],
                      titlesData: FlTitlesData(
                        // show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          margin: 8,
                      
                        ),
                        leftTitles: SideTitles(showTitles: true),
                        topTitles: SideTitles(showTitles: false),
                        rightTitles: SideTitles(showTitles: false),

                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData txLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      isCurved: false,
      colors: [const Color(0xFF80FFA5)],
      barWidth: 2,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(show: false),
    );
  }

  LineChartBarData rxLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      isCurved: false,
      colors: [const Color(0xFF00DDFF)], // Change color as needed
      barWidth: 2,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(show: false),
    );
  }


  @override
  void dispose() {
    channel.sink.close(); // Close the WebSocket connection
    super.dispose();
  }
}