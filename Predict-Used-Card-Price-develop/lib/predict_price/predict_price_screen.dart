import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:predict_used_car_price/auth/widget_tree.dart';
import 'package:predict_used_car_price/data/data.dart';
import 'package:predict_used_car_price/styles/app_texts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:predict_used_car_price/auth/auth.dart';
import 'package:url_launcher/url_launcher.dart';

class PredictPrice extends StatefulWidget {
  const PredictPrice({super.key});

  @override
  State<PredictPrice> createState() => _PredictPriceState();
}

class _PredictPriceState extends State<PredictPrice> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    Auth().signOut().then((value) => Navigator.popUntil(context, (route) => route.isFirst));
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User Email');
  }

  final ValueNotifier<bool> fetching = ValueNotifier<bool>(false);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  static const double tilePadding = 20;
  final TextStyle labelStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );
  final TextStyle floatingLabelStyle = const TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  final TextStyle selectedStyle = TextStyle(
    color: Colors.amber[50],
    fontSize: 12,
    // fontWeight: FontWeight.w300,
  );
  final TextStyle submitTextStyle =  TextStyle(
    color: Colors.teal[200],
    fontSize: 12,
    // fontWeight: FontWeight.w300,
  );
  final ButtonStyle submitButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: const BorderSide(color: Colors.teal),
      ),
    ),
  );
  Color? dropDownColor = Colors.blueGrey[700];
  Icon dropDownIcon = const Icon(
    Icons.arrow_drop_down,
    color: Colors.white,
  );

  Widget _signOutButton() {
    return TextButton(
      // onPressed: () async => await FirebaseAuth.instance.signOut(),
      onPressed: signOut,
      child: const Text(
        AppTexts.signOutLabel,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void initState() {
    print(user?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          AppTexts.appName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          _signOutButton(),
        ],
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Container(
        color: Colors.blueGrey[900],
        height: double.infinity,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
            Expanded(
            flex: 10,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: <Widget>[
                  FormBuilderDropdown(
                    icon: dropDownIcon,
                    name: AppTexts.modelName,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                    dropdownColor: dropDownColor,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppTexts.modelLabel,
                      contentPadding: const EdgeInsets.all(2),
                      labelStyle: labelStyle,
                      floatingLabelStyle: floatingLabelStyle,
                    ),
                    items: DataClass.models
                        .map((model) => DropdownMenuItem(
                      value: model,
                      child: Text(model, style: selectedStyle),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: tilePadding),
                  FormBuilderDropdown(
                    icon: dropDownIcon,
                    name: AppTexts.brandName,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                    dropdownColor: dropDownColor,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppTexts.brandLabel,
                      contentPadding: const EdgeInsets.all(2),
                      labelStyle: labelStyle,
                      floatingLabelStyle: floatingLabelStyle,
                    ),
                    items: DataClass.brands
                        .map((brand) => DropdownMenuItem(
                      value: brand,
                      child: Text(brand, style: selectedStyle),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: tilePadding),
                  FormBuilderDropdown(
                    icon: dropDownIcon,
                    name: AppTexts.yearName,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                    dropdownColor: dropDownColor,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppTexts.yearLabel,
                      contentPadding: const EdgeInsets.all(2),
                      labelStyle: labelStyle,
                      floatingLabelStyle: floatingLabelStyle,
                    ),
                    items: DataClass.modelYears
                        .map((modelYear) => DropdownMenuItem(
                      value: modelYear,
                      child: Text(modelYear, style: selectedStyle),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: tilePadding),
                  FormBuilderDropdown(
                    icon: dropDownIcon,
                    name: AppTexts.bodyTypeName,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                    dropdownColor: dropDownColor,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppTexts.bodyTypeLabel,
                      contentPadding: const EdgeInsets.all(2),
                      labelStyle: labelStyle,
                      floatingLabelStyle: floatingLabelStyle,
                    ),
                    items: DataClass.bodyTypes
                        .map((bodyType) => DropdownMenuItem(
                      value: bodyType,
                      child: Text(bodyType, style: selectedStyle),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: tilePadding),
                  FormBuilderDropdown(
                    icon: dropDownIcon,
                    name: AppTexts.transmissionName,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                    dropdownColor: dropDownColor,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppTexts.transmissionLabel,
                      contentPadding: const EdgeInsets.all(2),
                      labelStyle: labelStyle,
                      floatingLabelStyle: floatingLabelStyle,
                    ),
                    items: DataClass.transmissions
                        .map((transmission) => DropdownMenuItem(
                      value: transmission,
                      child: Text(transmission, style: selectedStyle),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: tilePadding),
                  FormBuilderDropdown(
                    icon: dropDownIcon,
                    name: AppTexts.fuelTypeName,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                    dropdownColor: dropDownColor,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppTexts.fuelTypeLabel,
                      contentPadding: const EdgeInsets.all(2),
                      labelStyle: labelStyle,
                      floatingLabelStyle: floatingLabelStyle,
                    ),
                    items: DataClass.fuelType
                        .map((fuelType) => DropdownMenuItem(
                      value: fuelType,
                      child: Text(fuelType, style: selectedStyle),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: tilePadding),
                  FormBuilderTextField(
                    name: AppTexts.engineCapacityName,
                    // Field name used to access the value
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(0),
                    ]),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppTexts.engineCapacityLabel,
                      contentPadding: const EdgeInsets.all(2),
                      labelStyle: labelStyle,
                      floatingLabelStyle: floatingLabelStyle,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: tilePadding),
                  FormBuilderTextField(
                    name: AppTexts.millageName,
                    // Field name used to access the value
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(0),
                    ]),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppTexts.millageLabel,
                      contentPadding: const EdgeInsets.all(2),
                      labelStyle: labelStyle,
                      floatingLabelStyle: floatingLabelStyle,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: tilePadding),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        style: submitButtonStyle,
                        onPressed: getData,
                        child: Text(
                          AppTexts.predictLabel,
                          style: submitTextStyle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: tilePadding,
                  ),
                  ValueListenableBuilder(
                      valueListenable: fetching,
                      builder: (context, value, child) {
                        return value
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GNav(
                  rippleColor: Colors.grey,
                  hoverColor: Colors.grey,
                  haptic: true,
                  tabBorderRadius: 15,
                  tabActiveBorder: Border.all(color: Colors.black, width: 1),
                  tabBorder: Border.all(color: Colors.grey, width: 1),
                  tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)],
                  curve: Curves.easeOutExpo,
                  duration: const Duration(milliseconds: 900),
                  gap: 8,
                  color: Colors.grey[800],
                  iconSize: 24,
                  tabBackgroundColor: Colors.purple.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  // navigation bar padding
                  tabs: [
                    GButton(
                      icon: Icons.facebook,
                      text: 'Facebook',
                      onPressed: () async {
                        _launchUrl(AppTexts.fbURL);
                      },
                    ),
                    GButton(
                      icon: FontAwesomeIcons.twitter,
                      text: 'Twitter',
                      onPressed: () async {
                        _launchUrl(AppTexts.twitterURL);
                      },
                    ),
                    GButton(
                      icon: FontAwesomeIcons.linkedin,
                      text: 'LinkedIn',
                      onPressed: () async {
                        _launchUrl(AppTexts.linkedinURL);
                      },
                    ),
                    GButton(
                      icon: FontAwesomeIcons.github,
                      text: 'Github',
                      onPressed: () async {
                        _launchUrl(AppTexts.githubURL);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget footer() {
    return GNav(
      rippleColor: Colors.grey,
      hoverColor: Colors.grey,
      haptic: true,
      tabBorderRadius: 15,
      tabActiveBorder: Border.all(color: Colors.black, width: 1),
      tabBorder: Border.all(color: Colors.grey, width: 1),
      tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)],
      curve: Curves.easeOutExpo,
      duration: const Duration(milliseconds: 900),
      gap: 8,
      color: Colors.grey[800],
      iconSize: 24,
      tabBackgroundColor: Colors.purple.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      // navigation bar padding
      tabs: [
        GButton(
          icon: Icons.facebook,
          text: 'Facebook',
          onPressed: () async {
            _launchUrl(AppTexts.fbURL);
          },
        ),
        GButton(
          icon: FontAwesomeIcons.twitter,
          text: 'Twitter',
          onPressed: () async {
            _launchUrl(AppTexts.twitterURL);
          },
        ),
        GButton(
          icon: FontAwesomeIcons.linkedin,
          text: 'LinkedIn',
          onPressed: () async {
            _launchUrl(AppTexts.linkedinURL);
          },
        ),
        GButton(
          icon: FontAwesomeIcons.github,
          text: 'Github',
          onPressed: () async {
            _launchUrl(AppTexts.githubURL);
          },
        ),
      ],
    );
  }

  void getData() async {
    if (_formKey.currentState!.saveAndValidate()) {
      try {
        fetching.value = true;
        final response = await http.post(
          Uri.parse(AppTexts.apiURL),
          body: {
            AppTexts.modelName: _formKey.currentState!.fields[AppTexts.modelName]!.value,
            AppTexts.brandName: _formKey.currentState!.fields[AppTexts.brandName]!.value,
            AppTexts.yearName: _formKey.currentState!.fields[AppTexts.yearName]!.value,
            AppTexts.bodyTypeName: _formKey.currentState!.fields[AppTexts.bodyTypeName]!.value,
            AppTexts.transmissionName:
            _formKey.currentState!.fields[AppTexts.transmissionName]!.value,
            AppTexts.fuelTypeName: _formKey.currentState!.fields[AppTexts.fuelTypeName]!.value,
            AppTexts.engineCapacityName:
            _formKey.currentState!.fields[AppTexts.engineCapacityName]!.value,
            AppTexts.millageName: _formKey.currentState!.fields[AppTexts.millageName]!.value,
          },
        );
        if (response.statusCode == 200) {
          fetching.value = false;
          final int price = json.decode(response.body);
          if (context.mounted) {
            _showPrediction(context, price);
          }
        }
      } catch (e) {
        fetching.value = false;
        print(e);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bad Gateway! Error: $e')),
          );
        }
      }
    } else {
      print('invalid data');
    }
  }

  void _showPrediction(BuildContext context, int price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          title: Center(
              child: Text(
                'Prediction: $price BDT',
                style: const TextStyle(fontSize: 18, color: Colors.amber),
              )),
          actions: <Widget>[
            Image.asset('assets/car.png'),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Center(child: Text('Close')),
            ),
          ],
        );
      },
    );
  }

  void _launchUrl(String _url) async {
    final Uri url = Uri.parse(_url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}