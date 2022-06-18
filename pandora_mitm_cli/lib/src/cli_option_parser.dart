import 'package:args/args.dart';

class CliOptionParser<T> {
  final String value;

  const CliOptionParser(this.value);

  T call() {
    if (this is CliOptionParser<String>) {
      return _parseString(value) as T;
    } else if (this is CliOptionParser<int>) {
      return _parseInt(value) as T;
    } else if (this is CliOptionParser<double>) {
      return _parseDouble(value) as T;
    } else if (this is CliOptionParser<num>) {
      return _parseNum(value) as T;
    } else if (this is CliOptionParser<Uri>) {
      return _parseUri(value) as T;
    } else if (this is CliOptionParser<List<Object>>) {
      final listValues = value.split(',');
      if (this is CliOptionParser<List<String>>) {
        return listValues.map(_parseString).toList(growable: false) as T;
      } else if (this is CliOptionParser<List<int>>) {
        return listValues.map(_parseInt).toList(growable: false) as T;
      } else if (this is CliOptionParser<List<double>>) {
        return listValues.map(_parseDouble).toList(growable: false) as T;
      } else if (this is CliOptionParser<List<num>>) {
        return listValues.map(_parseNum).toList(growable: false) as T;
      } else if (this is CliOptionParser<List<Uri>>) {
        return listValues.map(_parseUri).toList(growable: false) as T;
      }
    }
    throw UnsupportedError('Unsupported option type $T!');
  }

  String _parseString(String value) => value;

  int _parseInt(String value) =>
      int.tryParse(value) ??
      (throw ArgParserException('Invalid integer "$value"!'));

  double _parseDouble(String value) =>
      double.tryParse(value) ??
      (throw ArgParserException('Invalid decimal number "$value"!'));

  num _parseNum(String value) =>
      num.tryParse(value) ??
      (throw ArgParserException('Invalid number "$value"!'));

  Uri _parseUri(String value) =>
      Uri.tryParse(value) ??
      (throw ArgParserException('Invalid URI "$value"!'));
}
