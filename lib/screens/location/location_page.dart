import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controller/user_service.dart';

class LocationPage extends StatefulWidget {
  final String receiverName;
  final String receiverId;

  const LocationPage({
    super.key,
    required this.receiverName,
    required this.receiverId,
  });

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final UserService _userService = UserService();
  // String? location;
  // String? timestamp;
  List<Map<String, dynamic>> locations = [];

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  void fetchLocations() async {
    final data = await _userService.getLastFiveLocations(widget.receiverId);
    setState(() {
      locations = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        centerTitle: true,
      ),
      body: locations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return Card(
                    child: ListTile(
                  title: Text(
                      "Location: ${location['latitude']}, ${location['longitude']}"),
                  subtitle: Text(
                    "Time: ${_formatTimestamp(location['timestamp'])}",
                  ),
                ));
              },
            ),
    );
  }
}

String _formatTimestamp(String timestamp) {
  try {
    DateTime parsedDate = DateTime.parse(timestamp);
    return DateFormat('dd MMM yyyy, h:mm a').format(parsedDate);
  } catch (e) {
    return "Invalid time";
  }
}
