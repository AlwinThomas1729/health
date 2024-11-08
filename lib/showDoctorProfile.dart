// import 'package:flutter/material.dart';

// class ShowDoctorProfile extends StatelessWidget {
//   final Map<String, dynamic>? doctorData;
//   final List<String> schedules;
//   final Map<String, bool> selectedDays;

//   const ShowDoctorProfile({
//     Key? key,
//     required this.doctorData,
//     required this.schedules,
//     required this.selectedDays,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Doctor Profile"),
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             Table(
//               border: TableBorder.all(),
//               columnWidths: const {
//                 0: FixedColumnWidth(150),
//                 1: FlexColumnWidth(),
//               },
//               children: [
//                 _buildTableRow("Name", doctorData?['name'] ?? 'N/A'),
//                 _buildTableRow("Specialization", doctorData?['specialization'] ?? 'N/A'),
//                 _buildTableRow("Experience", "${doctorData?['experience'] ?? 'N/A'} years"),
//                 _buildTableRow("Consultation Times", _buildConsultationTimes(schedules)),
//                 _buildTableRow("Consulting Days", _buildConsultingDays(selectedDays)),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: const Text("Close"),
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the dialog
//           },
//         ),
//       ],
//     );
//   }

//   // Helper method to build a single row in the table
//   TableRow _buildTableRow(String field, String value) {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             field,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(value),
//         ),
//       ],
//     );
//   }

//   // Helper method to format the consultation times
//   String _buildConsultationTimes(List<String> schedules) {
//     if (schedules.isEmpty) {
//       return 'N/A';
//     }
//     return schedules.join(', ');
//   }

//   // Helper method to format the consulting days
//   String _buildConsultingDays(Map<String, bool> selectedDays) {
//     List<String> days = selectedDays.entries
//         .where((entry) => entry.value)
//         .map((entry) => entry.key)
//         .toList();
//     if (days.isEmpty) {
//       return 'N/A';
//     }
//     return days.join(', ');
//   }
// }
