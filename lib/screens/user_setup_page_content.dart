import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:first_project/model/countries_data.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/auth_gate.dart';
import 'package:first_project/screens/homepage.dart';
import 'package:first_project/screens/profile_photo_picker_content.dart';
import 'package:first_project/screens/taken_from_firebaseui/email_auth_provider_firebaseUI.dart';
import 'package:first_project/screens/user_setup_page_content.dart';
import 'package:first_project/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/widgets.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserSetupPage extends StatefulWidget {
  @override
  _UserSetupPageState createState() => _UserSetupPageState();
}

class _UserSetupPageState extends State<UserSetupPage> {
  String? _selectedCountry;
  late String _selectedGender;
  late TextEditingController _nameController;
  bool _isButtonTapped = false;

  @override
  void initState() {
    super.initState();
    _selectedGender = 'm';
    _nameController = TextEditingController();
    _nameController.addListener(_checkButtonVisibility);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkButtonVisibility);
    _nameController.dispose();
    super.dispose();
  }

  void onGenderSelected(String genderKey) {
    setState(() {
      _selectedGender = genderKey;
    });
  }

  void onCountrySelected(String country) {
    setState(() {
      String emojiFlag = country.characters.first;
      final Map<String, String> emojiToCountry = allcountries.emojiToCountry;

      if (emojiToCountry.containsKey(emojiFlag)) {
        _selectedCountry = emojiToCountry[emojiFlag];
      } else {
        _selectedCountry = country;
      }
    });
  }

  void _checkButtonVisibility() {
    setState(() {
      _isButtonTapped = _nameController.text.isNotEmpty;
    });
    print("is button tapped is " + _isButtonTapped.toString());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    'About You',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(35),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'We will use this information to better tailor your listening experience',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      color: Colors.green.shade300,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'Name (required)',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      cursorColor: Colors.green,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(color: Colors.green),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 2.0,
                          ),
                        ),
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'Gender (optional)',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: GenderChoiceChip(onGenderSelected: onGenderSelected),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'Country (optional)',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: CountryDropdownMenu(
                      onCountrySelected: onCountrySelected),
                ),
                const SizedBox(height: 50),
                if (_isButtonTapped)
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding:
                            MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(16.0),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                      
                        QawlUser.updateCountry(_selectedCountry ?? ""); // Pass "" if _selectedCountry is null
                        QawlUser.updateGender(_selectedGender);
                        QawlUser.updateName(_nameController.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                      child: const Text('Next'),
                    ),
                  ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CountryDropdownMenu extends StatefulWidget {
  final void Function(String) onCountrySelected;
  final String? selectedCountry;

  const CountryDropdownMenu({
    Key? key,
    required this.onCountrySelected,
    this.selectedCountry,
  }) : super(key: key);

  @override
  _CountryDropdownMenuState createState() => _CountryDropdownMenuState();
}

class _CountryDropdownMenuState extends State<CountryDropdownMenu> {
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.selectedCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        hint: Text("Select a country"),
        decoration: const InputDecoration(
          filled: true,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green, // set the color to green
              width: 2.0, // set the width of the border
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
        value: _selectedCountry,
        onChanged: (String? newValue) {
          setState(() {
            _selectedCountry = newValue;
          });
          widget.onCountrySelected(newValue!);
        },
        items: allcountries.countries_new
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
