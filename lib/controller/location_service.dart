// import 'package:workmanager/workmanager.dart';
// import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';



 
void startLocationTracking(String userId) {
  Timer.periodic(const Duration(minutes: 2), (timer) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('Users').doc(userId).update({
        "locations": FieldValue.arrayUnion([
          {
            "latitude": position.latitude,
            "longitude": position.longitude,
            "timestamp": DateTime.now().toIso8601String(),
          }
        ]),
      });
      print("Location updated: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      print("Error fetching location: $e");
    }
  });
}


// const fetchLocationTask = "fetchLocationTask";
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print("WorkManager task triggered");
//     if (task == fetchLocationTask) {
//       try {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//           forceAndroidLocationManager: true,
//         );
//         print("Fetched location: ${position.latitude}, ${position.longitude}");
//         String userId = inputData!['userId'];

//         FirebaseFirestore firestore = FirebaseFirestore.instance;
//         await firestore.collection('Users').doc(userId).set({
//           "locations": FieldValue.arrayUnion([
//             {
//               "latitude": position.latitude,
//               "longitude": position.longitude,
//               "timestamp": DateTime.now().toIso8601String(),
//             }
//           ])
//         }, SetOptions(merge: true));
//       } catch (e) {
//         print("Error fetching location: $e");
//       }
//     }
//     return Future.value(true);
//   });
// }

// void initializeBackgroundTasks(String userId) {
//   Workmanager().initialize(callbackDispatcher);
//   Workmanager().registerPeriodicTask(
//     "fetchLocationTask",
//     fetchLocationTask,
//     inputData: {"userId": userId},
//     frequency: const Duration(minutes: 15),
//   );
// }

// void fetchAndSaveLocation(String userId) async {
//   try {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     print("Location: ${position.latitude}, ${position.longitude}");

//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     await firestore.collection('Users').doc(userId).update({
//       "locations": FieldValue.arrayUnion([
//         {
//           "latitude": position.latitude,
//           "longitude": position.longitude,
//           "timestamp": DateTime.now().toIso8601String(),
//         }
//       ]),
//     });

//     print("Location saved to Firestore");
//   } catch (e) {
//     print("Error: $e");
//   }
// }


