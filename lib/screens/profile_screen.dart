import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/widgets/profile/header_curved.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/widgets/navigator_bar.dart';
import 'package:intelliafy_app/widgets/profile/info_section.dart';
import 'package:intelliafy_app/widgets/profile/profile_info.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthNotifier>();
      if (auth.user != null) {
        auth.fetchUserData(auth.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    double profileSize = MediaQuery.of(context).size.width * 0.45;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
      backgroundColor: surfaceColor,
      body: Consumer<AuthNotifier>(
        builder: (context, auth, child) {
          if (auth.isLoading && auth.userData == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = auth.userData;
          String joinedAt = "---";
          if (data?['createdAt'] != null) {
            DateTime date = (data!['createdAt'] as Timestamp).toDate();
            joinedAt = DateFormat('MMMM d, yyyy').format(date);
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomPaint(
                  painter: HeaderCurvedContainer(color: accentColor),
                  child: Container(height: 350),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Container(
                      width: profileSize,
                      height: profileSize,
                      decoration: BoxDecoration(
                        border: Border.all(color: surfaceColor, width: 8),
                        shape: BoxShape.circle,
                        color: surfaceColor,
                        image: data?['userImage'] != null
                            ? DecorationImage(
                                image: NetworkImage(data!['userImage']),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: data?['userImage'] == null
                          ? Icon(Icons.person, size: 100, color: accentColor)
                          : null,
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              data?['name'] ?? 'Cargando...',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          infoSection(
                            content: data?['email'] ?? 'No disponible',
                          ),
                          Divider(color: primaryColor),
                          const SizedBox(
                            height: 100,
                          ),
                          profileInfo(
                            content: joinedAt,
                            accent: accentColor,
                            icon: Icons.calendar_month,
                            primary: primaryColor,
                          ),
                          Center(
                            child: TextButton.icon(
                              onPressed: () => auth.signOut(),
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 24,
                              ),
                              label: const Text("Sign Out",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
