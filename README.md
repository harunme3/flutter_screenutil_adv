# flutter_screenutil

**A flutter plugin for adapting screen and font size. Let your UI display a reasonable layout on different screen sizes!**

_Note_: This is a simplified and enhanced version with additional scaling methods.

## Usage

### Add dependency

Please check the latest version before installation.
If there is any problem with the new version, please use the previous version

```yaml
dependencies:
  flutter:
    sdk: flutter
  # add flutter_screenutil
  flutter_screenutil: ^{latest version}
```

### Add the following imports to your Dart code

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
```

### Properties

| Property          | Type             | Default Value           | Description                                                                                                                                   |
| ----------------- | ---------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| designSize        | Size             | Size(360,690)           | The size of the device screen in the design draft, in dp                                                                                      |
| builder           | Function         | null                    | Return widget that uses the library in a property (ex: MaterialApp's theme)                                                                   |
| child             | Widget           | null                    | A part of builder that its dependencies/properties don't use the library                                                                      |
| rebuildFactor     | Function         | RebuildFactors.size     | Function that take old and new screen metrics and returns whether to rebuild or not when changes.                                             |
| splitScreenMode   | bool             | true                    | Support for split screen                                                                                                                      |
| minTextAdapt      | bool             | true                    | Whether to adapt the text according to the minimum of width and height                                                                        |
| fontSizeResolver  | FontSizeResolver | FontSizeResolvers.scale | Function that specifies how font size should be adapted. Available: `scale`, `width`, `height`, `radius`, `diameter`, `diagonal`, `area`      |
| responsiveWidgets | Iterable<String> | null                    | List/Set of widget names that should be included in rebuilding tree. (See [How flutter_screenutil marks a widget needs build](#rebuild-list)) |
| excludeWidgets    | Iterable<String> | null                    | List/Set of widget names that should be excluded from rebuilding tree.                                                                        |
| ensureScreenSize  | bool             | true                    | Ensures screen size is initialized before building widgets                                                                                    |

**Note : You must either provide builder, child or both.**

### Rebuild list

ScreenUtilInit won't rebuild the whole widget tree, instead it will mark widget needs build only if:

- Widget is not a flutter widget (widgets are available in [Flutter Docs](https://docs.flutter.dev/reference/widgets))
- Widget does not start with underscore (`_`)
- Widget does not declare `SU` mixin
- `responsiveWidgets` does not contains widget name

If you have a widget that uses the library and doesn't meet these options you can either add `SU` mixin or add widget name in responsiveWidgets list.

### Initialize and set the fit size and font size to scale according to the system's "font size" accessibility option

Please set the size of the design draft before use, the width and height of the design draft.

```dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in, unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          home: child,
        );
      },
      child: const HomePage(title: 'First Method'),
    );
  }
}
```

### API

#### Font Size Resolver Options

You can customize how font sizes are scaled using the `fontSizeResolver` parameter:

```dart
ScreenUtilInit(
  fontSizeResolver: FontSizeResolvers.scale,  // Default: scales with minimum of width and height (minTextAdapt affects this)
  // Other options:
  // fontSizeResolver: FontSizeResolvers.width,     // Scale based on width
  // fontSizeResolver: FontSizeResolvers.height,    // Scale based on height
  // fontSizeResolver: FontSizeResolvers.radius,    // Scale based on min(width, height)
  // fontSizeResolver: FontSizeResolvers.diameter,  // Scale based on max(width, height)
  // fontSizeResolver: FontSizeResolvers.diagonal,  // Scale based on diagonal
  // fontSizeResolver: FontSizeResolvers.area,      // Scale based on area (width * height)
  //...
)
```

#### Extension Examples

```dart
// Basic scaling extensions
540.w       // Adapted to screen width
200.h       // Adapted to screen height
200.r       // Adapt according to min(width, height)
24.sp       // Adapter font
12.spMin    // return min(12, 12.sp)
12.spMax    // return max(12, 12.sp)

// New scaling extensions
100.dg      // Scale based on diagonal (√(width² + height²))
100.ar      // Scale based on area (width * height)
100.dm      // Scale based on max(width, height)

// Device information
1.sw        // Screen width
1.sh        // Screen height
0.2.sw      // 0.2 times the screen width
0.5.sh      // 50% of screen height

// Spacing
20.verticalSpace      // SizedBox(height: 20.h)
20.horizontalSpace    // SizedBox(width: 20.w)

// EdgeInsets extensions
EdgeInsets.all(10).w    // Width-based
EdgeInsets.all(10).h    // Height-based
EdgeInsets.all(10).r    // Radius-based
EdgeInsets.all(10).dg   // Diagonal-based
EdgeInsets.all(10).ar   // Area-based
EdgeInsets.all(10).dm   // Diameter-based

// BorderRadius extensions
BorderRadius.all(Radius.circular(16)).w   // Width-based
BorderRadius.all(Radius.circular(16)).h   // Height-based
BorderRadius.all(Radius.circular(16)).r   // Radius-based

// Radius extensions
Radius.circular(16).w   // Width-based
Radius.circular(16).h   // Height-based
Radius.circular(16).r   // Radius-based
Radius.circular(16).dg  // Diagonal-based
Radius.circular(16).ar  // Area-based
Radius.circular(16).dm  // Diameter-based

// BoxConstraints extensions
BoxConstraints(maxWidth: 100, minHeight: 100).w    // Width-based
BoxConstraints(maxWidth: 100, minHeight: 100).h    // Height-based
BoxConstraints(maxWidth: 100, minHeight: 100).r    // Radius-based
BoxConstraints(maxWidth: 100, minHeight: 100).hw   // Height-Width mixed
```

#### `Note`

Height and width scale differently. Use the same extension for both dimensions when you want a square.

Generally speaking, `50.w != 50.h`.

```dart
// Examples:

// Rectangle (different width and height scaling):
Container(
  width: 375.w,
  height: 375.h,
),

// Square based on width:
Container(
  width: 300.w,
  height: 300.w,
),

// Square based on height:
Container(
  width: 300.h,
  height: 300.h,
),

// Square based on minimum(width, height):
Container(
  width: 300.r,
  height: 300.r,
),

// Square based on diagonal scaling:
Container(
  width: 300.dg,
  height: 300.dg,
),

// Square based on area scaling:
Container(
  width: 300.ar,
  height: 300.ar,
),

// Square based on maximum(width, height):
Container(
  width: 300.dm,
  height: 300.dm,
),
```

## New Features & Fixes

This simplified version includes the following enhancements:

### Additional Scaling Methods

1. **Diagonal Scaling (`diagonal()` / `.dg`)**: Scales based on the diagonal of the screen using the formula `√(width² + height²)`. This provides a balanced scaling that considers both dimensions proportionally.

2. **Area Scaling (`area()` / `.ar`)**: Scales based on the area (width × height). Useful when you want scaling to be more aggressive on larger screens.

3. **Diameter Scaling (`diameter()` / `.dm`)**: Scales based on the maximum of width or height. Opposite of radius scaling.

### Split Screen Mode

**`splitScreenMode`**: When enabled (default: `true`), uses the maximum of actual screen height or design height for height scaling. This ensures proper scaling in split-screen scenarios where the available height might be less than expected.

Formula: `scaleHeight = max(screenHeight, designHeight) / designHeight`

### FontSizeResolver Options

The `fontSizeResolver` parameter now supports multiple scaling strategies:

- `FontSizeResolvers.scale` (default) - Uses scaleText with minTextAdapt consideration
- `FontSizeResolvers.width` - Scales font based on width
- `FontSizeResolvers.height` - Scales font based on height
- `FontSizeResolvers.radius` - Scales font based on min(width, height)
- `FontSizeResolvers.diameter` - Scales font based on max(width, height)
- `FontSizeResolvers.diagonal` - Scales font based on diagonal
- `FontSizeResolvers.area` - Scales font based on area

### Fixes

- Removed hardcoded value 700 from split screen mode for more flexible height calculations

### Performance Improvements

- Pre-calculated diagonal scale for better performance
- Optimized rebuild mechanism to only update necessary widgets

## Credits

Based on [flutter_screenutil](https://github.com/OpenFlutter/flutter_screenutil) by OpenFlutter.  
Simplified and enhanced by Rahul Kumar Gupta.
