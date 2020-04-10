
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

enum DbOpName {
  insertMany,
  insertOne,
  find,
  findOneAndUpdate,
  findOneAndDelete,
  count,
  group
}



class DBProxy {

  static const OpName_insertMany = 'insertMany';
  static const OpName_insertOne= 'insertOne';
  static const OpName_find = 'find';
  static const OpName_findOneAndUpdate = 'findOneAndUpdate';
  static const OpName_findOneAndDelete = 'findOneAndDelete';

  static const String dbName = "MyTubeBook";
  static const String domain =
      "ec2-13-124-95-20.ap-northeast-2.compute.amazonaws.com:8080";

  String getUrl(String collectionName, String opName) {
    return "http://$domain/mongoApi/$dbName/$collectionName/${opName.toString()}";
  }

  String toOpName(DbOpName opName) {
    if(opName == DbOpName.find) return 'find';
    if(opName == DbOpName.insertMany) return 'insertMany';
    if(opName == DbOpName.findOneAndUpdate) return 'findOneAndUpdate';
    if(opName == DbOpName.findOneAndDelete) return 'findOneAndDelete';
    if(opName == DbOpName.count) return 'count';
    if(opName == DbOpName.group) return 'group';
    if(opName == DbOpName.insertOne) return 'insertOne';
  }

  Future<String> request(
      String collection, DbOpName opName, Map<String, dynamic> query) async {

    String url = getUrl(collection, toOpName(opName));
    var response = await http.post(url, headers: {HttpHeaders.contentTypeHeader: "application/json"}, body: jsonEncode(query));
   // print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      String log = "request return error:${response.statusCode}";
      print(log);
      throw new Exception("request return error:${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> requestNet(String apiName, Map<String, dynamic> reqPacket) async {
      String url = "http://$domain/$apiName";

      var response = await http.post(url, headers: {HttpHeaders.contentTypeHeader: "application/json"}, body: jsonEncode(reqPacket));
      // print(response.body);
      if (response.statusCode == 200) {

         return jsonDecode(response.body);

      } else {

        String log = "request return error:${response.statusCode}";
        print(log);
        throw new Exception("request return error:${response.statusCode}");
      }
  }

}

abstract class DataManager {

  final DBProxy _proxy = new DBProxy();

  DBProxy get proxy {
    return _proxy;
  }
}
