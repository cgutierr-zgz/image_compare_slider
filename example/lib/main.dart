import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _App(),
    );
  }
}

class _App extends StatefulWidget {
  const _App();

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  SliderDirection direction = SliderDirection.leftToRight;
  Color dividerColor = Colors.white;
  Color handleColor = Colors.white;
  Color handleOutlineColor = Colors.white;
  double dividerWidth = 2;
  bool reactOnHover = false;
  bool hideHandle = false;
  double position = 0.5;
  double handlePosition = 0.5;
  double handleSizeHeight = 75;
  double handleSizeWidth = 7.5;
  bool handleFollowsP = false;
  bool fillHandle = true;
  double handleRadius = 10;
  Color? itemOneColor;
  Color? itemTwoColor;
  BlendMode itemOneBlendMode = BlendMode.overlay;
  BlendMode itemTwoBlendMode = BlendMode.darken;
  Widget Function(Widget)? itemOneWrapper;
  Widget Function(Widget)? itemTwoWrapper;

  // New features.
  final controller = ImageCompareSliderController(maxScale: 6);
  bool zoomable = false;
  bool pannable = false;
  bool gestureRotation = false;
  bool lockRotation = false;
  bool useCustomHandle = false;
  bool matchSizes = false;
  int handleStyle = 0; // 0..9

  @override
  void initState() {
    super.initState();
    // Keep the zoom readout / button states in sync with the controller.
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Image Compare Slider'),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.grey.shade900,
                title: const Text(
                  'Image Compare Slider',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'This is a Flutter package that allows you to compare two images with a fully customizable slider.',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Last Arrangements',
                  style: TextStyle(color: Colors.white, fontSize: 30)),
              const Text(
                'Miriam Raya',
                style: TextStyle(color: Colors.blueAccent, fontSize: 15),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: ImageCompareSlider(
                    itemOne: Image.asset(
                      'assets/images/render_oc.png',
                      colorBlendMode: itemOneBlendMode,
                      color: itemOneColor,
                    ),
                    itemTwo: Image.asset(
                      'assets/images/render-big.jpeg',
                      colorBlendMode: itemTwoBlendMode,
                      color: itemTwoColor,
                    ),

                    /* Optional */
                    controller: controller,
                    changePositionOnHover: reactOnHover,
                    direction: direction,
                    dividerColor: dividerColor,
                    handleColor: handleColor,
                    handleOutlineColor: handleOutlineColor,
                    dividerWidth: dividerWidth,
                    onPositionChange: (p) => setState(() => position = p),
                    hideHandle: hideHandle,
                    handlePosition: handlePosition,
                    fillHandle: fillHandle,
                    handleSize: Size(handleSizeWidth, handleSizeHeight),
                    handleRadius:
                        BorderRadius.all(Radius.circular(handleRadius)),
                    itemOneBuilder: (child, context) =>
                        itemOneWrapper?.call(child) ?? child,
                    itemTwoBuilder: (child, context) =>
                        itemTwoWrapper?.call(child) ?? child,
                    handleFollowsPosition: handleFollowsP,
                    // New features.
                    zoomable: zoomable,
                    pannable: pannable,
                    enableGestureRotation: gestureRotation,
                    fit: matchSizes ? BoxFit.cover : BoxFit.contain,
                    aspectRatio: matchSizes ? 16 / 9 : null,
                    handleBuilder: useCustomHandle
                        ? (context, position, portrait) => _customHandle(
                              handleStyle,
                              position,
                              portrait,
                              handleColor,
                            )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              slider('Position: ${position.toStringAsFixed(2)}', position, (v) {
                setState(() {
                  position = v;
                  controller.position = v;
                });
              }),
              Center(
                child: switcher('React on hover', reactOnHover, (v) {
                  setState(() => reactOnHover = v);
                }),
              ),
              _DividerWithText(
                text: 'Divider',
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          slider('Width: ${dividerWidth.toStringAsFixed(2)}',
                              dividerWidth, (v) {
                            setState(() => dividerWidth = v);
                          }, max: 25, min: 0),
                          slider(
                            'R',
                            dividerColor.r255.toDouble(),
                            (v) => setState(() =>
                                dividerColor = dividerColor.withRed(v.toInt())),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'G',
                            dividerColor.g255.toDouble(),
                            (v) => setState(() => dividerColor =
                                dividerColor.withGreen(v.toInt())),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'B',
                            dividerColor.b255.toDouble(),
                            (v) => setState(() => dividerColor =
                                dividerColor.withBlue(v.toInt())),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'A',
                            dividerColor.a,
                            (v) => setState(() =>
                                dividerColor = dividerColor.withValues(alpha: v)),
                            max: 1,
                            min: 0,
                          ),
                        ],
                      ),
                      const Spacer(),
                      directionArrow(),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
              _DividerWithText(
                text: 'Handle',
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Color',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          slider(
                            'R',
                            handleColor.r255.toDouble(),
                            (v) => setState(() =>
                                handleColor = handleColor.withRed(v.toInt())),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'G',
                            handleColor.g255.toDouble(),
                            (v) => setState(() =>
                                handleColor = handleColor.withGreen(v.toInt())),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'B',
                            handleColor.b255.toDouble(),
                            (v) => setState(() =>
                                handleColor = handleColor.withBlue(v.toInt())),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'A',
                            handleColor.a,
                            (v) => setState(
                                () => handleColor = handleColor.withValues(alpha: v)),
                            max: 1,
                            min: 0,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Outline',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          slider(
                            'R',
                            handleOutlineColor.r255.toDouble(),
                            (v) => setState(() => handleOutlineColor =
                                handleOutlineColor.withRed(v.toInt())),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'G',
                            handleOutlineColor.g255.toDouble(),
                            (v) => setState(() => handleOutlineColor =
                                handleOutlineColor.withGreen(v.toInt())),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'B',
                            handleOutlineColor.b255.toDouble(),
                            (v) => setState(() => handleOutlineColor =
                                handleOutlineColor.withBlue(v.toInt())),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'A',
                            handleOutlineColor.a,
                            (v) => setState(() => handleOutlineColor =
                                handleOutlineColor.withValues(alpha: v)),
                            max: 1,
                            min: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  switcher('Hide handle', hideHandle, (v) {
                    setState(() => hideHandle = v);
                  }),
                  switcher('Fill handle', fillHandle, (v) {
                    setState(() => fillHandle = v);
                  }),
                  switcher('Follows position', handleFollowsP, (v) {
                    setState(() => handleFollowsP = v);
                  }),
                  slider('Position: ${handlePosition.toStringAsFixed(2)}',
                      handlePosition, (v) {
                    setState(() => handlePosition = v);
                  }),
                  slider('Radius: ${handleRadius.toStringAsFixed(2)}',
                      handleRadius, (v) {
                    setState(() => handleRadius = v);
                  }, max: 50, min: 0),
                  slider('Size H: ${handleSizeHeight.toStringAsFixed(2)}',
                      handleSizeHeight, (v) {
                    setState(() => handleSizeHeight = v);
                  }, max: 100, min: 0),
                  slider('Size W: ${handleSizeWidth.toStringAsFixed(2)}',
                      handleSizeWidth, (v) {
                    setState(() => handleSizeWidth = v);
                  }, max: 100, min: -50),
                ],
              ),
              _DividerWithText(
                text: 'Items',
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          slider(
                            'R',
                            itemOneColor?.r255.toDouble() ?? 0,
                            (v) => setState(() => itemOneColor =
                                itemOneColor?.withRed(v.toInt()) ??
                                    Colors.white),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'G',
                            itemOneColor?.g255.toDouble() ?? 0,
                            (v) => setState(() => itemOneColor =
                                itemOneColor?.withGreen(v.toInt()) ??
                                    Colors.white),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'B',
                            itemOneColor?.b255.toDouble() ?? 0,
                            (v) => setState(() => itemOneColor =
                                itemOneColor?.withBlue(v.toInt()) ??
                                    Colors.white),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'A',
                            itemOneColor?.a.toDouble() ?? 0,
                            (v) => setState(() => itemOneColor =
                                itemOneColor?.withValues(alpha: v) ?? Colors.white),
                            max: 1,
                            min: 0,
                          ),
                          PopupMenuButton<BlendMode>(
                            color: Colors.grey.shade800,
                            child: Row(
                              children: [
                                text('Blend mode: '),
                                text(itemOneBlendMode
                                    .toString()
                                    .split('.')
                                    .last),
                              ],
                            ),
                            onSelected: (v) =>
                                setState(() => itemOneBlendMode = v),
                            itemBuilder: (context) => BlendMode.values
                                .map(
                                  (e) => PopupMenuItem(
                                    value: e,
                                    child: text(e.toString().split('.')[1]),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 10),
                          switcher('Add Blur', itemOneWrapper != null, (v) {
                            setState(
                              () => itemOneWrapper = v
                                  ? (child) => ImageFiltered(
                                        imageFilter: ImageFilter.blur(
                                            sigmaX: 2, sigmaY: 5),
                                        child: child,
                                      )
                                  : null,
                            );
                          }),
                        ],
                      ),
                      Column(
                        children: [
                          slider(
                            'R',
                            itemTwoColor?.r255.toDouble() ?? 0,
                            (v) => setState(() => itemTwoColor =
                                itemTwoColor?.withRed(v.toInt()) ??
                                    Colors.white),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'G',
                            itemTwoColor?.g255.toDouble() ?? 0,
                            (v) => setState(() => itemTwoColor =
                                itemTwoColor?.withGreen(v.toInt()) ??
                                    Colors.white),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'B',
                            itemTwoColor?.b255.toDouble() ?? 0,
                            (v) => setState(() => itemTwoColor =
                                itemTwoColor?.withBlue(v.toInt()) ??
                                    Colors.white),
                            max: 255,
                            min: 0,
                          ),
                          slider(
                            'A',
                            itemTwoColor?.a.toDouble() ?? 0,
                            (v) => setState(() => itemTwoColor =
                                itemTwoColor?.withValues(alpha: v) ?? Colors.white),
                            max: 1,
                            min: 0,
                          ),
                          PopupMenuButton<BlendMode>(
                            color: Colors.grey.shade800,
                            child: Row(
                              children: [
                                text('Blend mode: '),
                                text(itemTwoBlendMode
                                    .toString()
                                    .split('.')
                                    .last),
                              ],
                            ),
                            onSelected: (v) =>
                                setState(() => itemTwoBlendMode = v),
                            itemBuilder: (context) => BlendMode.values
                                .map(
                                  (e) => PopupMenuItem(
                                    value: e,
                                    child: text(e.toString().split('.')[1]),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 10),
                          switcher('Add Color Filter', itemTwoWrapper != null,
                              (v) {
                            setState(
                              () => itemTwoWrapper = v
                                  ? (child) => ColorFiltered(
                                        colorFilter: const ColorFilter.mode(
                                            Colors.red, BlendMode.color),
                                        child: child,
                                      )
                                  : null,
                            );
                          }),
                        ],
                      )
                    ],
                  )
                ],
              ),
              _DividerWithText(
                text: 'Zoom / Pan / Rotate',
                children: [
                  switcher('Zoomable (pinch / double-tap)', zoomable, (v) {
                    setState(() => zoomable = v);
                  }),
                  switcher('Pannable (drag)', pannable, (v) {
                    setState(() => pannable = v);
                  }),
                  switcher('Two-finger gesture rotation', gestureRotation, (v) {
                    setState(() => gestureRotation = v);
                  }),
                  switcher('Custom handle widget', useCustomHandle, (v) {
                    setState(() => useCustomHandle = v);
                  }),
                  if (useCustomHandle)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text('Handle style ${handleStyle + 1}/10'),
                        const SizedBox(width: 8),
                        _actionButton(
                          'Next ▷',
                          () => setState(
                            () => handleStyle = (handleStyle + 1) % 10,
                          ),
                        ),
                      ],
                    ),
                  switcher('Match sizes (16:9 cover)', matchSizes, (v) {
                    setState(() => matchSizes = v);
                  }),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Zoom: ${controller.scale.toStringAsFixed(2)}x',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _actionButton('Zoom +', () => controller.zoomBy(1.25)),
                      _actionButton('Zoom -', () => controller.zoomBy(0.8)),
                      _actionButton('Reset', controller.reset),
                    ],
                  ),
                  const SizedBox(height: 10),
                  text('Rotate left image'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _actionButton(
                        '⟲ 90°',
                        () => controller.rotateOne(
                          -ImageCompareSliderController.quarterTurn,
                        ),
                      ),
                      _actionButton(
                        '⟳ 90°',
                        () => controller.rotateOne(
                          ImageCompareSliderController.quarterTurn,
                        ),
                      ),
                    ],
                  ),
                  text('Rotate right image'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _actionButton(
                        '⟲ 90°',
                        () => controller.rotateTwo(
                          -ImageCompareSliderController.quarterTurn,
                        ),
                      ),
                      _actionButton(
                        '⟳ 90°',
                        () => controller.rotateTwo(
                          ImageCompareSliderController.quarterTurn,
                        ),
                      ),
                    ],
                  ),
                  switcher('🔒 Lock rotation (rotate both)', lockRotation, (v) {
                    setState(() {
                      lockRotation = v;
                      controller.lockRotation = v;
                    });
                  }),
                ],
              ),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
      /*
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade900,
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            '© 2022 Miriam Raya\nConcept by: Lynn Chen',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),*/
    );
  }

  Widget slider(String title, double value, Function(double) onChanged,
      {double max = 1, double min = 0}) {
    return Row(
      children: [
        text(title),
        const SizedBox(width: 5),
        SizedBox(
          //width: 100,
          child: CupertinoSlider(
            value: value,
            max: max,
            min: min,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget switcher(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(title),
        const SizedBox(width: 10),
        SizedBox(
          child: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget text(String text) {
    return Text(text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ));
  }

  Widget directionArrow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        SliderDirection.values.length,
        (index) {
          final dir = SliderDirection.values[index];
          late IconData icon;

          switch (dir) {
            case SliderDirection.leftToRight:
              icon = Icons.arrow_forward;
              break;
            case SliderDirection.rightToLeft:
              icon = Icons.arrow_back;
              break;
            case SliderDirection.topToBottom:
              icon = Icons.arrow_downward;
              break;
            case SliderDirection.bottomToTop:
              icon = Icons.arrow_upward;
              break;
          }
          return IconButton(
            icon: Icon(
              icon,
              color: dir == direction ? Colors.blueAccent : Colors.white,
            ),
            onPressed: () => setState(() => direction = dir),
          );
        },
      ),
    );
  }
}

class _DividerWithText extends StatefulWidget {
  const _DividerWithText({
    required this.text,
    required this.children,
  });

  final String text;
  final List<Widget> children;

  @override
  State<_DividerWithText> createState() => _DividerWithTextState();
}

class _DividerWithTextState extends State<_DividerWithText> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(0),
          onPressed: () => setState(() => show = !show),
          child: Row(children: [
            const Expanded(child: Divider(color: Colors.white)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Expanded(child: Divider(color: Colors.white)),
          ]),
        ),
        if (show) ...widget.children,
      ],
    );
  }
}

/// Demonstrates that `handleBuilder` can return ANY widget — these are 10
/// different examples cycled in the example app. [pos] is the divider position
/// (0-1), [portrait] is true for top/bottom directions.
Widget _customHandle(int style, double pos, bool portrait, Color color) {
  final dark = Colors.grey.shade900;
  // Rotate directional content for portrait sliders.
  Widget orient(Widget child) =>
      portrait ? RotatedBox(quarterTurns: 1, child: child) : child;

  const shadow = [
    BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
  ];

  switch (style) {
    case 0: // Rounded pill with chevrons
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: shadow,
        ),
        child: orient(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chevron_left, color: dark, size: 18),
            Icon(Icons.chevron_right, color: dark, size: 18),
          ],
        )),
      );
    case 1: // Plain circle with drag icon
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: shadow,
        ),
        child: orient(Icon(Icons.drag_indicator, color: dark, size: 22)),
      );
    case 2: // Pill showing the position percentage
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: shadow,
        ),
        child: Text(
          '${(pos * 100).round()}%',
          style: TextStyle(color: dark, fontWeight: FontWeight.bold),
        ),
      );
    case 3: // Thin bar
      return orient(Container(
        width: 6,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
          boxShadow: shadow,
        ),
      ));
    case 4: // Diamond
      return Transform.rotate(
        angle: 0.7853981633974483, // 45°
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: color, boxShadow: shadow),
        ),
      );
    case 5: // Outlined circle with double chevron
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 3),
        ),
        child: orient(Icon(Icons.unfold_more, color: color, size: 24)),
      );
    case 6: // Translucent "glass" circle
      return Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white70, width: 2),
        ),
        child: orient(Icon(Icons.swap_horiz, color: Colors.white, size: 22)),
      );
    case 7: // Square card with swap icon
      return Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: shadow,
        ),
        child: orient(Icon(Icons.compare_arrows, color: dark, size: 22)),
      );
    case 8: // Gradient pill
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.blueAccent],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: shadow,
        ),
        child: orient(const Icon(Icons.code, color: Colors.white, size: 18)),
      );
    case 9: // Emoji
      return orient(
        const Text('👈👉', style: TextStyle(fontSize: 24)),
      );
    default:
      return const SizedBox.shrink();
  }
}

/// Helpers to read a [Color]'s 8-bit channels (the `.red`/`.green`/`.blue`
/// getters are deprecated in favour of the 0-1 `.r`/`.g`/`.b` doubles).
extension on Color {
  int get r255 => (r * 255).round();
  int get g255 => (g * 255).round();
  int get b255 => (b * 255).round();
}
