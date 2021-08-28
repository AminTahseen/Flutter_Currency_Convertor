import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_convertor/utils/HexColor.dart';
import 'package:flutter/material.dart';

class CurrencyItem extends StatelessWidget {
  final String currency;
  final String currencyText;

  const CurrencyItem(this.currency, this.currencyText);

  @override
  Widget build(BuildContext context) {
    var currencyflag = currency.substring(0, 2);
    var imgUrl = 'https://www.countryflags.io/$currencyflag/flat/64.png';
    print(imgUrl);
    return Card(
      elevation: 5,
      shadowColor: HexColor('#273c75'),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        title: Text(
          currency.toUpperCase(),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(currencyText),
      ),
    );
  }
}
