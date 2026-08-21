import 'package:flutter_test/flutter_test.dart';
import 'package:handsfree_messenger/app.dart';

void main() {
  testWidgets('App should render', (WidgetTester tester) async {
    await tester.pumpWidget(const HandsFreeApp());
    // App renders without crashing
    expect(find.byType(HandsFreeApp), findsOneWidget);
  });
}
