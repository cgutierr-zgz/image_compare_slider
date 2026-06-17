# Image Compare Slider

[![ci][ci_badge]][ci_link] [![pub package][pub_badge]][pub_link] ![Coverage badge][coverage_badge] [![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link] [![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason) [![License: MIT][license_badge]][license_link]

Inspired by [react-compare-slider](https://www.npmjs.com/package/react-compare-slider), this package allows you to easily compare two images with a slider — with **zoom & pan**, **rotation (with lock)**, **custom handles** and **size matching**.

**PR's are welcome!**

<img src="https://raw.githubusercontent.com/cgutierr-zgz/image_compare_slider/main/screenshots/example.png" width="300">

## Installation 💻

**❗ In order to start using Image Compare you must have the [Dart SDK][dart_install_link] installed on your machine.**

Add `image_compare_slider` to your `pubspec.yaml`:

```yaml
dependencies:
  image_compare_slider:
```

Install it:

```sh
dart pub get
```

Import it:

```dart
import 'package:image_compare_slider/image_compare_slider.dart';
```

Use it:

```dart
//...
ImageCompareSlider(
  itemOne: const Image.asset('...'),
  itemTwo: const Image.network('...'),
)
//...
```


The widget its pretty simple and customizable, see:

![Example](https://github.com/cgutierr-zgz/image_compare_slider/blob/main/screenshots/video.gif)

## Customization 🎨

You can customize the widget with the following parameters:

| Parameter | Type | Description |
| --- | --- | --- |
| `itemOne` | `Image` | The first image to compare |
| `itemTwo` | `Image` | The second image to compare |
| `changePositionOnHover` | `bool` | If the slider should change position when the mouse is over it |
| `handleSize` | `Size` | The size of the handle |
| `handleRadius` | `BorderRadius` | The radius of the handle |
| `fillHandle` | `bool` | If the handle should be filled |
| `hideHandle` | `bool` | If the handle should be hidden |
| `handlePosition` | `double` | The position of the handle relative to the slider |
| `handleFollowsPosition` | `bool` | If the handle should follow the position of the slider |
| `onPositionChange` | `void Function(double position)?` | The callback to be called when the position changes |
| `direction` | `SliderDirection` | The direction of the slider will clip the image |
| `dividerColor` | `Color` | The color of the divider |
| `handleColor` | `Color` | The color of the handle |
| `handleOutlineColor` | `Color` | The color of the handle outline |
| `dividerWidth` | `double` | The width of the divider |
| `itemOneBuilder` | `Widget Function(Widget child, BuildContext context)?` | The wrapper for the first image |
| `itemTwoBuilder` | `Widget Function(Widget child, BuildContext context)?` | The wrapper for the second image |
| `photoRadius` | `BorderRadiusGeometry` | Radius of the photo |
| `controller` | `ImageCompareSliderController?` | Drives position, zoom, pan and rotation programmatically |
| `handleBuilder` | `HandleBuilder?` | Builds a fully custom, draggable handle widget |
| `onlyHandleDraggable` | `bool` | Restrict slider movement to dragging the handle |
| `fit` | `BoxFit` | How both images are inscribed into their box (default `BoxFit.contain`) |
| `aspectRatio` | `double?` | Force both images into the same box to match different sizes |
| `zoomable` | `bool` | Enable pinch / double-tap zoom on both images |
| `pannable` | `bool` | Enable drag-to-pan on both images |
| `enableGestureRotation` | `bool` | Enable two-finger rotation gestures |
| `doubleTapToZoom` | `bool` | Toggle zoom on double-tap (default `true`) |
| `minScale` / `maxScale` | `double` | Zoom bounds (default `1.0` / `5.0`) |
| `doubleTapScale` | `double` | Zoom factor applied on double-tap (default `2.5`) |


If you want to add some effects you can use the `itemOneBuilder` and `itemTwoBuilder` parameters to wrap the images with a `ColorFilter` or `ImageFilter`, or any other widget you want.

For example, to add a `ImageFilter` with a blur effect:

```dart
// ...
ImageCompareSlider(
  itemOne: const Image.asset('...'),
  itemTwo: const Image.asset('...'),
  itemOneBuilder: (child, context) => ImageFiltered(
  imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 5),
    child: child,
  ),
)
// ...
```

Will result in:

<img src="https://raw.githubusercontent.com/cgutierr-zgz/image_compare_slider/main/screenshots/example2.png" width="300">

You can also pass any custom properties to the `Image` for `itemOne` and `itemTwo`, and most of the `Image` properties will be applied to the `ImageCompareSlider` widget.

For example, adding a `colorBlendMode` with a `color` to itemOne:

```dart
// ...
ImageCompareSlider(
  itemOne: const Image.asset('...', color: Colors.red, colorBlendMode: BlendMode.overlay),
  itemTwo: const Image.asset('...'),
)
// ...
```

Will result in:

<img src="https://raw.githubusercontent.com/cgutierr-zgz/image_compare_slider/main/screenshots/example3.png" width="300">

Customizing the handle and divider is also possible:

```dart
// ...
ImageCompareSlider(
  itemOne: const Image.asset('...'),
  itemTwo: const Image.asset('...'),
  handleSize: Size(0.05, 0.05),
  handleRadius: const BorderRadius.all(Radius.circular(50)),
  fillHandle: true,
  dividerColor: Colors.black,
  dividerWidth: 10,
  handlePosition: 0.8,
  // ...
)
// ...
```

Will result in:

<img src="https://raw.githubusercontent.com/cgutierr-zgz/image_compare_slider/main/screenshots/example4.png" width="300">

## Zoom & pan 🔍

Enable `zoomable` and/or `pannable` to pinch-zoom and drag both images at once
while keeping them perfectly aligned. Double-tap toggles zoom. Dragging the
handle still moves the slider, even while zoomed in.

```dart
ImageCompareSlider(
  itemOne: const Image.asset('...'),
  itemTwo: const Image.asset('...'),
  zoomable: true,
  pannable: true,
  maxScale: 6, // optional zoom bounds
)
```

## Rotation with lock 🔄

Pass an `ImageCompareSliderController` to rotate either image in either
direction. Turn on `lockRotation` to rotate both images together in the same
cycle. The controller also exposes zoom, pan, position and a `reset()`.

```dart
final controller = ImageCompareSliderController();

ImageCompareSlider(
  controller: controller,
  itemOne: const Image.asset('...'),
  itemTwo: const Image.asset('...'),
);

// Rotate the left image a quarter turn clockwise.
controller.rotateOne(ImageCompareSliderController.quarterTurn);
// Rotate the right image counter-clockwise.
controller.rotateTwo(-ImageCompareSliderController.quarterTurn);
// Lock so both rotate together.
controller.lockRotation = true;
// Snap the second image to the first's angle.
controller.matchRotation();
// Reset zoom/pan/rotation.
controller.reset();
```

Remember to `dispose()` controllers you create yourself.

## Custom handle ✋

Replace the painted handle with any widget via `handleBuilder`. It is centered
on the handle anchor and stays draggable. The divider line is still drawn.

```dart
ImageCompareSlider(
  itemOne: const Image.asset('...'),
  itemTwo: const Image.asset('...'),
  handleBuilder: (context, position, portrait) => Container(
    padding: const EdgeInsets.all(6),
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.unfold_more, size: 18),
  ),
)
```

## Matching image sizes 📐

If your images have different sizes or aspect ratios, set an `aspectRatio` and
a `fit` (e.g. `BoxFit.cover`) so both are forced into the same box and line up.

```dart
ImageCompareSlider(
  itemOne: const Image.asset('...'), // 4000x3000
  itemTwo: const Image.asset('...'), // 1920x1080
  fit: BoxFit.cover,
  aspectRatio: 16 / 9,
)
```

## Releasing 🚀

Releases are driven by the changelog using [`cider`](https://pub.dev/packages/cider).
During development, record changes under the `## Unreleased` section of
`CHANGELOG.md` (manually, or with `dart run cider log added "..."`).

When ready, run the helper script. It bumps the version, promotes the
`Unreleased` section to the new version, commits and creates the `v<version>`
tag:

```bash
dart run tool/release.dart            # patch release (default)
dart run tool/release.dart minor      # or: major | patch | build | breaking | none
dart run tool/release.dart minor --push   # cut and push in one step
```

By default it does **not** push. Push the tag to publish:

```bash
git push --follow-tags
```

You can also run the **Release: …** entries in the VS Code Run & Debug panel.
Pushing a version tag triggers `.github/workflows/publish.yaml`, which publishes
to pub.dev (via GitHub OIDC, no secrets) and creates a GitHub release with notes
from the matching `CHANGELOG.md` section.

> One-time setup: on pub.dev go to the package admin page → *Automated
> publishing* → enable GitHub Actions publishing for
> `cgutierr-zgz/image_compare_slider` with the tag pattern `v{{version}}`.

[ci_badge]: https://github.com/cgutierr-zgz/image_compare_slider/actions/workflows/publish.yaml/badge.svg
[ci_link]: https://github.com/cgutierr-zgz/image_compare_slider/actions/workflows/publish.yaml
[pub_badge]: https://img.shields.io/pub/v/image_compare_slider.svg?label=image_compare_slider
[pub_link]: https://pub.dev/packages/image_compare_slider
[coverage_badge]: https://raw.githubusercontent.com/cgutierr-zgz/image_compare_slider/main/coverage_badge.svg
[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
