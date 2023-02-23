import 'package:devops_asgnmt_group3/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetForTest() {
    return const MaterialApp(
      title: 'Assignment - Group3',
      home: IntroPage(
        title: 'Welcome!',
      ),
    );
  }

  testWidgets('Intro Page Verification', (WidgetTester tester) async {
    bool backgroundCheck = false;
    await tester.pumpWidget(createWidgetForTest());
    expect(find.text('Hey there! tell us how do we call you?'), findsOneWidget);
    // Iterable<Widget> c = tester.allWidgets;
    // for (var w in c) {
    //   tester.printToConsole(w.toString());
    //   if (w.toString().startsWith('Container')) {
    //     if (w.toString().contains("images/background_image.jpeg")) {
    //       backgroundCheck = true;
    //       break;
    //     }
    //     // tester.printToConsole(w.toString());
    //     // tester.printToConsole("Printing Hashcode...");
    //     // tester.printToConsole(w.hashCode.toString());
    //   }
    // }flutter test --coverage
    // expect(backgroundCheck, true);
    if (tester
        .element(find.byType(Container).first)
        .toString()
        .contains("images/background_image.jpeg")) {
      backgroundCheck = true;
    }
    expect(backgroundCheck, true);
    //  await tester.enterText(
    // expect(
    //     find.widgetWithText(
    //         TextField, 'Hey there! tell us how do we call you?'),
    //     findsOneWidget);
    //text('Hey there! tell us how do we call you?'), 'Pune Pedestrian');
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
  });

  // TestTextInput();
}

void printWidgets(WidgetTester tester) {
  Iterable<Widget> c = tester.allWidgets;
  for (var w in c) {
    tester.printToConsole(w.toString());
  }
}
