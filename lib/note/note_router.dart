import 'package:note_app_server/note/handlers/create_handler.dart';
import 'package:note_app_server/note/handlers/delete_handler.dart';
import 'package:note_app_server/note/handlers/update_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class NoteRouter {
  static Handler get noteRoute {
    final auth = Router()
      ..post("/create</|.*>", createNoteHandler())
      ..post("/update</|.*>", updateNoteHandler())
      ..post("/delete</|.*>", deleteNoteHandler());

    return auth;
  }
}
