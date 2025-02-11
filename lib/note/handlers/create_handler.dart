import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../router.dart';
import '../../server_files/globals.dart';
import '../../server_files/server_strings.dart';

Handler createNoteHandler() => (Request req) async {
      Map<String, dynamic> value;

      try {
        value = json.decode(await req.readAsString());
      } catch (_) {
        return Response.badRequest(
            body: response(message: ServerStrings.invalidNote),
            headers: baseHeader);
      }
      if (value['title'] is! String || value['title'] == null) {
        return Response.badRequest(
            body: response(message: ServerStrings.invalidNote),
            headers: baseHeader);
      }

      Map<String, dynamic> decodedToken =
          JwtDecoder.decode((req.context['authDetails'] ?? "") as String);

      final supabase = BaseAppRouter().supaBase;

      try {
        final res = await supabase.rest
            .setAuth(req.context['authDetails'] as String)
            .from("Notes")
            .insert({
          "title": value['title'],
          "content": value['content'],
          "user_id": decodedToken['sub']
        }).select();

        return Response.ok(
          response(
              message: ServerStrings.noteCreatedSuccessful,
              data: res.firstOrNull),
          headers: baseHeader,
        );
      } catch (e) {
        String error = "Something, Happened";
        int code = 404;
        if (e is AuthApiException) {
          error = e.message;
          code = int.parse(e.statusCode ?? "404");
        }
        if (e is PostgrestException) {
          error = e.message;
          code = int.tryParse(e.code ?? "404") ?? 404;
        }
        return Response(code,
            body: response(message: error), headers: baseHeader);
      }
    };
