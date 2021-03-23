import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  Auth._();

  static Future<String> uploadPhoto(File targetFile) async {
    if (targetFile == null) {
      return null;
    } else {
      Reference _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().microsecondsSinceEpoch}');
      UploadTask _storageUploadTask = _storageReference.putFile(targetFile);
      return await _storageUploadTask
          .then((value) => value.ref.getDownloadURL());
    }
  }

  static Future<bool> sendAppointmentNotification(
      {String name, String doctorName, String hospitalID, String time}) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Hospital')
          .doc(hospitalID)
          .get();
      String fcmToken = snapshot.data()['fcmToken'];
      http.Response response = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=	AAAAEjHDAow:APA91bEDsaS8pAxBy3GEFIRAnFY2qP2JHRqZmYuysMH515_0OCwPjLVZs7_glJQjb3gmx1zr705_YfHMyls_A8D1A5K66irLIL0m4uuFWI8OK3UVVgwAV5TxYZPH-FSLmYAzbhf4Uc0q',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '$name booked appointment for $doctorName at $time',
              'title': 'New Appointment !'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': fcmToken,
            'collapse_key': DateTime.now().toString()
          },
        ),
      );

      var body = jsonDecode(response.body);
      if (body['success'] == 1) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }
}
