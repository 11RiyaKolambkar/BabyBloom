import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('BabyBloomApp basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BabyBloomApp(initialLoggedIn: false));
    expect(find.byType(BabyBloomApp), findsOneWidget);
  });
}
