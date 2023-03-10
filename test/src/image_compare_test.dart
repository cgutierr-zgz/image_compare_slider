import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

void main() {
  group('ImageCompareSlider widget test', () {
    late Widget app;

    setUp(() {
      app = MaterialApp(
        home: ImageCompareSlider(
          itemOne: Image.asset('assets/images/render.png'),
          itemTwo: Image.asset('assets/images/render_oc.png'),
        ),
      );
    });

    testWidgets('Test ImageCompareSlider initialization', (tester) async {
      await tester.pumpWidget(app);

      final imageCompareSlider =
          tester.widget<ImageCompareSlider>(find.byType(ImageCompareSlider));

      expect(imageCompareSlider.position, 0.5);
      expect(imageCompareSlider.portrait, false);
      expect(imageCompareSlider.direction, SliderDirection.leftToRight);
      expect(imageCompareSlider.dividerWidth, 2.5);
      expect(imageCompareSlider.hideHandle, false);
      expect(imageCompareSlider.onPositionChange, null);
      expect(imageCompareSlider.dividerColor, Colors.white);
    });

    testWidgets(
        'didUpdateWidget/shouldRepaint updates position when it changes',
        (tester) async {
      final key = UniqueKey();
      const updatedPosition = 0.8;
      const updatedColor = Colors.red;
      const updatedStrokeWidth = 5.0;
      const updatedPortrait = SliderDirection.topToBottom;
      const updatedHideHandle = true;
      const updatedHandlePosition = 0.2;
      const updatedHandleSize = Size(10, 10);
      const updatedFillHandle = true;

      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            key: key,
            itemOne: Image.asset('assets/images/render.png'),
            itemTwo: Image.asset('assets/images/render_oc.png'),
          ),
        ),
      );

      // Move the slider to the left
      await tester.drag(find.byType(ImageCompareSlider), const Offset(-50, 0));
      await tester.pump();

      // Update the widget with a new position
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            key: key,
            itemOne: Image.asset('assets/images/render.png'),
            itemTwo: Image.asset('assets/images/render_oc.png'),
            position: updatedPosition,
            dividerColor: updatedColor,
            dividerWidth: updatedStrokeWidth,
            direction: updatedPortrait,
            hideHandle: updatedHideHandle,
            handlePosition: updatedHandlePosition,
            handleSize: updatedHandleSize,
            fillHandle: updatedFillHandle,
          ),
        ),
      );

      // Verify that the new values are set
      final imageCompareSlider =
          tester.widget<ImageCompareSlider>(find.byType(ImageCompareSlider));

      expect(imageCompareSlider.position, updatedPosition);
      expect(imageCompareSlider.dividerColor, updatedColor);
      expect(imageCompareSlider.dividerWidth, updatedStrokeWidth);
      expect(imageCompareSlider.direction, updatedPortrait);
      expect(imageCompareSlider.hideHandle, updatedHideHandle);
      expect(imageCompareSlider.handlePosition, updatedHandlePosition);
      expect(imageCompareSlider.handleSize, updatedHandleSize);
      expect(imageCompareSlider.fillHandle, updatedFillHandle);
    });

    testWidgets('Test ImageCompareSlider moves slider', (tester) async {
      double? newPosition;
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            direction: SliderDirection.rightToLeft,
            itemOne: Image.asset('assets/images/render.png'),
            itemTwo: Image.asset('assets/images/render_oc.png'),
            onPositionChange: (position) {
              newPosition = position;
            },
          ),
        ),
      );

      final imageCompareSlider =
          tester.widget<ImageCompareSlider>(find.byType(ImageCompareSlider));

      expect(imageCompareSlider.position, 0.5);

      // Move the slider to the left
      await tester.drag(find.byType(ImageCompareSlider), const Offset(-50, 0));
      await tester.pump();

      await tester.drag(find.byType(ImageCompareSlider), const Offset(-25, 0));
      await tester.drag(find.byType(ImageCompareSlider), const Offset(25, 0));

      // new position is not the same as the initial position
      expect(newPosition, isNot(0.5));
    });

    testWidgets('Test ImageCompareSlider moves slider on tap', (tester) async {
      late double newPosition;
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            direction: SliderDirection.topToBottom,
            itemOne: Image.asset('assets/images/render.png'),
            itemTwo: Image.asset('assets/images/render_oc.png'),
            onPositionChange: (position) {
              newPosition = position;
            },
          ),
        ),
      );

      final imageCompareSlider =
          tester.widget<ImageCompareSlider>(find.byType(ImageCompareSlider));

      expect(imageCompareSlider.position, 0.5);

      // Move the Slider when taps on the left
      await tester.tapAt(const Offset(10, 0));
      await tester.pump();

      expect(newPosition, isNot(0.5));
    });

    testWidgets('Mouse region moves on hover and follows position',
        (tester) async {
      late double newPosition;
      final app = MaterialApp(
        home: ImageCompareSlider(
          direction: SliderDirection.bottomToTop,
          itemOne: Image.asset('assets/images/render.png'),
          itemTwo: Image.asset('assets/images/render_oc.png'),
          changePositionOnHover: true,
          onPositionChange: (position) {
            newPosition = position;
          },
          handleFollowsPosition: true,
        ),
      );

      await tester.pumpWidget(app);

      // Move the mouse around the slider
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(const Offset(100, 100));
      await tester.pumpAndSettle();

      // New position is not equal to the initial position
      expect(newPosition, isNot(0.5));
    });

    testWidgets('Mouse region moves on hover and follows position',
        (tester) async {
      late double newPosition;
      final app = MaterialApp(
        home: ImageCompareSlider(
          itemOne: Image.asset('assets/images/render.png'),
          itemTwo: Image.asset('assets/images/render_oc.png'),
          changePositionOnHover: true,
          onPositionChange: (position) {
            newPosition = position;
          },
          handleFollowsPosition: true,
        ),
      );

      await tester.pumpWidget(app);

      // Move the mouse around the slider
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(const Offset(100, 100));
      await tester.pumpAndSettle();

      // New position is not equal to the initial position
      expect(newPosition, isNot(0.5));
    });

    testWidgets('Test Wrapper ', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            direction: SliderDirection.bottomToTop,
            itemOne: Image.asset('assets/images/render.png'),
            itemTwo: Image.asset('assets/images/render_oc.png'),
            itemOneBuilder: (child, context) => ColoredBox(
              color: Colors.blue,
              child: child,
            ),
            itemTwoBuilder: (child, context) => ColoredBox(
              color: Colors.blue,
              child: child,
            ),
          ),
        ),
      );

      expect(find.byType(ColoredBox), findsNWidgets(3));
    });
  });
}
