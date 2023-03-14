// ignore_for_file: avoid_redundant_argument_values

part of 'image_compare_slider.dart';

/*

      theme: ThemeData.light().copyWith(
        extensions: <ThemeExtension<dynamic>>[
          const MyColors(
            brandColor: Color(0xFF1E88E5),
            danger: Color(0xFFE53935),
          ),
        ],
      ),
 */

/// {@template flutter_compare_slider_theme_data}
/// A [ThemeExtension] that defines the colors used by the [ImageCompareSlider].
/// {@endtemplate}
@immutable
class ImageCompareSliderThemeData
    extends ThemeExtension<ImageCompareSliderThemeData> {
  /// {@macro flutter_compare_slider_theme_data}
  const ImageCompareSliderThemeData({
    this.changePositionOnHover = false,
    this.direction = SliderDirection.leftToRight,
    this.dividerColor = Colors.white,
    this.dividerWidth = 2.5,
    this.fillHandle = false,
    this.handleFollowsPosition = false,
    // this.handlePosition = 0.5,
    this.handleRadius = const BorderRadius.all(Radius.circular(10)),
    this.handleSize = const Size(20, 20),
    this.hideHandle = false,
    // this.itemOneBuilder,
    // this.itemTwoBuilder,
    // this.onPositionChange,
    // this.position = 0.5,
  });

  /// Creates a [ImageCompareSliderThemeData] from a [ThemeData].
  ///
  /// {@macro flutter_compare_slider_theme}
  factory ImageCompareSliderThemeData.fromTheme(ThemeData theme) {
    return ImageCompareSliderThemeData(
      changePositionOnHover: false,
      direction: SliderDirection.leftToRight,
      dividerColor: theme.primaryColor,
      dividerWidth: 1,
      fillHandle: true,
      handleFollowsPosition: false,
      // handlePosition: 0.5,
      handleRadius: const BorderRadius.all(Radius.circular(10)),
      handleSize: const Size(20, 20),
      hideHandle: false,
      // itemOneBuilder: null,
      // itemTwoBuilder: null,
      // onPositionChange: null,
      // position: 0.5,
    );
  }

  /// Whether the position of the slider should change when hovering over the
  final bool changePositionOnHover;

  /// The direction of the slider.
  final SliderDirection direction;

  /// The color of the divider.
  final Color dividerColor;

  /// The width of the divider.
  final double dividerWidth;

  /// Whether the handle should be filled.
  final bool fillHandle;

  /// Whether the handle should follow the position.
  final bool handleFollowsPosition;

  /// The initial position of the handle.
  // final double handlePosition;

  /// The radius of the handle.
  final BorderRadius handleRadius;

  /// The size of the handle.
  final Size handleSize;

  /// Whether the handle should be hidden.
  final bool hideHandle;

  /// A builder for the first item.
  // final Widget Function(Widget child)? itemOneBuilder;

  /// A builder for the second item.
  // final Widget Function(Widget child)? itemTwoBuilder;

  /// A callback for when the position changes.
  // final void Function(double position)? onPositionChange;

  /// The initial position of the divider.
  // final double position;

  @override
  ThemeExtension<ImageCompareSliderThemeData> copyWith({
    bool? changePositionOnHover,
    SliderDirection? direction,
    Color? dividerColor,
    double? dividerWidth,
    bool? fillHandle,
    bool? handleFollowsPosition,
    double? handlePosition,
    BorderRadius? handleRadius,
    Size? handleSize,
    bool? hideHandle,
    //Widget Function(Widget child)? itemOneBuilder,
    //Widget Function(Widget child)? itemTwoBuilder,
    //void Function(double position)? onPositionChange,
    // double? position,
  }) {
    return ImageCompareSliderThemeData(
      changePositionOnHover:
          changePositionOnHover ?? this.changePositionOnHover,
      direction: direction ?? this.direction,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerWidth: dividerWidth ?? this.dividerWidth,
      fillHandle: fillHandle ?? this.fillHandle,
      handleFollowsPosition:
          handleFollowsPosition ?? this.handleFollowsPosition,
      // handlePosition: handlePosition ?? this.handlePosition,
      handleRadius: handleRadius ?? this.handleRadius,
      handleSize: handleSize ?? this.handleSize,
      hideHandle: hideHandle ?? this.hideHandle,
      // itemOneBuilder: itemOneBuilder ?? this.itemOneBuilder,
      // itemTwoBuilder: itemTwoBuilder ?? this.itemTwoBuilder,
      // onPositionChange: onPositionChange ?? this.onPositionChange,
      // position: position ?? this.position,
    );
  }

  @override
  ThemeExtension<ImageCompareSliderThemeData> lerp(
    covariant ThemeExtension<ImageCompareSliderThemeData>? other,
    double t,
  ) {
    if (other is! ImageCompareSliderThemeData) return this;

    return ImageCompareSliderThemeData(
      dividerColor:
          Color.lerp(dividerColor, other.dividerColor, t) ?? dividerColor,
    );
  }
}

/// {@template flutter_compare_slider_theme}
/// A [ThemeExtension] that defines the colors used by the [ImageCompareSlider].
/// {@endtemplate}
class ImageCompareSliderTheme extends InheritedWidget {
  /// {@macro flutter_compare_slider_theme}
  const ImageCompareSliderTheme({
    required super.child,
    required this.data,
    super.key,
  });

  /// The [ImageCompareSliderThemeData] for this theme.
  final ImageCompareSliderThemeData data;

  /// The closest instance of this class that encloses the given context.
  static ImageCompareSliderThemeData of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<ImageCompareSliderTheme>();
    return widget?.data ??
        ImageCompareSliderThemeData.fromTheme(Theme.of(context));
  }

  @override
  bool updateShouldNotify(ImageCompareSliderTheme oldWidget) =>
      data != oldWidget.data;
}
