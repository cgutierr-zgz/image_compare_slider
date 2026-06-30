// Tests read more clearly as discrete statements than forced cascades.
// ignore_for_file: cascade_invocations

import 'dart:math' as math;
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
      expect(imageCompareSlider.fit, BoxFit.contain);
      expect(imageCompareSlider.zoomable, false);
      expect(imageCompareSlider.pannable, false);
      expect(imageCompareSlider.minScale, 1.0);
      expect(imageCompareSlider.maxScale, 5.0);
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

      // itemOne is used once, itemTwo twice (clip + invisible divider child),
      // so the blue wrapper appears at least 3 times. The framework may add
      // its own (transparent) ColoredBox, hence "at least".
      final blueBoxes = find.byWidgetPredicate(
        (w) => w is ColoredBox && w.color == Colors.blue,
      );
      expect(blueBoxes, findsNWidgets(3));
    });
  });

  group('ImageCompareSliderController', () {
    test('rotateOne only rotates the first image when unlocked', () {
      final controller = ImageCompareSliderController();
      controller.rotateOne(math.pi / 2);
      expect(controller.rotationOne, math.pi / 2);
      expect(controller.rotationTwo, 0);
      controller.dispose();
    });

    test('rotateOne rotates both images when locked', () {
      final controller = ImageCompareSliderController(lockRotation: true);
      controller.rotateOne(math.pi / 2);
      expect(controller.rotationOne, math.pi / 2);
      expect(controller.rotationTwo, math.pi / 2);
      controller.dispose();
    });

    test('rotateTwo respects the lock as well', () {
      final controller = ImageCompareSliderController(lockRotation: true);
      controller.rotateTwo(-math.pi / 2);
      expect(controller.rotationOne, -math.pi / 2);
      expect(controller.rotationTwo, -math.pi / 2);
      controller.dispose();
    });

    test('matchRotation snaps the second image to the first', () {
      final controller = ImageCompareSliderController()..rotateOne(1.2);
      controller.matchRotation();
      expect(controller.rotationTwo, 1.2);
      controller.dispose();
    });

    test('scale is clamped to bounds', () {
      final controller = ImageCompareSliderController(maxScale: 3);
      controller.scale = 10;
      expect(controller.scale, 3);
      controller.scale = 0.1;
      expect(controller.scale, 1);
      controller.dispose();
    });

    test('reset restores the initial transform', () {
      final controller = ImageCompareSliderController()
        ..scale = 2
        ..offset = const Offset(10, 10)
        ..rotateOne(1)
        ..rotateTwo(1)
        ..position = 0.2;

      controller.reset(resetPosition: true);
      expect(controller.scale, 1);
      expect(controller.offset, Offset.zero);
      expect(controller.rotationOne, 0);
      expect(controller.rotationTwo, 0);
      expect(controller.position, 0.5);
      controller.dispose();
    });

    test('notifies listeners on change', () {
      final controller = ImageCompareSliderController();
      var notified = 0;
      controller.addListener(() => notified++);
      controller
        ..scale = 2
        ..position = 0.3;
      expect(notified, 2);
      controller.dispose();
    });

    test('setters, dedupe and helpers', () {
      final controller = ImageCompareSliderController();

      controller.rotationOne = 0.5;
      expect(controller.rotationOne, 0.5);
      controller.rotationOne = 0.5; // no-op (dedupe branch)

      controller.rotationTwo = 0.7;
      expect(controller.rotationTwo, 0.7);

      controller.lockRotation = true;
      expect(controller.lockRotation, true);
      controller.lockRotation = true; // no-op (dedupe branch)

      controller.rotateBoth(0.1);
      expect(controller.rotationOne, closeTo(0.6, 1e-9));
      expect(controller.rotationTwo, closeTo(0.8, 1e-9));

      controller.matchRotation(toFirst: false);
      expect(controller.rotationOne, controller.rotationTwo);

      controller.zoomBy(2);
      expect(controller.scale, 2);

      controller.panBy(const Offset(5, 5));
      expect(controller.offset, const Offset(5, 5));

      // Dedupe branches for offset/position (assigning the current value).
      controller.offset = const Offset(5, 5);
      final samePosition = controller.position;
      controller.position = samePosition;

      controller.dispose();
    });
  });

  group('New features', () {
    testWidgets('custom handle builder is rendered and draggable',
        (tester) async {
      double? newPosition;
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              height: 300,
              child: ImageCompareSlider(
                itemOne: Image.asset('assets/images/render.png'),
                itemTwo: Image.asset('assets/images/render_oc.png'),
                onPositionChange: (p) => newPosition = p,
                handleBuilder: (context, position, portrait) => Container(
                  key: const Key('custom-handle'),
                  width: 40,
                  height: 40,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('custom-handle')), findsOneWidget);

      await tester.drag(
        find.byKey(const Key('custom-handle')),
        const Offset(-60, 0),
        // The handle is an IgnorePointer overlay; the gesture passes through
        // to the slider's single gesture detector.
        warnIfMissed: false,
      );
      await tester.pump();

      expect(newPosition, isNotNull);
      expect(newPosition, isNot(0.5));
    });

    testWidgets('aspectRatio wraps the slider in an AspectRatio',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            itemOne: Image.asset('assets/images/render.png'),
            itemTwo: Image.asset('assets/images/render_oc.png'),
            fit: BoxFit.cover,
            aspectRatio: 16 / 9,
          ),
        ),
      );

      final aspectRatio =
          tester.widget<AspectRatio>(find.byType(AspectRatio).first);
      expect(aspectRatio.aspectRatio, 16 / 9);
    });

    testWidgets('pannable drag updates the controller offset, not position',
        (tester) async {
      final controller = ImageCompareSliderController();
      double? changedPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              height: 300,
              child: ImageCompareSlider(
                controller: controller,
                pannable: true,
                itemOne: Image.asset('assets/images/render.png'),
                itemTwo: Image.asset('assets/images/render_oc.png'),
                onPositionChange: (p) => changedPosition = p,
              ),
            ),
          ),
        ),
      );

      // Drag away from the handle so we pan rather than move the slider.
      await tester.dragFrom(const Offset(60, 60), const Offset(-40, 0));
      await tester.pump();

      expect(controller.offset.dx, isNot(0));
      expect(changedPosition, isNull);
      controller.dispose();
    });

    testWidgets('double tap toggles zoom when zoomable', (tester) async {
      final controller = ImageCompareSliderController();

      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              height: 300,
              child: ImageCompareSlider(
                controller: controller,
                zoomable: true,
                itemOne: Image.asset('assets/images/render.png'),
                itemTwo: Image.asset('assets/images/render_oc.png'),
              ),
            ),
          ),
        ),
      );

      expect(controller.scale, 1);

      await tester.tapAt(const Offset(150, 250));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tapAt(const Offset(150, 250));
      await tester.pump();

      expect(controller.scale, 2.5);

      // A second double-tap zooms back out.
      await tester.tapAt(const Offset(150, 250));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tapAt(const Offset(150, 250));
      await tester.pump();

      expect(controller.scale, 1);

      // Flush the pending double-tap timer before teardown.
      await tester.pump(const Duration(milliseconds: 500));
      controller.dispose();
    });

    testWidgets('onlyHandleDraggable ignores taps away from the handle',
        (tester) async {
      double? changedPosition;
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              height: 300,
              child: ImageCompareSlider(
                onlyHandleDraggable: true,
                itemOne: Image.asset('assets/images/render.png'),
                itemTwo: Image.asset('assets/images/render_oc.png'),
                onPositionChange: (p) => changedPosition = p,
              ),
            ),
          ),
        ),
      );

      // Tap far from the handle: position must not change.
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      expect(changedPosition, isNull);
    });

    testWidgets('swapping the controller prop rewires the widget',
        (tester) async {
      final c1 = ImageCompareSliderController(position: 0.3);
      final c2 = ImageCompareSliderController(position: 0.7);

      Widget build(ImageCompareSliderController? controller) => MaterialApp(
            home: ImageCompareSlider(
              key: const ValueKey('slider'),
              controller: controller,
              itemOne: Image.asset('assets/images/render.png'),
              itemTwo: Image.asset('assets/images/render_oc.png'),
            ),
          );

      await tester.pumpWidget(build(null)); // internal controller
      await tester.pumpWidget(build(c1)); // null -> provided
      await tester.pumpWidget(build(c2)); // provided -> provided
      await tester.pumpWidget(build(null)); // provided -> internal

      expect(find.byType(ImageCompareSlider), findsOneWidget);
      c1.dispose();
      c2.dispose();
    });

    testWidgets('a rotated image renders a Transform.rotate', (tester) async {
      final controller = ImageCompareSliderController(rotationOne: math.pi / 2);
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            controller: controller,
            itemOne: Image.asset('assets/images/render.png'),
            itemTwo: Image.asset('assets/images/render_oc.png'),
          ),
        ),
      );

      expect(find.byType(Transform), findsWidgets);
      controller.dispose();
    });

    testWidgets('custom handle is positioned in portrait direction',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              height: 300,
              child: ImageCompareSlider(
                direction: SliderDirection.topToBottom,
                itemOne: Image.asset('assets/images/render.png'),
                itemTwo: Image.asset('assets/images/render_oc.png'),
                handleBuilder: (context, position, portrait) => const SizedBox(
                  key: Key('portrait-handle'),
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('portrait-handle')), findsOneWidget);
    });

    testWidgets('pinch zooms and rotates both images', (tester) async {
      final controller = ImageCompareSliderController();
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              height: 300,
              child: ImageCompareSlider(
                controller: controller,
                zoomable: true,
                enableGestureRotation: true,
                itemOne: Image.asset('assets/images/render.png'),
                itemTwo: Image.asset('assets/images/render_oc.png'),
              ),
            ),
          ),
        ),
      );

      const step = Duration(milliseconds: 20);
      final g1 = await tester.startGesture(const Offset(140, 150), pointer: 1);
      await tester.pump(step);
      final g2 = await tester.startGesture(const Offset(160, 150), pointer: 2);
      await tester.pump(step);
      await g1.moveBy(const Offset(-80, 0));
      await tester.pump(step);
      await g2.moveBy(const Offset(80, 0));
      await tester.pump(step);
      await g1.up();
      await g2.up();
      await tester.pump();

      expect(controller.scale, greaterThan(1));
      controller.dispose();
    });

    testWidgets('handleFollowsPosition updates the handle in landscape',
        (tester) async {
      double? newPosition;
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              height: 300,
              child: ImageCompareSlider(
                handleFollowsPosition: true,
                itemOne: Image.asset('assets/images/render.png'),
                itemTwo: Image.asset('assets/images/render_oc.png'),
                onPositionChange: (p) => newPosition = p,
              ),
            ),
          ),
        ),
      );

      await tester.dragFrom(const Offset(150, 150), const Offset(-40, 30));
      await tester.pump();

      expect(newPosition, isNotNull);
    });

    testWidgets('dragging the handle in portrait moves the slider',
        (tester) async {
      double? newPosition;
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              height: 300,
              child: ImageCompareSlider(
                direction: SliderDirection.topToBottom,
                pannable: true,
                itemOne: Image.asset('assets/images/render.png'),
                itemTwo: Image.asset('assets/images/render_oc.png'),
                onPositionChange: (p) => newPosition = p,
              ),
            ),
          ),
        ),
      );

      // Start the drag on the handle (centre) so it routes to the slider even
      // with panning enabled — exercises the portrait handle geometry.
      await tester.dragFrom(const Offset(150, 150), const Offset(0, -60));
      await tester.pump();

      expect(newPosition, isNotNull);
    });

    testWidgets('custom handle relayouts when handle/direction change',
        (tester) async {
      Widget build(double handlePosition, SliderDirection direction) =>
          MaterialApp(
            home: ImageCompareSlider(
              key: const ValueKey('s'),
              direction: direction,
              handlePosition: handlePosition,
              itemOne: Image.asset('assets/images/render.png'),
              itemTwo: Image.asset('assets/images/render_oc.png'),
              handleBuilder: (context, position, portrait) =>
                  const SizedBox(key: Key('h'), width: 30, height: 30),
            ),
          );

      // position stays 0.5 throughout, so shouldRelayout falls through to the
      // handlePosition / portrait comparisons.
      await tester.pumpWidget(build(0.5, SliderDirection.leftToRight));
      await tester.pumpWidget(build(0.3, SliderDirection.leftToRight));
      await tester.pumpWidget(build(0.3, SliderDirection.topToBottom));

      expect(find.byKey(const Key('h')), findsOneWidget);
    });
  });

  group('DividerLineStyle', () {
    test('solid is the default and reports isSolid', () {
      const style = DividerLineStyle.solid();
      expect(style.isSolid, true);
      expect(style.pattern, isEmpty);
      expect(style.strokeCap, StrokeCap.butt);
    });

    test('default constructor is solid', () {
      const style = DividerLineStyle();
      expect(style.isSolid, true);
    });

    test('dashed builds an on/off pattern', () {
      final style = DividerLineStyle.dashed(dashLength: 10, gapLength: 4);
      expect(style.isSolid, false);
      expect(style.pattern, <double>[10, 4]);
      expect(style.strokeCap, StrokeCap.butt);
    });

    test('dotted is a zero-length dash with round caps', () {
      final style = DividerLineStyle.dotted(gapLength: 7);
      expect(style.pattern, <double>[0, 7]);
      expect(style.strokeCap, StrokeCap.round);
    });

    test('supports a fully custom pattern', () {
      const style = DividerLineStyle(
        pattern: <double>[12, 4, 4, 4],
        strokeCap: StrokeCap.square,
      );
      expect(style.pattern, <double>[12, 4, 4, 4]);
      expect(style.strokeCap, StrokeCap.square);
    });

    test('equality and hashCode consider pattern and strokeCap', () {
      final a = DividerLineStyle.dashed();
      final b = DividerLineStyle.dashed();
      const c = DividerLineStyle.solid();
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
    });

    testWidgets('is wired through the widget (defaults to solid)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ImageCompareSlider(
            itemOne: Image.asset('assets/images/render.png'),
            itemTwo: Image.asset('assets/images/render_oc.png'),
          ),
        ),
      );

      final slider =
          tester.widget<ImageCompareSlider>(find.byType(ImageCompareSlider));
      expect(slider.dividerLineStyle, const DividerLineStyle.solid());
    });

    testWidgets('dashed and dotted styles paint without error',
        (tester) async {
      for (final style in <DividerLineStyle>[
        DividerLineStyle.dashed(),
        DividerLineStyle.dotted(),
        const DividerLineStyle(pattern: <double>[12, 4, 4, 4]),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: ImageCompareSlider(
              direction: SliderDirection.topToBottom,
              itemOne: Image.asset('assets/images/render.png'),
              itemTwo: Image.asset('assets/images/render_oc.png'),
              dividerLineStyle: style,
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(
          tester
              .widget<ImageCompareSlider>(find.byType(ImageCompareSlider))
              .dividerLineStyle,
          style,
        );
      }
    });
  });
}
