import 'package:note_app_server/note/handlers/create_handler.dart';
import 'package:note_app_server/note/handlers/delete_handler.dart';
import 'package:note_app_server/note/handlers/fetch_handler.dart';
import 'package:note_app_server/note/handlers/update_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handlers/get_handler.dart';

class NoteRouter {
  static Handler get noteRoute {
    final auth = Router()
      ..post("/</|.*>", createNoteHandler())
      ..get("/</|.*>", getNoteHandler())
      ..get("/fetch</|.*>", fetchNoteHandler())
      ..patch("/<id>", updateNoteHandler())
      ..delete("/<id>", deleteNoteHandler());

    return auth;
  }
}
