import 'package:uuid/uuid.dart';

import '../../data/plugins/uuid_generator.dart';

class UuidGeneratorImpl extends UuidGenerator {


  const UuidGeneratorImpl();

  @override
  String generateV4() => const Uuid().v4();

}