import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_vn/main.dart';

void main() {
  testWidgets('SafeVN app smoke test and title rendering', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SafeVnApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify key UI text is present
    expect(find.text('SafeVN Survival'), findsOneWidget);
    expect(find.text('I AM IN DANGER'), findsOneWidget);
    expect(find.text('112'), findsOneWidget);
    expect(find.text('114'), findsOneWidget);
    expect(find.text('115'), findsOneWidget);
  });
}
