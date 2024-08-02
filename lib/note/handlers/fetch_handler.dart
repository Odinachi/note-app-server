import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../router.dart';
import '../../server_files/globals.dart';
import '../../server_files/server_strings.dart';

Handler fetchNoteHandler() => (Request req) async {
      Map<String, dynamic> value;

      try {
        value = json.decode(await req.readAsString());
      } catch (_) {
        return Response.badRequest(
            body: response(message: ServerStrings.invalidNote),
            headers: baseHeader);
      }
      final supabase = BaseAppRouter().supaBase;

      try {
        final res = await supabase.rest
            .setAuth(req.context['authDetails'] as String)
            .from("Notes")
            .select()
            .eq('user_id', value['user_id'] ?? "");

        return Response.ok(
          response(message: ServerStrings.noteCreatedSuccessful, data: res),
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
          code = int.parse(e.code ?? "404");
        }
        return Response(code,
            body: response(message: error), headers: baseHeader);
      }
    };
