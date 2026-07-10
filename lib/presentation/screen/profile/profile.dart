import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If this is a simple read, keep it here.
    // If it's a Future, you should handle it in the FutureBuilder.

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: FutureBuilder<String?>(
        // Changed from <String> to <String?>
        future: LocalCacheService.read('fcm-token'),

        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Use '??' to provide a fallback if the data is null
            final token = snapshot.data ?? 'No Token Found';
            return Center(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                children: [Text('Profile FCM TOKEN :'), Text(token)],
              ),
            );
          }
        },
      ),
    );
  }
}
