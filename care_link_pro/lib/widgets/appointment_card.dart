import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment program;

  const AppointmentCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    DateTime? dateTime;

    if (program.scheduledDateTime != null) {
      dateTime = DateTime.parse(program.scheduledDateTime!);
    }

    String date =
        dateTime != null ? DateFormat('MM/dd/yyyy').format(dateTime) : "N/A";
    String time =
        dateTime != null ? DateFormat('hh:mm a').format(dateTime) : "N/A";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
  (program.programAttributes?.programName == null ||
          program.programAttributes?.programName?.isEmpty == true)
      ? (program.serviceTypeName ?? 'N/A')
      : program.programAttributes!.programName!,
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),

                ),

                /// Arrow button
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.blue,
                    size: 20,
                  ),
                )
              ],
            ),

            const SizedBox(height: 18),

            /// Date Time Container
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffE8EEF9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.blue,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),

                  /// Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.blue,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}