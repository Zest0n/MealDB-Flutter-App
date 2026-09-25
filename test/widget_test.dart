import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_ui/main.dart';

void main() {
  testWidgets('MealDBApp initial build test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MealDBApp(isFirebaseReady: false));

    // Verify home screen renders
    expect(find.byType(MealDBApp), findsOneWidget);
  });
}