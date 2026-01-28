import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/widgets/navigator_bar.dart';
import 'package:intelliafy_app/widgets/profile/header_curved.dart';
import 'package:intelliafy_app/widgets/tests/test_details.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreen();
}

class _ListScreen extends State<ListScreen> with TickerProviderStateMixin {
  Stream<QuerySnapshot<Map<String, dynamic>>> _getFilteredStream(
      String? filter) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('tests')
        .where('recruitment', isEqualTo: true);

    if (filter != null && filter.isNotEmpty) {
      query = query.where('courseName', isEqualTo: filter);
    }
    return query.orderBy('createdAt', descending: true).snapshots();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthNotifier>(context, listen: false).fetchCourses();
    });
  }

  Widget _buildFilterMenu(AuthNotifier auth, Color color) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.tune, color: color, size: 28),
      onSelected: (String value) {
        auth.setCourseFilter(value == "All" ? null : value);
      },
      itemBuilder: (context) {
        List<PopupMenuEntry<String>> items = [
          const PopupMenuItem(value: "All", child: Text("Show All")),
        ];
        items.addAll(auth.courseNames.map((course) => PopupMenuItem(
              value: course,
              child: Text(course),
            )));
        return items;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthNotifier>(context);
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: surfaceColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                painter: HeaderCurvedContainer(color: accentColor),
                child: Container(height: 180),
              ),
            ),
            Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        _buildFilterMenu(auth, surfaceColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Tests: ${auth.selectedCourse ?? 'All'}",
                            style: TextStyle(
                                color: surfaceColor,
                                fontSize: 26,
                                fontFamily: 'Init'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _getFilteredStream(auth.selectedCourse),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No hay tests disponibles'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.only(
                            top: 25, bottom: 20, left: 5, right: 5),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final document = snapshot.data!.docs[index];
                          return Column(
                            children: [
                              TestDetails(
                                testData: document.data(),
                                accentColor: accentColor,
                                surfaceColor: surfaceColor,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
