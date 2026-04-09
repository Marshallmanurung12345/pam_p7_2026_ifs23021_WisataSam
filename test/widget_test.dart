import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23021/app.dart';

void main() {
  testWidgets('app bootstrap menampilkan home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DelcomPlantsApp());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    expect(find.textContaining('Delcom Plants'), findsOneWidget);
  });
}
