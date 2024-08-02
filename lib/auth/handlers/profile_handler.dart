import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../router.dart';
import '../../server_files/globals.dart';
import '../../server_files/server_strings.dart';

Handler profileHandler() => (Request req) async {
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode((req.context['authDetails'] ?? "") as String);
      final supabase = BaseAppRouter().supaBase;

      try {
        final data = await supabase.rest
            .setAuth(req.context['authDetails'] as String)
            .from("Users")
            .select('name, user_id, email')
            .eq('user_id', decodedToken['sub']);
        if (data.isNotEmpty) {
          return Response.ok(
              response(
                  message: ServerStrings.profileSuccessful,
                  data: {"user": data.firstOrNull}),
              headers: baseHeader);
        } else {
          return Response.notFound(response(message: "user not found"),
              headers: baseHeader);
        }
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
