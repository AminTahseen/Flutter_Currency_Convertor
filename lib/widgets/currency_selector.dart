import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_convertor/model/currency.dart';
import 'package:currency_convertor/widgets/currencyitem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencySelector extends StatefulWidget {
  final Function _selectCurrency;
  CurrencySelector(this._selectCurrency);
  @override
  _CurrencySelectorState createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  TextEditingController filterController = new TextEditingController();

  void _selectCurrency(var currencySelect, var currencySelectImg) {
    setState(() {
      currencySelected = currencySelect;
      currencySelectedImg = currencySelectImg.substring(0, 2);
    });
    widget._selectCurrency(currencySelect);
    Navigator.pop(context);
    currencyList.clear();
    fetchCurrencies().then((value) {
      value.forEach((currencyCode, currencyText) {
        currencyList.add(
            Currency(currency_code: currencyCode, currency_text: currencyText));
      });
    });
  }

  Future fetchCurrencies() async {
    var url =
        'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies.json';
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);

    return data;
  }

  var currencySelected = 'USD';
  var currencySelectedImg = 'US';

  var currencyList = <Currency>[];
  var list = ['USD', 'PKR', 'INR'];

  void filterList(String filterTerm) {
    var tempData = currencyList
        .where((element) => element.currency_code
            .toLowerCase()
            .contains(filterTerm.toLowerCase()))
        .toList();

    print("list $tempData");
    setState(() {
      currencyList = tempData;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCurrencies().then((value) {
      value.forEach((currencyCode, currencyText) {
        currencyList.add(
            Currency(currency_code: currencyCode, currency_text: currencyText));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var imgUrl = 'https://www.countryflags.io/$currencySelectedImg/flat/64.png';

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              elevation: 16,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Select Currency',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                        onChanged: (String value) async {
                          filterList(value);
                        },
                        controller: filterController,
                        decoration: InputDecoration(
                          hintText: "Filter Currency",
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: currencyList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return new InkWell(
                                onTap: () => _selectCurrency(
                                    currencyList[index].currency_code,
                                    currencyList[index].currency_code),
                                child: CurrencyItem(
                                    currencyList[index].currency_code,
                                    currencyList[index].currency_text),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 10.0,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.35,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Text(
                  currencySelected.toUpperCase(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
