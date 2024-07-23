import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class CarRentalContentPage extends StatefulWidget {
  @override
  _CarRentalContentPageState createState() => _CarRentalContentPageState();
}

class _CarRentalContentPageState extends State<CarRentalContentPage> {
  bool returnToSameLocation = true;
  TextEditingController pickupLocationController = TextEditingController();
  DateTime pickupDate = DateTime.now();
  DateTime returnDate = DateTime.now().add(Duration(days: 3));
  TimeOfDay pickupTime = TimeOfDay(hour: 10, minute: 0);
  TimeOfDay returnTime = TimeOfDay(hour: 10, minute: 0);
  RangeValues driverAgeRange = RangeValues(30, 65);

  Future<void> _selectDate(BuildContext context, bool isPickup) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPickup ? pickupDate : returnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isPickup ? pickupDate : returnDate)) {
      setState(() {
        if (isPickup) {
          pickupDate = picked;
        } else {
          returnDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isPickup) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isPickup ? pickupTime : returnTime,
    );
    if (picked != null && picked != (isPickup ? pickupTime : returnTime)) {
      setState(() {
        if (isPickup) {
          pickupTime = picked;
        } else {
          returnTime = picked;
        }
      });
    }
  }

  void _performSearch() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('car_rentals')
        .where('pickup_location', isEqualTo: pickupLocationController.text)
        .where('pickup_date', isEqualTo: DateFormat('yyyy-MM-dd').format(pickupDate))
        .where('pickup_time', isEqualTo: pickupTime.format(context))
        .where('return_date', isEqualTo: DateFormat('yyyy-MM-dd').format(returnDate))
        .where('return_time', isEqualTo: returnTime.format(context))
        .get();

    for (var doc in querySnapshot.docs) {
      print(doc.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Return to same location'),
              value: returnToSameLocation,
              onChanged: (bool value) {
                setState(() {
                  returnToSameLocation = value;
                });
              },
            ),
            TextField(
              controller: pickupLocationController,
              decoration: InputDecoration(
                labelText: 'Pickup location',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Pickup date'),
                    subtitle: Text(DateFormat.yMMMd().format(pickupDate)),
                    trailing: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, true),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Time'),
                    subtitle: Text(pickupTime.format(context)),
                    trailing: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, true),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Return date'),
                    subtitle: Text(DateFormat.yMMMd().format(returnDate)),
                    trailing: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, false),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Time'),
                    subtitle: Text(returnTime.format(context)),
                    trailing: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, false),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Driver's age: ${driverAgeRange.start.round()}-${driverAgeRange.end.round()}",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            RangeSlider(
              values: driverAgeRange,
              min: 18,
              max: 100,
              divisions: 82,
              labels: RangeLabels(
                driverAgeRange.start.round().toString(),
                driverAgeRange.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  driverAgeRange = values;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performSearch,
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
