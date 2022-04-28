import 'network.dart';
import 'package:bitcoin_ticker/coin_data.dart';

const apiKey = '41067597-085F-405E-A190-F3D141BEA968';
const urlBase = 'https://rest.coinapi.io/v1/exchangerate/';

class CoinModel {
  Future<double> getRatePair(String crypto, String fiat) async {
    String url = '$urlBase$crypto/$fiat?apikey=$apiKey';
    NetworkHelper networkHelper = NetworkHelper(url);

    var response = await networkHelper.getData();
    return response['rate'];
  }

  Future<List<dynamic>> getRate(String crypto) async {
    String url = '$urlBase$crypto?apikey=$apiKey';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);

    var response = await networkHelper.getData();
    return response['rates'];
  }

  Future<Map<String, Map<String, String>>> getRateList() async {
    Map<String, Map<String, String>> cryptoRateMap = {};

    for (String crypto in cryptoList) {
      String url = '$urlBase$crypto?apikey=$apiKey';
      print(url);
      NetworkHelper networkHelper = NetworkHelper(url);

      var response = await networkHelper.getData();
      response['rates'];
      var rateJson = response['rates'];
      //Initializing Map of rates specific crypto
      Map<String, String> coinRateMap = {};

      //Going through the CoinApi Json to fetch the list of rates and match it with the currency List creating a Map
      for (dynamic items in rateJson) {
        if (currenciesList.contains(items['asset_id_quote'])) {
          double btc = items['rate'];
          String coinRate = btc.toStringAsFixed(2);
          coinRateMap[items['asset_id_quote']] = coinRate;
        }
      }
      cryptoRateMap[crypto] = coinRateMap;
    }
    return cryptoRateMap;
  }
}
