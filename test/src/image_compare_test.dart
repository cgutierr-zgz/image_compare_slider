import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

void main() {
  group('ImageCompareSlider widget test', () {
    late Widget app;

    setUp(() {
      app = MaterialApp(
        home: ImageCompareSlider(
          imageHeight: 300,
          imageWidth: 500,
          itemOne: const AssetImage('assets/images/render.png'),
          itemTwo: const AssetImage('assets/images/render_oc.png'),
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

    testWidgets('ImageCompareSlider shows two images', (tester) async {
      await tester.pumpWidget(app);
      expect(find.byType(Image), findsNWidgets(2));
    });
    testWidgets('didUpdateWidget updates position when it changes',
        (tester) async {
      final key = UniqueKey();
      const updatedPosition = 0.8;

      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            key: key,
            imageWidth: 100,
            imageHeight: 100,
            itemOne: const AssetImage('assets/images/render.png'),
            itemTwo: const AssetImage('assets/images/render_oc.png'),
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
            imageWidth: 100,
            imageHeight: 100,
            itemOne: const AssetImage('assets/images/render.png'),
            itemTwo: const AssetImage('assets/images/render_oc.png'),
            position: updatedPosition,
          ),
        ),
      );

      // Verify that the new position is set correctly
      final imageCompareSlider =
          tester.widget<ImageCompareSlider>(find.byType(ImageCompareSlider));

      expect(imageCompareSlider.position, updatedPosition);
    });

    testWidgets('Test ImageCompareSlider moves slider', (tester) async {
      late double newPosition;
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            imageHeight: 300,
            imageWidth: 500,
            direction: SliderDirection.rightToLeft,
            itemOne: const AssetImage('assets/images/render.png'),
            itemTwo: const AssetImage('assets/images/render_oc.png'),
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

      expect(newPosition, lessThan(0.5));
    });

    testWidgets('Test ImageCompareSlider moves slider on tap', (tester) async {
      late double newPosition;
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            imageHeight: 300,
            imageWidth: 500,
            direction: SliderDirection.topToBottom,
            itemOne: const AssetImage('assets/images/render.png'),
            itemTwo: const AssetImage('assets/images/render_oc.png'),
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
      await tester.tapAt(Offset.zero);
      await tester.pump();

      expect(newPosition, lessThan(0.5));
    });

    testWidgets('Mouse region moves on hover', (tester) async {
      late double newPosition;
      final app = MaterialApp(
        home: ImageCompareSlider(
          imageHeight: 300,
          imageWidth: 500,
          direction: SliderDirection.bottomToTop,
          itemOne: const AssetImage('assets/images/render.png'),
          itemTwo: const AssetImage('assets/images/render_oc.png'),
          changePositionOnHover: true,
          onPositionChange: (position) {
            newPosition = position;
          },
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
  });
}
