# Image Compare Slider

[![ci][ci_badge]][ci_link] [![pub package][pub_badge]][pub_link] ![Coverage badge][coverage_badge] [![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link] [![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason) [![License: MIT][license_badge]][license_link]

Inspired by [react-compare-slider](https://www.npmjs.com/package/react-compare-slider), this package allows you to easily compare two images with a slider.

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
  itemOne: const AssetImage('assets/images/render.png'),
  itemTwo: const AssetImage('assets/images/render_oc.png'),
)
//...
```


The widget its pretty simple and customizable, see:
_If you want it to style it with a custom border/padding, just wrap it with a `Container` and set the desired properties._

![Example](https://github.com/cgutierr-zgz/image_compare_slider/blob/main/screenshots/video.gif)

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
