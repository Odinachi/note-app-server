import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:note_app_server/auth/auth_router.dart';
import 'package:note_app_server/note/note_router.dart';
import 'package:note_app_server/server_files/server_strings.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:supabase/supabase.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..mount('/auth', AuthRouter.authRoute)
  ..mount('/note', NoteRouter.noteRoute);

Response _rootHandler(Request req) {
  return Response.ok('Demo Note App Server\n');
}

void main() async {
  //Initialize our env
  final env = DotEnv(includePlatformEnvironment: true)..load();
  //Initialize supabase
  final supaBase = SupabaseClient(
    env.getOrElse(ServerStrings.supabaseURLKey, () => ""),
    env.getOrElse(ServerStrings.supabasePAnonKey, () => ""),
  );

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  final server = await serve(handler, InternetAddress.anyIPv4,
      int.parse(Platform.environment['PORT'] ?? '8080'));
  print('Serving at http://${server.address.host}:${server.port}');
}
