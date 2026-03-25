import 'package:flutter/material.dart';

class GaplySideNavigation extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const GaplySideNavigation({super.key, required this.selectedCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Gaply Motion",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _NavMenuItem(
                  title: "Fade",
                  icon: Icons.opacity,
                  isSelected: selectedCategory == "Fade",
                  onTap: () => onCategorySelected("Fade"),
                ),
                _NavMenuItem(
                  title: "Scale",
                  icon: Icons.fullscreen,
                  isSelected: selectedCategory == "Scale",
                  onTap: () => onCategorySelected("Scale"),
                ),
                _NavMenuItem(
                  title: "Flip",
                  icon: Icons.flip_camera_android,
                  isSelected: selectedCategory == "Flip",
                  onTap: () => onCategorySelected("Flip"),
                ),
                _NavMenuItem(
                  title: "Shake",
                  icon: Icons.vibration,
                  isSelected: selectedCategory == "Shake",
                  onTap: () => onCategorySelected("Shake"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 내부에서 사용하는 메뉴 아이템 위젯
class _NavMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavMenuItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: isSelected ? Colors.blueAccent : Colors.grey[600]),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blueAccent : Colors.grey[800],
          ),
        ),
        tileColor: isSelected ? Colors.blue.withValues(alpha: 0.08) : Colors.transparent,
      ),
    );
  }
}
