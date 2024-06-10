import 'package:financeOFF/objectbox.dart';
import 'package:flutter_test/flutter_test.dart';

import '../database_test.dart';
import '../objectbox_erase.dart';
import 'v1_populate.dart';

void main() async {
  group("Sync V1: Full backup and recover cycle", () {
    const int dummyTransactionCount = 100;

    final String customDirectory = objectboxTestRootDir().path;

    // Populate fake data
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      await ObjectBox.initialize(
        customDirectory: customDirectory,
        subdirectory: "sync/v1",
      );

      await populateDummyData(dummyTransactionCount);
    });


    tearDownAll(() async {
      await testCleanupObject(
        instance: ObjectBox(),
        directory: ObjectBox.appDataDirectory,
        cleanUp: true,
      );
    });
  });
}
