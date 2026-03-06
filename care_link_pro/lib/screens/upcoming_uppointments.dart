import 'package:care_link_pro/models/appointment.dart';
import 'package:care_link_pro/widgets/appointment_card.dart';
import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../helper/network/network_manager.dart';
import '../widgets/appointment_card.dart';




const String kUpointmentsUrl =
    "http://dev-reentry.tetrus.dev/inmate-svc/api/inmateportal/event/mobile/upcomingevents/11";

class UpcomingAppointmentsScreen extends StatefulWidget {
  @override
  _UpcomingAppointmentsScreenState createState() =>
      _UpcomingAppointmentsScreenState();
}

class _UpcomingAppointmentsScreenState
    extends State<UpcomingAppointmentsScreen> {
  List<Appointment> appointments = [];
  bool loading = true;

  int selectedTab = 0;
  String? _fetchError;

  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  void loadAppointments() async {
    try {
      final result = await NetworkManager.get(kUpointmentsUrl);

      if (!mounted) return;

      print("RESULT SUCCESS: ${result.isSuccess}");
      print("RESULT DATA TYPE: ${result.data.runtimeType}");
      print("RESULT DATA: ${result.data}");

      if (result.isSuccess && result.data != null) {
        final List dataList = result.data as List;

        print("Programs count from API: ${dataList.length}");

        appointments = dataList.map((json) => Appointment.fromJson(json)).toList();

        print("Programs length after mapping: ${appointments.length}");

        if (appointments.isNotEmpty) {
          print("First Program Status: ${appointments.first.status}");
        }
      } else {
        _fetchError = result.error?.toString() ?? "Failed to load programs";
        print("API ERROR: $_fetchError");
      }
    } catch (e) {
      if (mounted) {
        _fetchError = "Network error: $e";
        print("EXCEPTION: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

 @override
Widget build(BuildContext context) {
  List<Appointment> filteredPrograms = appointments;

  return Scaffold(
    appBar: AppBar(
      title: const Text("Upcoming Appointments"),
    ),
    body: Column(
      children: [
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: filteredPrograms.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: AppointmentCard(
                        program: filteredPrograms[index],
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
}