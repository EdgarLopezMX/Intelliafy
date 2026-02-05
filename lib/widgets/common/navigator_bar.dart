import 'package:intelliafy_app/exports.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  final int indexNum;

  const BottomNavigationBarForApp({super.key, required this.indexNum});

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: surfaceColor,
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, Icons.checklist_rtl, 0, indexNum),
            _buildNavItem(context, Icons.add, 1, indexNum),
            _buildNavItem(context, Icons.person, 2, indexNum),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, int index, int currentIndex) {
    bool isSelected = index == currentIndex;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;

    return GestureDetector(
      onTap: () => _navigateTo(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? surfaceColor.withValues(alpha: 0.2)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: isSelected ? 32 : 25,
          color: surfaceColor,
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    if (index == indexNum) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const ListScreen();
        break;
      case 1:
        nextScreen = const UploadTest();
        break;
      case 2:
        nextScreen = const ProfileScreen();
        break;
      default:
        nextScreen = const ListScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => nextScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
