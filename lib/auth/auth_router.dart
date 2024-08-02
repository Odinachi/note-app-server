import 'package:note_app_server/auth/handlers/profile_handler.dart';
import 'package:note_app_server/auth/handlers/register_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handlers/login_handler.dart';

class AuthRouter {
  static Handler get authRoute {
    final auth = Router()
      ..post("/login</|.*>", loginHandler())
      ..post("/register</|.*>", registerHandler())
      ..get("/profile", profileHandler());

    return auth;
  }
}
