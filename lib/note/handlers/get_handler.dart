import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:supabase/supabase.dart';

import '../../router.dart';
import '../../server_files/globals.dart';
import '../../server_files/server_strings.dart';

Handler getNoteHandler() => (Request req) async {
      final supabase = BaseAppRouter().supaBase;

      try {
        final res = await supabase.rest
            .setAuth(req.context['authDetails'] as String)
            .from("Notes")
            .select()
            .eq('id', req.params['id'] ?? "");

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
          code = int.parse(e.code ?? "404");
        }
        return Response(code,
            body: response(message: error), headers: baseHeader);
      }
    };
