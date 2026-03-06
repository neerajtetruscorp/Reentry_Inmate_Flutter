import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/program.dart';

class ProgramCard extends StatelessWidget {
  final Program program;

  const ProgramCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    program.programAttributes?.programName ?? 'Unknown Program',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                program.status == "Completed"
                    ? CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.check, color: Colors.white),
                      )
                    : Icon(Icons.arrow_forward_ios),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Start Date", style: TextStyle(color: Colors.grey)),
Text(
  program.startDateTime != null
      ? DateFormat('MM/dd/yyyy')
          .format(DateTime.parse(program.startDateTime!))
      : 'N/A',
)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Program Type", style: TextStyle(color: Colors.grey)),
                    Text(program.programAttributes?.programType ?? 'N/A')
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
