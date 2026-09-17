import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_ayuda/core/services/api_service.dart';
import 'package:red_ayuda/presentation/screens/login_screen.dart';
import 'package:red_ayuda/presentation/widgets/sos_button.dart';

void main() {
  testWidgets('SosButton renders correctly and displays label', (WidgetTester tester) async {
    bool triggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SosButton(
              onTriggered: () {
                triggered = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('SOS'), findsOneWidget);
    expect(find.text('MANTÉN PRESIONADO PARA PEDIR AYUDA'), findsOneWidget);
    expect(triggered, false);
  });

  testWidgets('LoginScreen renders and displays brand text', (WidgetTester tester) async {
    final apiService = ApiService();
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(apiService: apiService),
      ),
    );

    expect(find.text('RED AYUDA'), findsOneWidget);
  });
}
