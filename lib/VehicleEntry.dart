import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:vehipal/dashboard.dart';

class VehicleEntry extends StatefulWidget {
  final User? currentUser;

  const VehicleEntry(this.currentUser, {super.key});

  @override
  State<VehicleEntry> createState() => _VehicleEntryState();
}

class _VehicleEntryState extends State<VehicleEntry> {
  String selectedVehicleType = 'Car';
  TextEditingController brandController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberPlateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> vehicleTypes = [
    'Car',
    'Pickup Truck',
    'Motorcycle',
    'Scooter',
    'Truck',
    'Bicycle',
    'Van'
  ];

  final List<IconData> vehicleTypesIcons = [
    MaterialCommunityIcons.car_side,
    MaterialCommunityIcons.car_pickup,
    MaterialCommunityIcons.motorbike,
    Icons.electric_scooter,
    MaterialCommunityIcons.truck,
    MaterialCommunityIcons.bike,
    MaterialCommunityIcons.van_utility
  ];

  void _saveProfileDetails(BuildContext context) async {
    try {
      // Create a reference to the Firestore collection for user profiles
      final vehicleCollection =
      FirebaseFirestore.instance.collection('vehicles');

      // Create a document reference for the user's profile
      final vehicleDocument = vehicleCollection.doc();

      // Create a map with the vehicle details, including the ID
      final vehicleData = {
        'type': selectedVehicleType,
        'brand': brandController.text,
        'name': nameController.text,
        'numberPlate': numberPlateController.text,
        'color': selectedColor.value.toString(),
        'uid': widget.currentUser!.uid,
        'registrationDate': Timestamp.now(),
      };

      // Save the vehicle data to Firestore
      vehicleDocument
          .set({'vehicle': vehicleData}, SetOptions(merge: true)).then((value) {
        DocumentReference<Map<String, dynamic>> temp = FirebaseFirestore
            .instance
            .collection('users')
            .doc(widget.currentUser!.uid);
        temp.get().then((value) {
          List<String> vehicleArray = value.get('vehicleArray') ?? [];
          vehicleArray.add(vehicleDocument.id);
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUser!.uid)
              .update({'vehicleArray': vehicleArray}).then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DashboardPage()));
          });
        });
      });
    } catch (e)
    {
      // Handle any errors that occurred during the saving process
      print('Error saving profile details: $e');
    }
  }

  Color selectedColor = Colors.black;

  void _openColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Color'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _saveProfileDetails(context);
        },
        icon: const Icon(MaterialCommunityIcons.content_save),
        label: const Text('Save'),
      ),
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Select Vehicle Type:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedVehicleType,
                  onChanged: (value) {
                    setState(() {
                      selectedVehicleType = value!;
                      print(selectedVehicleType +
                          vehicleTypes.indexOf(selectedVehicleType).toString());
                    });
                  },
                  items: vehicleTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(
              height: 32.0,
            ),
            const Text(
              'Vehicle Details',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            TextFormField(
              controller: brandController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This field is mandatory';
                }
                return null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: '$selectedVehicleType Brand',
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This field is mandatory';
                }
                return null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: '$selectedVehicleType Name',
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            TextFormField(
              controller: numberPlateController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: '$selectedVehicleType Number Plate',
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select a Color:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: _openColorPickerDialog,
                  child: Icon(
                    vehicleTypesIcons
                        .elementAt(vehicleTypes.indexOf(selectedVehicleType)),
                    size: 48.0,
                    color: selectedColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    brandController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
