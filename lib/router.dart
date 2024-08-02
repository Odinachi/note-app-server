import 'package:dotenv/dotenv.dart';
import 'package:note_app_server/server_files/server_strings.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:supabase/supabase.dart';

import 'auth/auth_router.dart';
import 'note/note_router.dart';

class BaseAppRouter {
  // The single instance of BaseAppRouter
  static final BaseAppRouter _instance = BaseAppRouter._createInstance();

  late final SupabaseClient supaBase;

  // Configure routes.
  final Router router = Router()
    ..mount('/auth', AuthRouter.authRoute)
    ..mount('/note', NoteRouter.noteRoute);

  BaseAppRouter._createInstance() {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    supaBase = SupabaseClient(
        env.getOrElse(ServerStrings.supabaseURLKey, () => ""),
        env.getOrElse(ServerStrings.supabasePAnonKey, () => ""),
        authOptions: AuthClientOptions(authFlowType: AuthFlowType.implicit));
  }

  factory BaseAppRouter() => _instance;
}
