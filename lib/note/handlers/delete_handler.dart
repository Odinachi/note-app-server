import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:supabase/supabase.dart';

import '../../router.dart';
import '../../server_files/globals.dart';
import '../../server_files/server_strings.dart';

Handler deleteNoteHandler() => (Request req) async {
      final id = int.tryParse(req.params['id'] ?? "");
      if (req.params['id'] == null && id != null) {
        return Response.badRequest(
            body: response(message: ServerStrings.invalidId),
            headers: baseHeader);
      }
      final supabase = BaseAppRouter().supaBase;

      try {
        await supabase.rest
            .setAuth(req.context['authDetails'] as String)
            .from("Notes")
            .delete()
            .eq('id', id!);

        return Response.ok(
            response(
              message: ServerStrings.deleteSuccessful,
            ),
            headers: baseHeader);
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
