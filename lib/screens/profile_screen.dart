import 'package:intelliafy_app/exports.dart';
import 'package:intl/intl.dart';

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
      bottomNavigationBar: const BottomNavigationBarForApp(indexNum: 2),
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
                              data?['name'] ?? 'Loading...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                height: 1.1,
                              ),
                            ),
                          ),
                          infoSection(
                            content: data?['email'] ?? 'Not available',
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
                              onPressed: () async => {
                                await auth.signOut(),
                                if (context.mounted)
                                  {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false,
                                    ),
                                  }
                              },
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
