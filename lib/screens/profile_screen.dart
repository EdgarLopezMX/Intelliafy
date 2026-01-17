import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/widgets/profile/header_curved.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/widgets/navigator_bar.dart';
import 'package:intelliafy_app/widgets/profile/info_section.dart';

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
    // Ejecutar después de que el primer frame se renderice
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthNotifier>();
      // Si hay un usuario autenticado en Firebase, pedimos sus datos de Firestore
      if (auth.user != null) {
        auth.fetchUserData(auth.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
      backgroundColor: surfaceColor,
      body: Consumer<AuthNotifier>(
        builder: (context, auth, child) {
          // 1. Manejo de estado de carga
          if (auth.isLoading && auth.userData == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = auth.userData;
          // 2. Formateo de fecha (evitamos lógica pesada en el build)
          String joinedAt = "---";
          if (data?['createdAt'] != null) {
            var date = (data!['createdAt'] as Timestamp).toDate();
            joinedAt = "${date.day} - ${date.month} - ${date.year}";
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: HeaderCurvedContainer(color: accentColor),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 130),
                  Container(
                    width: 190,
                    height: 190,
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
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.42,
                left: 25,
                right: 25,
                child: Card(
                  elevation: 4,
                  color: surfaceColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            data?['name'] ?? 'Cargando...',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        Divider(color: accentColor, height: 30),
                        infoSection(
                          title: 'Email:',
                          content: data?['email'] ?? 'No disponible',
                          icon: Icons.email,
                          accent: accentColor,
                        ),
                        infoSection(
                          title: 'Inscrito:',
                          content: joinedAt,
                          icon: Icons.calendar_month,
                          accent: accentColor,
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
