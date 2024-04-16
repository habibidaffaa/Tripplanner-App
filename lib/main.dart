import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iterasi1/pages/itinerary_list.dart';
import 'package:iterasi1/pages/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:iterasi1/provider/database_provider.dart';
import 'package:iterasi1/provider/itinerary_provider.dart';
import 'package:iterasi1/resource/custom_colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set the SystemChrome
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => DatabaseProvider()),
              ChangeNotifierProvider(create: (_) => ItineraryProvider())
            ],
            child: MaterialApp(
              home: const SplashScreen(),
              debugShowCheckedModeBanner: false,
              routes: {
                ItineraryList.route: (context) => ItineraryList(),
              },
              theme: ThemeData(
                primaryColor: CustomColor.primary,
                progressIndicatorTheme:
                    ProgressIndicatorThemeData(color: CustomColor.primary),
              ),
            ),
          );
        });
  }
}
