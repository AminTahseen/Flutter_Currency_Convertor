import 'dart:convert';

import 'package:currency_convertor/utils/HexColor.dart';
import 'package:currency_convertor/widgets/currency_selector.dart';
import 'package:currency_convertor/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController amountController = new TextEditingController();
  var currencySelectedTo = 'USD';
  var currencySelectedFroms = 'USD';
  var currencySelectedToParams = 'USD';
  var currencySelectedFromParams = 'USD';
  double currencyRate = 1.0;
  double currencyAmount = 1.0;
  void _setCurrencyTo(String currencyTo) {
    print(currencyTo);
    setState(() {
      currencySelectedTo = currencyTo.toUpperCase();
      currencySelectedToParams = currencyTo;
    });
  }

  void _setCurrencyFrom(String currencyFrom) {
    print(currencyFrom);
    setState(() {
      currencySelectedFroms = currencyFrom.toUpperCase();
      currencySelectedFromParams = currencyFrom;
    });
  }

  Future fetchCurrencyRate() async {
    var url =
        'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/$currencySelectedToParams/$currencySelectedFromParams.json';
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    print(data[currencySelectedFromParams]);
    setState(() {
      currencyAmount = double.parse(amountController.text.toString());
      currencyRate = double.parse(data[currencySelectedFromParams].toString()) *
          currencyAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: HexColor("#192a56"),
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: HexColor('#273c75'),
        centerTitle: true,
        title: Text('Currency.io'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10.0),
                child: MyTextField(amountController),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CurrencySelector(this._setCurrencyTo),
                  Text(
                    'TO',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CurrencySelector(this._setCurrencyFrom),
                ],
              ),
              Container(
                height: 60,
                margin:
                    const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          HexColor('#273c75'))),
                  onPressed: () => fetchCurrencyRate(),
                  child: Text('CONVERT RATE'),
                ),
              ),
              Card(
                elevation: 10.0,
                margin: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(
                    child: Text(
                      '$currencyAmount $currencySelectedTo = $currencyRate $currencySelectedFroms',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: HexColor('#273c75')),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
