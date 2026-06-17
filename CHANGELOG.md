# Changelog
## 3.0.1 - 2026-06-17
## 3.0.0 - 2026-06-17
### Added
- **Zoom & pan** — `zoomable`/`pannable` pinch, drag and double-tap zoom applied to both images at once (closes #17).
- **Rotation with lock** — new `ImageCompareSliderController` rotates either image in either direction, with `lockRotation` to rotate both together; also drives zoom, pan, position and `reset()` (closes #22).
- **Custom handle** — `handleBuilder` replaces the painted handle with any draggable widget (closes #2).
- **Match image sizes** — `fit` + `aspectRatio` force differently-sized images into the same box (closes #15).
- `onlyHandleDraggable`, `minScale`, `maxScale`, `doubleTapToZoom`, `doubleTapScale`, `enableGestureRotation`.

### Changed
- **BREAKING:** bumps the SDK constraint to `>=3.0.0 <4.0.0` (requires Dart 3 / Flutter 3.10+). The public API is otherwise backwards compatible.

## 2.8.0 - 2023-08-02
### Added
- `handleColor` and `handleOutlineColor` to customize the handle color and outline color.

## 2.7.0 - 2023-03-14
### Added
- `photoRadius` to customize the radius of the images.

### Fixed
- `itemBuilderOne` and `itemBuilderTwo` now receive `context` as a parameter.

## 2.6.0 - 2023-03-06
### Fixed
- Handle being painted relative to the parent widget instead of the canvas.

## 2.5.0 - 2023-02-27
### Changed
- `handleSize` changed from `double` to `Size` to customize the handle width and height independently.

## 2.4.0 - 2023-02-22
### Added
- `handleFollowsPosition` to let the handle follow the position of the slider.

## 2.3.0+3 - 2023-02-22
### Fixed
- Updates screenshots.

## 2.3.0+2 - 2023-02-22
### Fixed
- Updates `README.md`.

## 2.3.0+1 - 2023-02-22
### Fixed
- Updates `README.md`.

## 2.3.0 - 2023-02-22
### Changed
- `ImageProvider<Object>` replaced by `Image`, to allow custom color/blendMode directly by the user.
- Renames `wrapper` to `itemOneBuilder` and `itemTwoBuilder`.

### Fixed
- Slider now clips both images, each one with its own direction.

## 2.2.0 - 2023-02-21
### Added
- Improved documentation and a new example.

### Changed
- `imageFilter`/`ColorFilter` replaced by `itemWrapper` to allow customizing both items directly.

## 2.1.0 - 2023-02-21
### Added
- `ImageFilter`, `ColorFilter`, `Color` and `BlendMode` for both images.

### Changed
- Renames `handleRadius` to `handleSize` and adds `handleRadius` to customize the radius of the handle.

## 2.0.1 - 2023-02-21
### Fixed
- Changes `Stack` fit to `passthrough`.

## 2.0.0+1 - 2023-02-20
### Fixed
- Pipeline updates.

## 2.0.0 - 2023-02-20
### Added
- `handleRadius`, `fillHandle`, `hideHandle` and `handlePosition`.

### Removed
- The `imageWidth` and `imageHeight` parameters.
- The custom handler.

## 1.0.0 - 2023-02-20
### Added
- Initial release 🎉
