import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


    // get users
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final user = doc.data();
          return user;
        }).toList();
      },
    );
  }

//  Future<void> addUserLocation(String userId) async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       final location = {
//         "latitude": position.latitude,
//         "longitude": position.longitude,
//         "timestamp": DateTime.now().toIso8601String(),
//       };

//       // Update Firestore
//       await _firestore.collection('users').doc(userId).update({
//         "locations": FieldValue.arrayUnion([location]),
//       });
//     } catch (e) {
//       print("Error adding location: $e");
//     }
//   }


  //   Future<Map<String, dynamic>> getUserLocation(String userId) async {
  //   final userDoc = await _firestore.collection('Users').doc(userId).get();
  //   return userDoc.data()!;
  // }

Future<List<Map<String, dynamic>>> getLastFiveLocations(String userId) async {
  final userDoc = await _firestore.collection('Users').doc(userId).get();
  List<dynamic> locations = userDoc.data()?['locations'] ?? [];

  // Sort by timestamp descending
  locations.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

  return locations.take(5).toList().cast<Map<String, dynamic>>();
}


}