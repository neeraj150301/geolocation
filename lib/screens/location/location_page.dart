import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controller/user_service.dart';
import 'map_screen.dart';

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
        title: Text(widget.receiverName.toUpperCase()),
        centerTitle: true,
      ),
      body: locations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Card(
                      child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            latitude: location['latitude'],
                            longitude: location['longitude'],
                            time: _formatTimestamp(location['timestamp']),
                          ),
                        ),
                      );
                    },
                    title: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                            "${location['latitude']}, ${location['longitude']}"),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.timer_sharp,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          _formatTimestamp(location['timestamp']),
                        ),
                      ],
                    ),
                  )),
                );
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
