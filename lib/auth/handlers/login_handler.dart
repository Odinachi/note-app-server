import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../router.dart';
import '../../server_files/globals.dart';
import '../../server_files/server_strings.dart';

Handler loginHandler() => (Request req) async {
      Map<String, dynamic> value;

      try {
        value = json.decode(await req.readAsString());
      } catch (_) {
        return Response.badRequest(
            body: response(message: ServerStrings.provideValidEmailPass),
            headers: baseHeader);
      }

      if (!value.containsKey("email") || !value.containsKey("password")) {
        return Response.badRequest(
            body: response(message: ServerStrings.provideValidEmailPass),
            headers: baseHeader);
      }
      if (value["password"] is! String || value["password"].length < 6) {
        return Response.badRequest(
            body: response(message: ServerStrings.passNotStrong),
            headers: baseHeader);
      }

      if (value["email"] is! String || !emailRegex.hasMatch(value["email"])) {
        return Response.badRequest(
            body: response(message: ServerStrings.invalidEmail),
            headers: baseHeader);
      }
      final supabase = BaseAppRouter().supaBase;
      try {
        final res = await supabase.auth.signInWithPassword(
          password: value["password"],
          email: value["email"],
        );

        return Response.ok(
            response(message: ServerStrings.registerSuccessful, data: {
              "refresh_token": res.session?.refreshToken,
              "access_token": res.session?.accessToken,
              "user": {
                "name": res.session?.user.userMetadata?["name"],
                "email": value["email"]
              }
            }),
            headers: baseHeader);
      } catch (e) {
        String error = "Something, Happened";
        int code = 404;
        if (e is AuthApiException) {
          error = e.message;
          code = int.parse(e.statusCode ?? "404");
        }
        return Response(code,
            body: response(message: error), headers: baseHeader);
      }
    };
