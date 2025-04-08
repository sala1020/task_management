import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class TaskSummaryCard extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;

  const TaskSummaryCard({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
  });

  double get _completion => totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

  Color get _waveColor {
    if (_completion >= 0.7) return Colors.green;
    if (_completion >= 0.3) return Colors.blue;
    return Colors.red;
  }

  List<double> get _waveHeights {
    if (_completion == 1.0) return [0.01, 0.005];
    return [0.6 - (_completion * 0.5), 0.5 - (_completion * 0.4)];
  }

  String get _percentText => "${(_completion * 100).toStringAsFixed(0)}%";

  TextStyle get _textStyle =>  TextStyle(color: Colors.white,fontWeight:FontWeight.w600 );

  BoxDecoration get _cardDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildWaveBackground(),
        _buildInfoOverlay(),
        _buildPercentageBadge(),
      ],
    );
  }

  Widget _buildWaveBackground() {
    return Container(
      height: 150,
      decoration: _cardDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: WaveWidget(
          config: CustomConfig(
            colors: [_waveColor.withOpacity(0.6), _waveColor],
            durations: [30000, 18000],
            heightPercentages: _waveHeights,
          ),
          waveAmplitude: 0,
          backgroundColor: Colors.transparent,
          size: const Size(double.infinity, double.infinity),
        ),
      ),
    );
  }

  Widget _buildInfoOverlay() {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueGrey.withOpacity(0.88),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Task Progress",
              style: _textStyle.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          _buildTaskDetail("Total Tasks", totalTasks),
          _buildTaskDetail("Pending", pendingTasks),
          _buildTaskDetail("Completed", completedTasks),
        ],
      ),
    );
  }

  Widget _buildTaskDetail(String label, int value) {
    return Text("$label: $value", style: _textStyle);
  }

  Widget _buildPercentageBadge() {
    return Positioned(
      top: 10,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          _percentText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
