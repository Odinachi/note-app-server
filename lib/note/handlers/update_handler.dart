import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:supabase/supabase.dart';

import '../../router.dart';
import '../../server_files/globals.dart';
import '../../server_files/server_strings.dart';

Handler updateNoteHandler() => (Request req) async {
      final id = int.tryParse(req.params['id'] ?? "");
      if (req.params['id'] == null && id != null) {
        return Response.badRequest(
            body: response(message: ServerStrings.invalidId),
            headers: baseHeader);
      }

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
        final data = await supabase.rest
            .setAuth(req.context['authDetails'] as String)
            .from("Notes")
            .update({
          if (value['title'] != null) "title": value['title'],
          if (value['content'] != null) "content": value['content'],
        }).match({'id': id!}).select();

        if (data.isNotEmpty) {
          return Response.ok(
              response(
                  message: ServerStrings.updateSuccessful,
                  data: {"user": data.firstOrNull}),
              headers: baseHeader);
        } else {
          return Response.notFound(response(message: "Note not found"),
              headers: baseHeader);
        }
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
