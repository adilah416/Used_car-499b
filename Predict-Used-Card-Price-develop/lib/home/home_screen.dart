import 'dart:async';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:predict_used_car_price/predict_price/predict_price_screen.dart';
import 'package:predict_used_car_price/styles/app_texts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:predict_used_car_price/data/data.dart' as data;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppinioSwiperController controller = AppinioSwiperController();
  final List<String> imagesPath = data.DataClass.images;
  final ButtonStyle buttonStyle = ButtonStyle(
    fixedSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]!),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: const BorderSide(color: Colors.white),
      ),
    ),
  );
  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    // fontWeight: FontWeight.w300,
  );
  bool _shouldRunAnimation = true;
  bool _forwardAnimation = true;
  int currentIndex = 0;
  late Timer swipeTimer;

  @override
  void initState() {
    super.initState();
    _runAnimation();
    print('max size = ${imagesPath.length}');
  }

  @override
  dispose() {
    _shouldRunAnimation = false;
    super.dispose();
  }

  // Future<void> _runAnimation() async {
  //   while (_shouldRunAnimation) {
  //     swipeTimer = await Future.delayed(const Duration(seconds: 5));
  //     if (_forwardAnimation) {
  //       print('swipe right');
  //       controller.swipeRight();
  //     } else {
  //       print('unswipe');
  //       controller.unswipe();
  //     }
  //   }
  // }
  Future<void> _runAnimation() async {
    swipeTimer = Timer.periodic(data.DataClass.animationDuration, (timer) {
      if (!_shouldRunAnimation) {
        timer.cancel(); // Stop the timer when _shouldRunAnimation is false
      } else if (_forwardAnimation) {
        print('swipe right');
        controller.swipeRight();
      } else {
        print('unswipe');
        controller.unswipe();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        if (swipeTimer.isActive) {
          swipeTimer.cancel();
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal[200]),
          title: const Text(
            AppTexts.homeTitle,
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey[700],
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async => await FirebaseAuth.instance.signOut(),
              child: const Text(AppTexts.signOutLabel, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                _shouldRunAnimation = false;
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const PredictPrice()))
                    .then((value) {
                  _shouldRunAnimation = true;
                  _runAnimation();
                });
              },
              style: buttonStyle,
              child: Text(
                AppTexts.predictLabel,
                style: textStyle,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: null,
              style: buttonStyle,
              child: Text(
                AppTexts.buyLabel,
                style: textStyle,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: null,
              style: buttonStyle,
              child: Text(
                AppTexts.sellLabel,
                style: textStyle,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AppinioSwiper(
                cardsBuilder: (context, int index) => index == currentIndex
                    ? Image.asset(
                        imagesPath[index],
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        height: 500,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Image.asset(imagesPath[index]),
                      ),
                unlimitedUnswipe: true,
                onSwipe: (int index, direction) {
                  print(index);
                  currentIndex++;
                  if (_forwardAnimation && currentIndex == imagesPath.length - 1) {
                    _forwardAnimation = false;
                  }
                },
                unswipe: (_) {
                  print('at unswipe ${currentIndex - 1}');
                  currentIndex--;
                  if (_forwardAnimation == false && currentIndex <= 0) {
                    _forwardAnimation = true;
                  }
                },
                cardsCount: imagesPath.length,
                backgroundCardsCount: 1,
                controller: controller,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: footer(),
            ),
            const SizedBox(height: 5),
          ],
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

  void _launchUrl(String _url) async {
    final Uri url = Uri.parse(_url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
