import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // important
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart'; // important

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale defaultLocale = const Locale('en', 'US');
  late Locale _appLocale;

  @override
  void initState() {
    super.initState();
    _appLocale = defaultLocale;
    //initAppLocale();
  }

  Future<void> initAppLocale() async {
    _appLocale = Locale(await getLocaleFromPreferences());
  }

  void setLocale(Locale value) {
    setState(() {
      _appLocale = value;
    });
  }

  Future<String> getLocaleFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLocale = prefs.getString('localeLangCode');
    if (lastLocale == null) {
      print("lastlocale234: $lastLocale");
      return "";
    }
    return lastLocale;
  }

  Future<void> updateAppLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    String lastLocale = await getLocaleFromPreferences();
    print("last Locale: $lastLocale");
    prefs.setString('localeLangCode', newLocale.languageCode);
    // setState(() {
    //   _appLocale = Locale(lastLocale);
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('curr locale: $_appLocale');
    return MaterialApp(
      locale: _appLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English, no country code
        Locale('hi', 'IN'), // Hindi, no country code
        Locale('ar', 'AE'), // Arabic, no country code
        Locale('tr', 'TR'), // Turkish, no country code
      ],
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final List allLocales = const [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'Hindi', 'locale': Locale('hi', 'IN')},
    {'name': 'Arabic', 'locale': Locale('ar', 'AE')},
    {'name': 'Turkish', 'locale': Locale('tr', 'TR')},
  ];

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text('Choose Your Language'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(allLocales[index]['name']),
                        onTap: () {
                          //print(allLocales[index]['name']);
                          MyApp.of(context)
                              ?.setLocale(allLocales[index]['locale']);
                          MyApp.of(context)
                              ?.updateAppLocale(allLocales[index]['locale']);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.blue,
                    );
                  },
                  itemCount: allLocales.length),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.i18nAppTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.language_outlined),
              tooltip: 'Change Language',
              onPressed: () {
                buildLanguageDialog(context);
              },
            ),
            // IconButton(
            //   icon: SvgPicture.asset("assets/icons/language.svg",
            //       color: Colors.red, semanticsLabel: 'Label'),
            //   onPressed: () {},
            // ),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.helloWorld,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.helloUserMessage("Batman"),
                style: const TextStyle(fontSize: 20),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     buildLanguageDialog(context);
              //   },
              //   child: const Text('Change Language'),
              // ),
            ],
          ),
        ));
  }
}
