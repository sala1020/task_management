

import 'package:flutter/material.dart';

class ReusableFloatingActionButtons extends StatelessWidget {
  final VoidCallback onSyncPressed;
  final VoidCallback onAddPressed;

  const ReusableFloatingActionButtons({
    required this.onSyncPressed,
    required this.onAddPressed,
    Key? key,
  }) : super(key: key);

  Widget _buildFAB({
    required IconData icon,
    required VoidCallback onPressed,
    required String heroTag,
  }) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: Colors.blueGrey,
      child: Icon(icon, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = constraints.maxWidth > 800;

        return isLarge
            ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildFAB(
                  icon: Icons.sync,
                  onPressed: onSyncPressed,
                  heroTag: "sync_btn",
                ),
                const SizedBox(width: 16),
                _buildFAB(
                  icon: Icons.add,
                  onPressed: onAddPressed,
                  heroTag: "add_btn",
                ),
              ],
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildFAB(
                  icon: Icons.sync,
                  onPressed: onSyncPressed,
                  heroTag: "sync_btn",
                ),
                const SizedBox(height: 12),
                _buildFAB(
                  icon: Icons.add,
                  onPressed: onAddPressed,
                  heroTag: "add_btn",
                ),
              ],
            );
      },
    );
  }
}
