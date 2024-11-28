import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/svgs.dart';
import 'auth/auth_gate.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return const AuthGate();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height / 2,
            child: SvgPicture.asset(
              AssetsSvgs.appIcon,
              height: 80,
            )),
        const Center(
          child: Text(
            "VNR GEOLOCATION",
            style: TextStyle(fontSize: 16, letterSpacing: 1.5),
          ),
        )
      ]),
    );
  }
}
