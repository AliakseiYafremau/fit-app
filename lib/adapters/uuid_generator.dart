import 'package:uuid/uuid.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';

class UuidGenerator extends IdGenerator {
  final Uuid _uuid = const Uuid();

  @override
  String generate() {
    return _uuid.v4();
  }
}