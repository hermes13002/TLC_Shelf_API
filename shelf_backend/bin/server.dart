import 'package:shelf_backend/server/config/env.dart';
import 'package:shelf_backend/server/server.dart';

/// Main entry point for the server
void main() async {
  final env = EnvConfig(); // load .env here
  print('Groq Key length loaded: ${env.groqApiKey.length}');
  
  // Create and start the server
  final server = Server();
  await server.start();
}