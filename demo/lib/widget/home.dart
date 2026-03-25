import 'package:demo/widget/page/fade_page.dart';
import 'package:demo/widget/side_navigation.dart';
import 'package:flutter/material.dart';

class GaplyDemoHome extends StatefulWidget {
  const GaplyDemoHome({super.key});

  @override
  State<GaplyDemoHome> createState() => _GaplyDemoHomeState();
}

class _GaplyDemoHomeState extends State<GaplyDemoHome> {
  String _currentCategory = "Fade";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          GaplySideNavigation(
            selectedCategory: _currentCategory,
            onCategorySelected: (category) {
              setState(() {
                _currentCategory = category;
              });
            },
          ),

          Expanded(
            child: Container(color: Colors.grey[50], child: _buildSelectedDemo()),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDemo() {
    switch (_currentCategory) {
      case "Fade":
        return const GaplyFadeDemo(); // 만들어두신 Fade 데모 위젯
      // case "Scale":
      //   return const GaplyScaleDemo();
      // case "Rotate":
      //   return const GaplyRotateDemo();
      // case "Shake":
      //   return const GaplyShakeDemo();
      // case "Flip":
      //   return const GaplyFlipDemo();
      default:
        return Center(child: Text("Displaying: $_currentCategory"));
    }
  }
}
