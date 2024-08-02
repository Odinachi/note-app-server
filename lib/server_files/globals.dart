import 'dart:convert';
import 'dart:io';

String response({String? message, Object? data}) => json.encode({
      "message": message,
      "data": data,
    });

final baseHeader = {HttpHeaders.contentTypeHeader: ContentType.json.mimeType};

final emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
