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
  double dividerWidth = 2;
  bool reactOnHover = false;
  bool hideHandle = false;
  double position = 0.5;
  double handlePosition = 0.5;
  double handleSize = 20;
  bool fillHandle = false;
  ImageFilter? itemOneImageFilter;
  ImageFilter? itemTwoImageFilter;
  ColorFilter? itemOneColorFilter;
  ColorFilter? itemTwoColorFilter;
  double handleRadius = 10;
  Color? itemOneColor;
  BlendMode? itemOneBlendMode;
  Color? itemTwoColor;

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
                    itemTwo: const AssetImage('assets/images/render-big.jpeg'),
                    //itemTwo: const AssetImage('assets/images/render.png'),
                    //itemTwo: const NetworkImage(
                    //  'https://cdnb.artstation.com/p/assets/images/images/045/075/993/large/miriam-raya-garcia-render1.jpg?1641862646',
                    //),
                    itemOne: const AssetImage(
                      'assets/images/render_oc.png',
                    ),
                    /* Optional */
                    changePositionOnHover: reactOnHover,
                    direction: direction,
                    dividerColor: dividerColor,
                    dividerWidth: dividerWidth,
                    position: position,
                    onPositionChange: (position) {
                      setState(() => this.position = position);
                    },
                    hideHandle: hideHandle,
                    handlePosition: handlePosition,
                    fillHandle: fillHandle,
                    handleSize: handleSize,
                    itemOneImageFilter: itemOneImageFilter,
                    itemTwoImageFilter: itemTwoImageFilter,
                    itemOneColorFilter: itemOneColorFilter,
                    itemTwoColorFilter: itemTwoColorFilter,
                    handleRadius:
                        BorderRadius.all(Radius.circular(handleRadius)),
                    itemOneColor: itemOneColor,
                    itemTwoColor: itemTwoColor,
                    itemOneBlendMode: itemOneBlendMode,
                    itemTwoBlendMode: itemOneBlendMode,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Position: ${position.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),
              Slider(
                value: position,
                min: 0,
                max: 1,
                onChanged: (value) => setState(() => position = value),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Hide handle',
                            style: TextStyle(color: Colors.white),
                          ),
                          CupertinoSwitch(
                            value: hideHandle,
                            onChanged: (value) =>
                                setState(() => hideHandle = value),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Change position on hover',
                            style: TextStyle(color: Colors.white),
                          ),
                          CupertinoSwitch(
                            value: reactOnHover,
                            onChanged: (value) =>
                                setState(() => reactOnHover = value),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Fill handle',
                            style: TextStyle(color: Colors.white),
                          ),
                          CupertinoSwitch(
                            value: fillHandle,
                            onChanged: (value) =>
                                setState(() => fillHandle = value),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Filter/Color 1',
                            style: TextStyle(color: Colors.white),
                          ),
                          CupertinoSwitch(
                            value: itemOneImageFilter != null,
                            onChanged: (value) => setState(() =>
                                itemOneImageFilter = value
                                    ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                                    : null),
                          ),
                          CupertinoSwitch(
                            value: itemOneColorFilter != null,
                            onChanged: (value) => setState(() =>
                                itemOneColorFilter = value
                                    ? const ColorFilter.mode(
                                        Colors.red, BlendMode.colorBurn)
                                    : null),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Filter/Color 2',
                            style: TextStyle(color: Colors.white),
                          ),
                          CupertinoSwitch(
                            value: itemTwoImageFilter != null,
                            onChanged: (value) => setState(() =>
                                itemTwoImageFilter = value
                                    ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                                    : null),
                          ),
                          CupertinoSwitch(
                            value: itemTwoColorFilter != null,
                            onChanged: (value) => setState(() =>
                                itemTwoColorFilter = value
                                    ? const ColorFilter.mode(
                                        Colors.blue, BlendMode.colorBurn)
                                    : null),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Divider width: ${dividerWidth.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Slider(
                        value: dividerWidth,
                        min: 0,
                        max: 50,
                        onChanged: (value) =>
                            setState(() => dividerWidth = value),
                      ),
                      Text(
                        'Handle size: ${handleSize.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Slider(
                        value: handleSize,
                        min: 0,
                        max: 50,
                        onChanged: (value) =>
                            setState(() => handleSize = value),
                      ),
                      Text(
                        'Handle position: ${handlePosition.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Slider(
                        value: handlePosition,
                        min: 0,
                        max: 1,
                        onChanged: (value) =>
                            setState(() => handlePosition = value),
                      ),
                      Text(
                        'Handle radius: ${handleRadius.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Slider(
                        value: handleRadius,
                        min: 0,
                        max: 50,
                        onChanged: (value) =>
                            setState(() => handleRadius = value),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Slider direction: ${direction.toString().split('.').last}',
                style: const TextStyle(color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(SliderDirection.values.length, (index) {
                  late IconData icon;
                  switch (SliderDirection.values[index]) {
                    case SliderDirection.leftToRight:
                      icon = Icons.arrow_forward_ios;
                      break;
                    case SliderDirection.rightToLeft:
                      icon = Icons.arrow_back_ios;
                      break;
                    case SliderDirection.topToBottom:
                      icon = Icons.arrow_downward;
                      break;
                    case SliderDirection.bottomToTop:
                      icon = Icons.arrow_upward;
                      break;
                  }
                  return IconButton(
                    onPressed: () => setState(
                        () => direction = SliderDirection.values[index]),
                    icon: Column(
                      children: [
                        Icon(
                          icon,
                          color: direction == SliderDirection.values[index]
                              ? Colors.blueAccent
                              : Colors.white,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const Text(
                'Divider Color',
                style: TextStyle(color: Colors.white),
              ),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    Colors.primaries.length,
                    (index) => IconButton(
                      onPressed: () {
                        if (dividerColor == Colors.primaries[index]) {
                          setState(() => dividerColor = Colors.white);
                          return;
                        }
                        setState(() => dividerColor = Colors.primaries[index]);
                      },
                      icon: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            if (dividerColor == Colors.primaries[index])
                              const BoxShadow(
                                color: Colors.blueAccent,
                                blurRadius: 5,
                              )
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.circle,
                          color: Colors.primaries[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: const [
                  Text('Item 1 Color', style: TextStyle(color: Colors.white)),
                  Spacer(),
                  Text('Item 2 Color', style: TextStyle(color: Colors.white)),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        Colors.primaries.length,
                        (index) => IconButton(
                          onPressed: () {
                            if (itemOneColor == Colors.primaries[index]) {
                              setState(() => itemOneColor = null);
                              return;
                            }
                            setState(
                                () => itemOneColor = Colors.primaries[index]);
                          },
                          icon: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                if (itemOneColor == Colors.primaries[index])
                                  const BoxShadow(
                                    color: Colors.blueAccent,
                                    blurRadius: 5,
                                  )
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.circle,
                              color: Colors.primaries[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        Colors.primaries.length,
                        (index) => IconButton(
                          onPressed: () {
                            if (itemTwoColor == Colors.primaries[index]) {
                              setState(() => itemTwoColor = null);
                              return;
                            }
                            setState(
                                () => itemTwoColor = Colors.primaries[index]);
                          },
                          icon: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                if (itemTwoColor == Colors.primaries[index])
                                  const BoxShadow(
                                    color: Colors.blueAccent,
                                    blurRadius: 5,
                                  )
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.circle,
                              color: Colors.primaries[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text('Blend Mode', style: TextStyle(color: Colors.white)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      BlendMode.values.length,
                      (index) => TextButton(
                        onPressed: () {
                          if (BlendMode.values[index] == itemOneBlendMode) {
                            setState(() {
                              itemOneBlendMode = null;
                            });
                            return;
                          }
                          setState(() {
                            itemOneBlendMode = BlendMode.values[index];
                          });
                        },
                        child: Text(
                          BlendMode.values[index].toString().split('.').last,
                          style: TextStyle(
                            fontSize: 20,
                            color: itemOneBlendMode == BlendMode.values[index]
                                ? Colors.blueAccent
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
}
