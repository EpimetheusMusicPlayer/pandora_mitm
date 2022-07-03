import 'dart:convert';
import 'dart:io';

import 'package:iapetus_meta/typing.dart';
import 'package:markdown/markdown.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;

/// An extension of the [InferencePlugin] that serves inference data over HTTP.
///
/// [InferencePlugin] APIs can be accessed through the internally managed
/// [inferencePlugin].
class InferenceServerPlugin<T extends pmplg.InferencePlugin>
    extends WrapperBasePlugin<T>
    with PandoraMitmPluginLoggingMixin, PandoraMitmPluginStateTrackerMixin {
  bool _serve;
  int _port;
  Future<HttpServer>? _httpServerFuture;

  /// Creates a new [InferenceServerPlugin].
  ///
  /// [inferencePluginFactory] is typically an [InferencePlugin] implementation
  /// constructor tear-off, such as [ForegroundInferencePlugin.new] or
  /// [BackgroundInferencePlugin.new].
  InferenceServerPlugin(
    pmplg.InferencePluginFactory<T> inferencePluginFactory, {
    bool serve = true,
    int port = 0,
    Set<String>? apiMethodWhitelist,
    bool stripBoilerplate = false,
  })  : _serve = serve,
        _port = port,
        super(
          inferencePluginFactory(
            apiMethodWhitelist: apiMethodWhitelist,
            stripBoilerplate: stripBoilerplate,
          ),
        );

  @override
  String get name => '${inner.name}_server';

  T get inferencePlugin => inner;

  bool get serve => _serve;

  int get port => _port;

  bool get running => _httpServerFuture != null;

  Future<int> get runningPort =>
      _httpServerFuture!.then((server) => server.port);

  @override
  Future<void> attach() async {
    await super.attach();
    if (_serve) await _startServer();
  }

  @override
  Future<void> detach() async {
    if (_serve) await _stopServer();
    await super.detach();
  }

  Future<void> _startServer() =>
      _httpServerFuture = HttpServer.bind(InternetAddress.anyIPv6, _port)
        ..then((httpServer) {
          httpServer.listen(_handleRequest);
          log.info('Serving inference data on port ${httpServer.port}.');
        });

  Future<void> _stopServer() async {
    await (await _httpServerFuture!).close();
    _httpServerFuture = null;
    log.info('Stopped inference data server.');
  }

  Future<void> changeServe({required bool serve}) async {
    if (serve == _serve) return;
    _serve = serve;
    if (serve) {
      if (attached) await _startServer();
    } else {
      if (running) await _stopServer();
    }
  }

  Future<void> changePort(int newPort) async {
    log.info('Changing inference data server port to $newPort...');
    if (running) {
      await _stopServer();
      _port = newPort;
      await _startServer();
    } else {
      _port = newPort;
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    request.response.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');

    final pathSegments = List.of(request.uri.pathSegments);
    final queryParameters = request.uri.queryParameters;
    final apiMethod = queryParameters['apiMethod'];

    final inferences = await inner.zipInferences();
    if (apiMethod != null && !inferences.containsKey(apiMethod)) {
      request.response
        ..statusCode = HttpStatus.notFound
        ..writeln('No inference has been performed for $apiMethod.');
    } else {
      switch (pathSegments.isEmpty ? null : pathSegments[0].toLowerCase()) {
        case null:
          request.response.headers.contentType = ContentType.html;
          _writeHomepageBody(request.response, inferences);
          break;
        case 'json':
          request.response.headers.contentType = ContentType.json;
          _writeJsonBody(
            request.response,
            inferences: inferences,
            apiMethod: apiMethod,
          );
          break;
        case 'markdown':
          request.response.headers.contentType = _markdownContentType;
          _writeMarkdownBody(
            request.response,
            inferences: inferences,
            apiMethod: apiMethod,
            options: queryParameters,
          );
          break;
        case 'html':
          request.response.headers.contentType = ContentType.html;
          _writeHtmlBody(
            request.response,
            inferences: inferences,
            apiMethod: apiMethod,
            options: queryParameters,
          );
          break;
        default:
          request.response
            ..statusCode = HttpStatus.notFound
            ..writeln(HttpStatus.notFound.toString());
      }
    }

    await request.response.close();
  }

  static void _writeHomepageBody(
      StringSink sink, Map<String, ApiMethodInference> inferences) {
    _writeMarkdownAsWebpage(
      sink,
      'Pandora MITM Inference Server Plugin',
      columnFlexes: const {0: 1},
      '''
# Pandora MITM Inference Server Plugin

## Pandora JSON API methods
| Method ([All](/html?headerLevel=2&showRootLink=true)) | [JSON](/json) | [Markdown](/markdown) | [HTML](/html) |
|:------------------------------------------------------|---------------|-----------------------|---------------|
${inferences.keys.map((apiMethod) => '| [$apiMethod](/html?apiMethod=$apiMethod&headerLevel=2&showRootLink=true) | [JSON](/json?apiMethod=$apiMethod) | [Markdown](/markdown?apiMethod=$apiMethod) | [HTML](/html?apiMethod=$apiMethod) |').join('\n')}

## Plugin API usage

### URL format
`/:output_format`

#### Query parameters
`apiMethod` - The API method to display. If left out, all will be shown.

_Output formats may specify their own additional query parameters._

### Output formats
#### [JSON](/json)

#### [Markdown](/markdown)
##### Query parameters
`headerLevel` - The header level to use for the API method names.
                Defaults to 1 when showing a single method, and 2 when showing
                all methods.
`showRootLink` - Displays a link to the root of the inference server.
                 Defaults to "false".


#### [HTML](/html)
##### Query parameters
All the query parameters from Markdown are supported.''',
    );
  }

  static void _writeJsonBody(
    StringSink sink, {
    required Map<String, ApiMethodInference> inferences,
    String? apiMethod,
  }) {
    sink.writeln(
      const JsonEncoder.withIndent('  ').convert(
        apiMethod == null
            ? inferences.values
                .map((inference) => inference.toJson())
                .toList(growable: false)
            : inferences[apiMethod]!.toJson(),
      ),
    );
  }

  static void _writeMarkdownBody(
    StringSink sink, {
    required Map<String, ApiMethodInference> inferences,
    String? apiMethod,
    Map<String, String> options = const {},
  }) {
    void writeHeader(int level, String text) {
      for (var i = 0; i < level; ++i) {
        sink.write('#');
      }
      sink.write(' ');
      sink.writeln(text);
      sink.writeln();
    }

    void writeItalicised(String text) {
      sink.write('_');
      sink.write(text);
      sink.writeln('_\n');
    }

    void writeInference(
      ApiMethodInference inference, [
      int headerLevel = 2,
    ]) {
      void writeEntry(NestedObjectValueTypeEntry entry) {
        writeHeader(headerLevel + 2, entry.name);
        switch (entry.parentCategory) {
          case NestedObjectValueTypeParentCategory.root:
          case NestedObjectValueTypeParentCategory.object:
            writeItalicised('Object');
            break;
          case NestedObjectValueTypeParentCategory.map:
            writeItalicised('Map');
            break;
          case NestedObjectValueTypeParentCategory.list:
            writeItalicised('List');
            break;
        }
        sink.writeln('| Field | Type | Optional | Default |');
        sink.writeln('| :---- | :--- | :------- | :------ |');
        for (final valueType in entry.valueType.fieldValueTypes.entries) {
          sink.write('| ');
          sink.write(valueType.key.replaceAll('<', '\\<'));
          sink.write(' | ');
          sink.write(valueType.value.name.replaceAll('<', '\\<'));
          sink.write(' | ');
          sink.write(valueType.value.optional ? 'Yes' : 'No');
          sink.write(' | ');
          if (valueType.value.defaultValue != null) {
            sink.write(valueType.value.defaultValue);
          }
          sink.writeln(' |');
        }
        sink.writeln();
      }

      writeHeader(headerLevel, inference.method);
      if (inference.requestValueTypeEntries != null) {
        writeHeader(headerLevel + 1, 'Request');
        inference.requestValueTypeEntries!.forEach(writeEntry);
      }
      if (inference.responseValueTypeEntries != null) {
        writeHeader(headerLevel + 1, 'Response');
        inference.responseValueTypeEntries!.forEach(writeEntry);
      }
    }

    final inferenceHeaderLevel = (options.containsKey('headerLevel')
            ? int?.tryParse(options['headerLevel']!)
            : null) ??
        (apiMethod == null ? 2 : 1);

    final showRootLink = options['showRootLink'] == 'true';
    if (showRootLink) {
      writeHeader(inferenceHeaderLevel + 2, '[\u25C0 See all](/)');
    }

    if (apiMethod == null) {
      writeHeader(
          inferenceHeaderLevel - 1, 'Pandora JSON API message inferences');
      sink.write('_');
      sink.write(inferences.length);
      sink.write(' methods inferred.');
      sink.writeln('_\n');

      for (final inference in inferences.values) {
        writeInference(inference, inferenceHeaderLevel);
      }
    } else {
      writeInference(inferences[apiMethod]!, inferenceHeaderLevel);
    }
  }

  static void _writeHtmlBody(
    StringSink sink, {
    required Map<String, ApiMethodInference> inferences,
    String? apiMethod,
    Map<String, String> options = const {},
  }) {
    final markdownBuffer = StringBuffer();
    _writeMarkdownBody(
      markdownBuffer,
      inferences: inferences,
      apiMethod: apiMethod,
      options: options,
    );
    _writeMarkdownAsWebpage(
      sink,
      '${apiMethod ?? 'Pandora JSON API message'} inferences',
      columnFlexes: const {0: 0.25, 1: 0.75},
      markdownBuffer.toString(),
    );
  }

  static void _writeMarkdownAsWebpage(
    StringSink sink,
    String title,
    String markdown, {
    Map<int, double> columnFlexes = const {},
  }) {
    sink.write(
      '''
<!DOCTYPE html>
<html>
<head>
    <title>''',
    );
    sink.write(title);
    sink.write(
      '''
</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.1.0/github-markdown.min.css">
    <style>
	      .markdown-body {
		        box-sizing: border-box;
	          min-width: 200px;
		        max-width: 1225px;
		        margin: 0 auto;
		        padding: 45px;
	      }

	      @media (max-width: 767px) {
		        .markdown-body {
		        	padding: 15px;
		         }
	      }''',
    );
    columnFlexes.entries
        .map(
          (entry) =>
              'td:nth-child(${entry.key + 1})  { width: ${entry.value * 100}% }',
        )
        .forEach(sink.writeln);
    sink.write(
      '''
    </style>
</head>
<body class="markdown-body">
    <article>
''',
    );
    sink.writeln(
      markdownToHtml(markdown, blockSyntaxes: const [TableSyntax()]),
    );
    sink.write(
      '''
    </article>
</body>
</head>
</html>
''',
    );
  }
}

final _markdownContentType = ContentType('text', 'markdown', charset: 'utf-8');
