import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config/svgs.dart';
import '../../controller/auth_service.dart';
import '../../controller/location_service.dart';
import '../../controller/notification_service.dart';
import '../../controller/user_service.dart';
import '../../widgets/my_drawer.dart';
import '../../widgets/user_tile.dart';
import '../location/location_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    startLocationTracking(_authService.currentUser()!.uid);
    startLocationChecker(_authService.currentUser()!.uid);
  }

  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // Location permission denied by the user.
      print("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied; redirect to app settings.
      await openAppSettings();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: SvgPicture.asset(
            AssetsSvgs.appIcon,
            height: 65,
          )

          // const Text(
          //   "V N R",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 24,
          //     // color: Color.fromARGB(255, 150, 244, 116)
          //   ),
          // ),
          ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _userService.getUsersStream(),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // has data
          return ListView(
            children: snapshot.data!
                .map((userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authService.currentUser()!.email) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
        child: UserTile(
          user: userData['name'].toString().toUpperCase(),
          onTap: () {
            // tap on user to go to user page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationPage(
                  receiverName: userData['name'],
                  receiverId: userData['uid'],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
