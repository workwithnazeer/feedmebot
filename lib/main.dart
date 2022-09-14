import 'dart:async';

import 'package:flutter/material.dart';

import 'model/order.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'McDonald Bot',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'McDonald Bot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // An array List to store both VIP Order & Normal Order
  List<Order> orderedList = [];

  // Timer helps to start bot & cancel
  Timer? _timer;

  // This bool helps to check whether bot is running or not
  bool? _startBot = false;

  // This integer helps to set unique number for each and every order
  int _uniqueid = 0;

  // To store filtered array list data
  Iterable<Order> pendingOrder = [];

  // To call the bot in periodic duration till "PENDING" array list empty
  void calltimer() async {
    // Update bot status
    _startBot = true;

    // Start the bot and every 10 seconds order status changed from "PENDING"
    // to "COMPLETED"
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Filter array list into "PENDING" orders alone
      pendingOrder =
          orderedList.where((element) => element.orderStatus == "PENDING");

      // To check "PENDING" orders list not empty
      if (pendingOrder.isNotEmpty) {
        setState(() {
          // In Top of the order list, Changed order status into "COMPLETED"
          pendingOrder.first.orderStatus = "COMPLETED";
        });
      } else {
        // If "PENDING" orders list is empty, then Pause the bot
        _timer!.cancel();
      }
    });
  }

  void newNormalOrder() {
    setState(() {
      // While bot is pause stage due to empty "PENDING" list
      // To check "PENDING" order is empty & bot running
      if (pendingOrder.isEmpty && _startBot!) {
        //Reset the bot timer, Once new order placed
        _timer!.cancel();
        calltimer();
      }

      // Unique number generation
      _uniqueid++;

      // New Normal Order Creation
      orderedList.add(Order(
          orderId: _uniqueid,
          itemName: "Item $_uniqueid",
          isMember: false,
          orderStatus: "PENDING"));
    });

    // Sort the list to display normal order in ascending
    // order by order ID
    orderedList.sort();
  }

  void newVIPOrder() {
    setState(() {
      // While bot is pause stage due to empty "PENDING" list
      // To check "PENDING" order is empty & bot running
      if (pendingOrder.isEmpty && _startBot!) {
        //Reset the bot timer, Once new order placed
        _timer!.cancel();
        calltimer();
      }

      // Unique number generation
      _uniqueid++;

      // New VIP Order Creation
      orderedList.add(Order(
          orderId: _uniqueid,
          itemName: "VIP Item $_uniqueid",
          isMember: true,
          orderStatus: "PENDING"));
    });

    // Sort the list to display VIP order in ascending
    // order by order ID and listed in top most order
    orderedList.sort();
  }

  // Release from Memory
  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  // New Normal Order Button with Action
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      // To create normal order
                      newNormalOrder();
                    },
                    child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text('New Normal Order')),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      // To create VIP order
                      newVIPOrder();
                    },
                    child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text('New VIP Order')),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // - BOT Button with Action
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      // To update bot status
                      _startBot = false;

                      // Stop the bot
                      _timer!.cancel();
                    },
                    child: const Padding(
                        padding: EdgeInsets.all(15.0), child: Text('- BOT')),
                  ),
                  const Spacer(),
                  // + BOT Button with Action
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      // To start the bot
                      calltimer();
                    },
                    child: const Padding(
                        padding: EdgeInsets.all(15.0), child: Text('+ BOT')),
                  )
                ],
              ),
              const SizedBox(height: 20),
              // To display pending order label
              const Text(
                "PENDING ORDERS",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 180, 11, 22)),
              ),
              const SizedBox(height: 20),
              // To list PENDING ORDER's
              Column(
                children: orderedList
                    .where((element) => element.orderStatus == "PENDING")
                    .map((orderlist) {
                  return Container(
                    child: Card(
                      child: ListTile(
                        title: Text(orderlist.itemName),
                        subtitle: Text(orderlist.orderStatus),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // To display completed order label
              const Text(
                "COMPLETED ORDERS",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber),
              ),
              const SizedBox(height: 20),
              // To list COMPLETED ORDER's
              Column(
                children: orderedList
                    .where((element) => element.orderStatus == "COMPLETED")
                    .map((orderlist) {
                  return Container(
                    child: Card(
                      child: ListTile(
                        title: Text(orderlist.itemName),
                        subtitle: Text(orderlist.orderStatus),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
