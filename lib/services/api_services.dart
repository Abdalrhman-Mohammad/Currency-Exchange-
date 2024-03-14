import 'package:currency_exchange/services/firestore_services.dart';
import 'package:dio/dio.dart';

class ApiServices {
  ApiServices._();
  static final instance = ApiServices._();
  String? lastDate;
  Map<String, double> currunciesWithValues = {};
  String baseCurrency = "ILS";
  // List<String>? nameOfCurruncies;
  final Dio _dio = Dio();
  final _headers = {
    'apikey': 'cur_live_OIW4fTvxzLrovojhxNWbBtxQLt3Cqqk5BNEkSJ7K'
  };
  String monthName(int month) {
    List<String> names =
        "January,February,March,April,May,June,July,August,September,October,November,December"
            .split(",");
    return names[month - 1].substring(0, 3) + " ";
  }

  final firestoreService = FirestoreService.instance;
  Future<void> getData() async {
    try {
      var response = await _dio.get(
        'https://api.currencyapi.com/v3/latest?base_currency=$baseCurrency',
        options: Options(
          method: 'GET',
          headers: _headers,
        ),
      );

      if (response.statusCode == 200) {
        Map<String, double> mp = {};
        final curruncies = response.data['data'] as Map<String, dynamic>;
        curruncies.forEach(
          (key, value) {
            String currency;
            double val;
            currency = value['code'] as String;
            val = value['value'] * 1.0;
            mp[currency] = val;
          },
        );
        firestoreService.setData(path: "currency/currencies/", data: mp);
        // currunciesWithValues = mp;
        // if (nameOfCurruncies == null) {
        //   nameOfCurruncies = mp.keys.toList();
        //   nameOfCurruncies!.sort(
        //     (e1, e2) {
        //       if (e1.compareTo(e2) > 0) return 1;
        //       return -1;
        //     },
        //   );
        // }
        DateTime dt = DateTime.now();
        firestoreService.setData(
          path: "currency/time_and_date/",
          data: {
            "year": dt.year,
            "month": dt.month,
            "day": dt.day,
            "hour": dt.hour,
            "minute": dt.hour,
          },
        );

        lastDate =
            monthName(dt.month) + dt.day.toString() + ", " + dt.year.toString();
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> checkData() async {
    final timeAndDate = await firestoreService.getDocument(
      path: "currency/time_and_date/",
      builder: (data, documentID) {
        return data;
      },
    );
    DateTime lastUpdate = DateTime(
      timeAndDate['year'],
      timeAndDate['month'],
      timeAndDate['day'],
      timeAndDate['hour'],
      timeAndDate['minute'],
    );
    lastDate = monthName(lastUpdate.month) +
        lastUpdate.day.toString() +
        ", " +
        lastUpdate.year.toString();

    final diffDate = DateTime.now().difference(lastUpdate);
    if (diffDate.inDays > 0) {
      getData();
    } else {
      int minutes = diffDate.inHours * 60 + diffDate.inMinutes;
      if (minutes > 2 * 60 + 0.5 * 60) {
        getData();
      }
    }
    try {
      currunciesWithValues = await firestoreService.getDocument(
        path: "currency/currencies/",
        builder: (data, documentID) {
          final operation = data.map((key, value) {
            return MapEntry(key, value * 1.0 as double);
          });
          return operation;
        },
      );
    } catch (e) {
      print(e.toString() + "--------------------");
    }
  }
}
