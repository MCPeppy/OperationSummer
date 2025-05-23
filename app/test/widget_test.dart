import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter_test/flutter_test.dart';
import 'package:operation_summer/main.dart';

void main() {
  testWidgets('App shows launch button', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: OperationSummerApp()));
    expect(find.text('Launch Operation Summer'), findsOneWidget);
  });
}
