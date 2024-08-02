import 'package:note_app_server/server_files/server_strings.dart';
import 'package:shelf/shelf.dart';

import 'globals.dart';

Middleware handleAuth() => (Handler innerHandler) => (Request request) async {
      final authHeader = request.headers['authorization'];
      String? token, jwt;
      if (authHeader != null && authHeader.startsWith("Bearer ")) {
        token = authHeader.substring(7);
        jwt = token;
      }
      final updatedRequest = request.change(context: {"authDetails": jwt});
      return await innerHandler(updatedRequest);
    };

Middleware checkAuthorization() => createMiddleware(
      requestHandler: (Request request) {
        if (request.url.path.isEmpty || request.url.path == "/") {
          return null;
        } else if (request.context['authDetails'] == null &&
            ((!request.url.path.contains("login") &&
                !request.url.path.contains("register")))) {
          return Response.unauthorized(
              response(message: ServerStrings.unauthorized),
              headers: baseHeader);
        }
        return null;
      },
    );

Middleware handleCors() {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
  };

  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: corsHeaders);
      }
      return null;
    },
    responseHandler: (Response response) {
      return response.change(headers: corsHeaders);
    },
  );
}
