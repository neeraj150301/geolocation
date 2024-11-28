import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';

import 'access_token_firebase.dart';

void startLocationChecker(String userId) {
  // print("startLocationChecker");
  Timer.periodic(const Duration(minutes: 2), (timer) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch the user's last location
    DocumentSnapshot userDoc =
        await firestore.collection('Users').doc(userId).get();
    List<dynamic>? locations = userDoc['locations'] as List<dynamic>?;

    if (locations == null || locations.length < 2) return;

    // Last two locations
    Map<String, dynamic> lastLocation = locations[locations.length - 1];
    Map<String, dynamic> secondLastLocation = locations[locations.length - 2];

    // Calculate distance
    double distance = calculateDistance(
      secondLastLocation['latitude'],
      secondLastLocation['longitude'],
      lastLocation['latitude'],
      lastLocation['longitude'],
    );
    // print("distance = $distance");
    if (distance > 20) {
      // Notify other users
      QuerySnapshot usersSnapshot = await firestore.collection('Users').get();
      for (var user in usersSnapshot.docs) {
        if (user.id != userId) {
          String? token = user['fcmToken'];
          if (token != null) {
            sendNotification(
              token,
              'User Moved!',
              'User ${userDoc['email']} moved to ${lastLocation['latitude']}, ${lastLocation['longitude']}',
            );
          }
        }
      }
    }
  });
}

double calculateDistance(
    double startLat, double startLng, double endLat, double endLng) {
  return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
}

Future<void> sendNotification(
    String receiverFcmToken, String text, String message) async {
  AccessFirebaseToken accessToken = AccessFirebaseToken();
  String bearerToken = await accessToken.getAccessToken();

  final body = {
    "message": {
      "token": receiverFcmToken,
      "notification": {"title": text, "body": message},
    }
  };

  try {
    await post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/geolocation-876e5/messages:send'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $bearerToken'
      },
      body: jsonEncode(body),
    );
    print("sending notification successfull");
  } catch (e) {
    print("Error sending FCM notification: $e");
  }
}
