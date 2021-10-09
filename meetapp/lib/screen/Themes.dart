import 'package:flutter/material.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/widgets/CommonAppBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ColorSchemes { teal, violet, aqua, green, brown }

class Themes extends StatefulWidget {
  const Themes({Key? key}) : super(key: key);

  @override
  _ThemesState createState() => _ThemesState();
}

int? index;
ColorSchemes? _value;
bool RadioButtonPressed = false;

class _ThemesState extends State<Themes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (RadioButtonPressed == false) {
      final args = ModalRoute.of(context)!.settings.arguments;
      index = int.parse(args.toString());
    }
    if (index == 0)
      _value = ColorSchemes.teal;
    else if (index == 1)
      _value = ColorSchemes.violet;
    else if (index == 2)
      _value = ColorSchemes.aqua;
    else if (index == 3)
      _value = ColorSchemes.green;
    else if (index == 4) _value = ColorSchemes.brown;

    return Scaffold(
      appBar: CommonAppBar(
        title: "Themes",
        action: [],
      ),
      body: Container(
          child: Column(
        children: [
          ListTile(
            title: const Text('Teal'),
            leading: Radio(
                value: ColorSchemes.teal,
                groupValue: _value,
                onChanged: (ColorSchemes? value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt('index', 0);

                  setState(() {
                    index = 0;
                    _value = ColorSchemes.teal;
                    Provider.of<ColorUtils>(context, listen: false)
                        .getColorScheme(0);
                    RadioButtonPressed = true;
                  });
                }),
          ),
          ListTile(
            title: const Text('Violet'),
            leading: Radio(
                value: ColorSchemes.violet,
                groupValue: _value,
                onChanged: (ColorSchemes? value) async {
                  index = 1;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt('index', 1);

                  setState(() {
                    _value = ColorSchemes.violet;
                    Provider.of<ColorUtils>(context, listen: false)
                        .getColorScheme(1);
                    RadioButtonPressed = true;
                  });
                }),
          ),
          ListTile(
            title: const Text('Aqua'),
            leading: Radio(
                value: ColorSchemes.aqua,
                groupValue: _value,
                onChanged: (ColorSchemes? value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt('index', 2);

                  setState(() {
                    index = 2;
                    _value = ColorSchemes.aqua;
                    Provider.of<ColorUtils>(context, listen: false)
                        .getColorScheme(2);
                    RadioButtonPressed = true;
                  });
                }),
          ),
          ListTile(
            title: const Text('Green'),
            leading: Radio(
                value: ColorSchemes.green,
                groupValue: _value,
                onChanged: (ColorSchemes? value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt('index', 3);

                  setState(() {
                    index = 3;
                    _value = ColorSchemes.green;
                    Provider.of<ColorUtils>(context, listen: false)
                        .getColorScheme(3);
                    RadioButtonPressed = true;
                  });
                }),
          ),
          ListTile(
            title: const Text('Brown'),
            leading: Radio(
                value: ColorSchemes.brown,
                groupValue: _value,
                onChanged: (ColorSchemes? value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt('index', 4);

                  setState(() {
                    index = 4;
                    _value = ColorSchemes.brown;
                    Provider.of<ColorUtils>(context, listen: false)
                        .getColorScheme(4);
                    RadioButtonPressed = true;
                  });
                }),
          ),
        ],
      )),
    );
  }
}
