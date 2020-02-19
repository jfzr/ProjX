import 'dart:convert';

import 'package:http/http.dart';
import 'package:projx_v01/report.dart';

class HttpService {
  final String baseURL = "192.168.200.148:8080";
  final String endPointPostR = "/report/add/";
  final String endPointGetRs = "/report/reports/";
  final String userId = "1";

  Map<String, String> headers = {"Content-type": "application/json"};

  Future<Report> postReport(Report payload) async {

    Response res = await post(new Uri.http(baseURL,  endPointPostR + userId), headers: headers, body: jsonEncode(payload.toJson()));

    if (res.statusCode == 200) {
          print("OK ++++++ " + res.body);
          return Report.fromJson(jsonDecode(res.body));
    } else {
      throw "Can't post report. Error: " +  res.statusCode.toString();
    }

    //return res;
  }

  Future<List<Report>> getReportsByCoor(double lat, double lon) async{
    print('Ready to get reports');
    String uncodedURL = endPointGetRs + "$lat/$lon";
    Response res = await get(Uri.http(baseURL, uncodedURL));
    if (res.statusCode == 200) {
      print("OK ++++++ " + res.body);
      List<dynamic> body = jsonDecode(res.body);
      List<Report> reports = body.map((dynamic item) => Report.fromJson(item)).toList();
      return reports;
    } else {
      print('ERROR: ${res.statusCode}');
      throw "Can't post report. Error: " +  res.statusCode.toString();
    }

  }

}