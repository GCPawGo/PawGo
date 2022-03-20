import 'package:pawgo/assets/custom_colors.dart';
import 'package:pawgo/size_config.dart';
import 'package:pawgo/utils/mobile_library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Conditional().initFireBase();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData().copyWith(
              colorScheme: ColorScheme.light(
                primary: CustomColors.pawrange,
              ),
              textSelectionTheme: TextSelectionThemeData(
                  selectionColor: CustomColors.pawrange,
                  cursorColor: Colors.white,
                  selectionHandleColor: CustomColors.pawrange),
            ),
            routes: Conditional().routes,
            home: Conditional().startPage,
          );
        },
      );
    });
  }
}
