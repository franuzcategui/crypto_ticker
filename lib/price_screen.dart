import 'package:bitcoin_ticker/components/ticker_card.dart';
import 'package:bitcoin_ticker/services/coin_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currentSelectedFiat = currenciesList[0];
  Map<String, String> currentCryptoDisplayRate = {};
  Map<String, Map<String, String>> cryptoRateMap = {};

  //Gets the Map (Decoded Json) For all of the Fiat rates for each Crypto in the Cryptolist and sets the initial value for each crypto/fiat pair
  Future<void> setUpRates() async {
    CoinModel coinModel = CoinModel();
    cryptoRateMap = await coinModel.getRateList();

    for (String crypto in cryptoList) {
      Map<String, String> currentCryptoFiatMap = cryptoRateMap[crypto] ?? {};
      if (currentCryptoFiatMap.containsKey(currentSelectedFiat)) {
        setState(() {
          currentCryptoDisplayRate[crypto] =
              currentCryptoFiatMap[currentSelectedFiat] ?? '?';
        });
      }
    }
  }

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> currencyList = [];

    for (String currency in currenciesList) {
      DropdownMenuItem<String> dropdownMenuItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      currencyList.add(dropdownMenuItem);
    }

    return DropdownButton<String>(
      value: currentSelectedFiat,
      onChanged: (value) {
        setState(() {
          currentSelectedFiat = value ?? '';
        });
      },
      items: currencyList,
    );
  }

  CupertinoPicker iOSDropdown() {
    List<Text> currencyTextList = [];

    for (String currency in currenciesList) {
      currencyTextList.add(Text(
        currency,
        style: TextStyle(
          color: Colors.white,
        ),
      ));
    }

    return CupertinoPicker(
      itemExtent: 30.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          currentSelectedFiat = currenciesList[selectedIndex];
          updateRates(currentSelectedFiat);
        });
      },
      children: currencyTextList,
    );
  }

  void updateRates(String newDisplayedFiat) {
    //Looping through the Json of all rates and assigning the new rate for the changed fiat to the corresponding crypto in the currencryptoDisplayMap
    for (String crypto in cryptoList) {
      Map<String, String> oneCryptoRateMap = {};
      oneCryptoRateMap = cryptoRateMap[crypto] ?? oneCryptoRateMap;
      currentCryptoDisplayRate[crypto] =
          oneCryptoRateMap[newDisplayedFiat] ?? '?';
    }
  }

  String setCardText(String crypto) {
    //Simply
    String currentRate = currentCryptoDisplayRate[crypto].toString();
    String newRate = '1 $crypto $currentRate $currentSelectedFiat';
    return newRate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getRates();
    setUpRates();
  }

  List<Widget> tickerCardList(List<String> cryptos) {
    List<TickerCard> tickerCardList = [];

    for (String crypto in cryptos) {
      TickerCard tickerCard = TickerCard(setCardText(crypto));
      tickerCardList.add(tickerCard);
    }
    return tickerCardList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...tickerCardList(cryptoList),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: (Platform.isAndroid) ? androidDropdown() : iOSDropdown(),
          ),
        ],
      ),
    );
  }
}

//if (items['asset_id_quote'] == currentSelectedFiat) {
//setState(() {
//updateText(btcRate);
//});
//}
