import 'package:flutter/material.dart';
import '../models/program.dart';
import '../helper/network/network_manager.dart';
import '../widgets/program_card.dart';

const String kProgramUrl =
    "http://dev-reentry.tetrus.dev/inmate-svc/api/inmateprogram/programs/mobile/encounterId/5/lmsUserId/38";

class ProgramListScreen extends StatefulWidget {
  @override
  _ProgramListScreenState createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  List<Program> programs = [];
  bool loading = true;

  int selectedTab = 0;
  String? _fetchError;

  @override
  void initState() {
    super.initState();
    loadPrograms();
  }

  void loadPrograms() async {
    try {
      final result = await NetworkManager.get(kProgramUrl);

      if (!mounted) return;

      print("RESULT SUCCESS: ${result.isSuccess}");
      print("RESULT DATA TYPE: ${result.data.runtimeType}");
      print("RESULT DATA: ${result.data}");

      if (result.isSuccess && result.data != null) {
        final List dataList = result.data as List;

        print("Programs count from API: ${dataList.length}");

        programs = dataList
            .map((json) => Program.fromJson(json))
            .toList();

        print("Programs length after mapping: ${programs.length}");

        if (programs.isNotEmpty) {
          print("First Program Status: ${programs.first.status}");
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

    List<Program> filteredPrograms = programs.where((p) {
      final status = (p.status ?? '').toLowerCase();

      if (selectedTab == 1) {
        return status.contains('completed');
      } else {
        return status.contains('progress');
      }

    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("List of Programs"),
      ),
      body: Column(
        children: [

          /// Tabs
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [

                /// In Progress Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedTab == 0
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "In Progress",
                          style: TextStyle(
                            color: selectedTab == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                /// Completed Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedTab == 1
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            color: selectedTab == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          /// List
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredPrograms.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {},
                        child: ProgramCard(
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