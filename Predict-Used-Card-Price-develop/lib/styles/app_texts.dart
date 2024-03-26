import 'package:flutter/material.dart';

class AppTexts {
  AppTexts._();
  static const String appName = 'Predict Used Car Price';
  static const String homeTitle = 'Car Hub';

  //form names
  static const String modelName = 'car_model';
  static const String brandName = 'brand';
  static const String yearName = 'model_year';
  static const String bodyTypeName = 'body_type';
  static const String transmissionName = 'transmission';
  static const String fuelTypeName = 'fuel_type';
  static const String engineCapacityName = 'engine_capacity';
  static const String millageName = 'kilometers_run';

  //input labels
  static const String modelLabel = 'Select Car Model';
  static const String brandLabel = 'Select Brand';
  static const String yearLabel = 'Model Year';
  static const String bodyTypeLabel = 'Body Type';
  static const String transmissionLabel = 'Select Transmission';
  static const String fuelTypeLabel = 'Fuel Type';
  static const String engineCapacityLabel = 'Enter Engine Capacity';
  static const String millageLabel = 'Enter Millage';
  static const String predictLabel = 'PREDICT PRICE';
  static const String buyLabel = 'BUY';
  static const String sellLabel = 'SELL';
  static const String signOutLabel = 'Sign Out';


  //Configurations
  static const String apiURL = 'http://192.168.0.107:3000/get-prediction/'; // for real device 'http://{your_ipv4_address}:3000/get-prediction/'
  // static const String apiURL = 'http://10.0.2.2:3000/get-prediction/'; // for emulator
  static const String fbURL = 'https://www.facebook.com/rohan.redwan';//SET your facebook url here
  static const String twitterURL = ' ';//SET your twitter url here
  static const String linkedinURL = ' ';//SET your linkedin url here
  static const String githubURL = ' ';//SET your github url here





}
