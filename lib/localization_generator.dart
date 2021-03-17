import 'dart:io';
import 'dart:convert';
import 'package:translator/translator.dart';
import 'input/utils.dart';

void generate() async{
  var path = Directory.current.path;

  var inputPath = path + '\\lib\\input\\' + fileName;

  if(File(inputPath).existsSync()){
    Map<String, dynamic> decoded = json.decode(await File(inputPath).readAsString());

    for(var locale in to){
      var file = File(path + '\\files\\app_' + locale + '.arb');

      file.writeAsStringSync('{\n  "@@locale": "$locale",\n', mode: FileMode.write);

      var length = decoded.keys.length;
      var count = 0;

      for(var key in decoded.keys){
        count++;
        var content = '\n  "$key": "'
          '${locale == from ? decoded[key] : await getTranslation(decoded[key], locale)}",\n  "@$key": {}';

        if(length != count) content += ',';

        content += '\n';

        file.writeAsStringSync(content, mode: FileMode.append);
      }

      file.writeAsStringSync('}', mode: FileMode.append);
    }
  }
}

Future<String> getTranslation(String text, String to) async {
  return (await text.translate(to: to, from: from)).text;
}