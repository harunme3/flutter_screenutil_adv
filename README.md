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

#### The first way (You should use it once in your app)

```dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: const HomePage(title: 'First Method'),
    );
  }
}
```

#### The second way:You need a trick to support font adaptation in the textTheme of app theme

**Hybrid development uses the second way**

not support this:

```dart
MaterialApp(
  ...
  //To support the following, you need to use the first initialization method
  theme: ThemeData(
    textTheme: TextTheme(
      button: TextStyle(fontSize: 45.sp)
    ),
  ),
)
```

but you can do this:

```dart
void main() async {
  // Add this line
  await ScreenUtil.ensureScreenSize();
  runApp(MyApp());
}
...
MaterialApp(
  ...
  builder: (ctx, child) {
    ScreenUtil.init(ctx);
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(bodyText2: TextStyle(fontSize: 30.sp)),
      ),
      child: HomePage(title: 'FlutterScreenUtil Demo'),
    );
  },
)
```

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter_ScreenUtil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'FlutterScreenUtil Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //Set the fit size (fill in the screen size of the device in the design)
    //If the design is based on the size of the 360*690(dp)
    ScreenUtil.init(context, designSize: const Size(360, 690));
    ...
  }
}
```

**Note: calling ScreenUtil.init second time, any non-provided parameter will not be replaced with default value. Use ScreenUtil.configure instead**

### API

#### Font Size Resolver Options

You can customize how font sizes are scaled using the `fontSizeResolver` parameter:

```dart
ScreenUtilInit(
  fontSizeResolver: FontSizeResolvers.scale,  // Default: scales with width (minTextAdapt affects this)
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

#### Pass the dp size of the design draft

```dart
    // Basic scaling methods
    ScreenUtil().setWidth(540)  (dart sdk>=2.6 : 540.w)   // Adapted to screen width
    ScreenUtil().setHeight(200) (dart sdk>=2.6 : 200.h)   // Adapted to screen height
    ScreenUtil().radius(200)    (dart sdk>=2.6 : 200.r)   // Adapt according to min(width, height)
    ScreenUtil().setSp(24)      (dart sdk>=2.6 : 24.sp)   // Adapter font
    12.spMin   // return min(12, 12.sp)
    12.spMax   // return max(12, 12.sp)

    // New scaling methods
    ScreenUtil().diagonal(100)  (dart sdk>=2.6 : 100.dg)  // Scale based on diagonal (√(width² + height²))
    ScreenUtil().area(100)      (dart sdk>=2.6 : 100.ar)  // Scale based on area (width * height)
    ScreenUtil().diameter(100)  (dart sdk>=2.6 : 100.dm)  // Scale based on max(width, height)

    // Device information
    ScreenUtil().pixelRatio       // Device pixel density
    ScreenUtil().screenWidth   (dart sdk>=2.6 : 1.sw)    // Device width
    ScreenUtil().screenHeight  (dart sdk>=2.6 : 1.sh)    // Device height
    ScreenUtil().bottomBarHeight  // Bottom safe zone distance
    ScreenUtil().statusBarHeight  // Status bar height, Notch will be higher
    ScreenUtil().textScaleFactor  // System font scaling factor

    ScreenUtil().scaleWidth   // The ratio of actual width to UI design
    ScreenUtil().scaleHeight  // The ratio of actual height to UI design

    ScreenUtil().orientation  // Screen orientation

    // Convenience extensions
    0.2.sw  // 0.2 times the screen width
    0.5.sh  // 50% of screen height
    20.verticalSpace    // SizedBox(height: 20 * scaleHeight)
    20.horizontalSpace  // SizedBox(width: 20 * scaleWidth)

    // EdgeInsets extensions
    EdgeInsets.all(10).w    // EdgeInsets.all(10.w)
    EdgeInsets.all(10).h    // EdgeInsets.all(10.h)
    EdgeInsets.all(10).r    // EdgeInsets.all(10.r)
    EdgeInsets.all(10).dg   // EdgeInsets.all(10.dg) - diagonal
    EdgeInsets.all(10).ar   // EdgeInsets.all(10.ar) - area
    EdgeInsets.all(10).dm   // EdgeInsets.all(10.dm) - diameter

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

#### Adapt screen size

Pass the dp size of the design draft((The unit is the same as the unit at initialization))：

Adapted to screen width: `ScreenUtil().setWidth(540)`,

Adapted to screen height: `ScreenUtil().setHeight(200)`, In general, the height is best to adapt to the width

If your dart sdk>=2.6, you can use extension functions:

example:

instead of :

```dart
Container(
  width: ScreenUtil().setWidth(50),
  height:ScreenUtil().setHeight(200),
)
```

you can use it like this:

```dart
Container(
  width: 50.w,
  height:200.h
)
```

#### `Note`

The height can also use setWidth to ensure that it is not deformed (when you want a square).

The setHeight method is mainly to adapt to the height, which is used when you want to control the height of a screen on the UI to be the same as the actual display.

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

#### Adapter font

```dart
//Incoming font size(The unit is the same as the unit at initialization)
ScreenUtil().setSp(28)
28.sp

//for example:
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    Text(
      '16sp, will not change with the system.',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
      ),
      textScaleFactor: 1.0,
    ),
    Text(
      '16sp,if data is not set in MediaQuery,my font size will change with the system.',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
      ),
    ),
  ],
)
```

#### Setting font does not change with system font size

APP global:

```dart
MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Flutter_ScreenUtil',
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  builder: (context, widget) {
    return MediaQuery(
      ///Setting font does not change with system font size
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: widget,
    );
  },
  home: HomePage(title: 'FlutterScreenUtil Demo'),
),
```

Specified Text:

```dart
Text("text", textScaleFactor: 1.0)
```

Specified Widget:

```dart
MediaQuery(
  // If there is no context available you can wrap [MediaQuery] with [Builder]
  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
  child: AnyWidget(),
)
```

[widget test](https://github.com/OpenFlutter/flutter_screenutil/issues/115)

## New Features

This simplified version includes the following enhancements:

### Additional Scaling Methods

1. **Diagonal Scaling (`diagonal()` / `.dg`)**: Scales based on the diagonal of the screen using the formula `√(width² + height²)`. This provides a balanced scaling that considers both dimensions proportionally.

2. **Area Scaling (`area()` / `.ar`)**: Scales based on the area (width × height). Useful when you want scaling to be more aggressive on larger screens.

3. **Diameter Scaling (`diameter()` / `.dm`)**: Scales based on the maximum of width or height. Opposite of radius scaling.

### FontSizeResolver Options

The `fontSizeResolver` parameter now supports multiple scaling strategies:

- `FontSizeResolvers.scale` (default) - Uses scaleText with minTextAdapt consideration
- `FontSizeResolvers.width` - Scales font based on width
- `FontSizeResolvers.height` - Scales font based on height
- `FontSizeResolvers.radius` - Scales font based on min(width, height)
- `FontSizeResolvers.diameter` - Scales font based on max(width, height)
- `FontSizeResolvers.diagonal` - Scales font based on diagonal
- `FontSizeResolvers.area` - Scales font based on area

### Performance Improvements

- Pre-calculated diagonal scale for better performance
- Optimized rebuild mechanism to only update necessary widgets

## Testing

When conducting widget tests, ensure you use `tester.pumpAndSettle()` to allow widgets to complete their initialization:

```dart
testWidgets('Should ensure widgets settle correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: ScreenUtilInit(
        child: MyApp(),
      ),
    ),
  );
  // Wait for widgets to settle
  await tester.pumpAndSettle();
  // Continue with your assertions and tests
});
```

## Credits

Based on [flutter_screenutil](https://github.com/OpenFlutter/flutter_screenutil) by OpenFlutter.  
Simplified and enhanced by Rahul Kumar Gupta.
