import 'dart:io';

import 'package:note_app_server/router.dart';
import 'package:note_app_server/server_files/middlewares.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

void main() async {
  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(handleCors())
      .addMiddleware(logRequests())
      .addMiddleware(handleAuth())
      .addMiddleware((checkAuthorization()))
      .addHandler(BaseAppRouter().router..get('/', _rootHandler));

  final server = await serve(handler, InternetAddress.anyIPv4,
      int.parse(Platform.environment['PORT'] ?? '8080'));
  print('Serving at http://${server.address.host}:${server.port}');
}

Response _rootHandler(Request req) {
  return Response.ok('Demo Note App Server\n');
}
