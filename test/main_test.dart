import 'package:devops_asgnmt_group3/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  Widget createWidgetForTest() {
    return const MaterialApp(
      title: 'Assignment - Group3',
      home: IntroPage(
        title: 'Welcome!',
      ),
    );
  }

  Future<void> navigateToThoughtOfDayPage(WidgetTester tester) async {
    await tester.tap(
        find.widgetWithText(RadioListTile<String>, 'Read thought of the day'),
        warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  Future<void> navigateShowSurroundingsPage(WidgetTester tester) async {
    await tester.tap(
        find.widgetWithText(RadioListTile<String>, 'Show my surroundings'),
        warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  testWidgets('PQL Verification', (WidgetTester tester) async {
    bool backgroundCheck = false;
    await tester.pumpWidget(createWidgetForTest());
    expect(find.text('Hey there! tell us how do we call you?'), findsOneWidget);
    if (tester
        .element(find.byType(Container).first)
        .toString()
        .contains("images/background_image.jpeg")) {
      backgroundCheck = true;
    }
    expect(backgroundCheck, true);
    await tester.enterText(
        find.widgetWithText(
            TextField, 'Hey there! tell us how do we call you?'),
        'Pune Pedestrian');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text('Hey! Pune Pedestrian what you want to do today?'),
        findsOneWidget);
    expect(
        find.widgetWithText(RadioListTile<String>, 'Read thought of the day'),
        findsOneWidget);
    expect(find.widgetWithText(RadioListTile<String>, 'Show my surroundings'),
        findsOneWidget);

    await navigateToThoughtOfDayPage(tester);
    expect(find.byType(ThoughtOfDay), findsOneWidget);

    // verify(mockObserver.didPush(route, previousRoute))
    await tester.tap(find.byTooltip("Back"));
    await tester.pumpAndSettle();

    await navigateShowSurroundingsPage(tester);
    expect(find.text('Loading surroundings.....'), findsOneWidget);
  });
}

void printWidgets(WidgetTester tester) {
  Iterable<Widget> c = tester.allWidgets;
  for (var w in c) {
    tester.printToConsole(w.toString());
  }
}
