import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/data/controller/operation_controller/update_task_controller.dart';
import 'package:task_management/data/task_model/task_model.dart';

class UpdateTaskScreen extends StatelessWidget {
  final TaskModel task;
  const UpdateTaskScreen({super.key, required this.task});

  Future<void> _pickDate(BuildContext context) async {
    final controller = Provider.of<UpdateTaskController>(
      context,
      listen: false,
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) controller.setEndDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<UpdateTaskController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: BackButton(color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              "Edit Task",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputField("Task Title", controller.titleController),
            const SizedBox(height: 16),
            _buildInputField(
              "Description",
              controller.descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: "Priority",
              value: controller.priority,
              options: ['High', 'Medium', 'Low'],
              onChanged: (val) => controller.setPriority(val!),
              context: context,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: "Status",
              value: controller.status,
              options: ['Pending', 'Completed'],
              onChanged: (val) => controller.setStatus(val!),
              context: context,
            ),
            const SizedBox(height: 16),
            _buildDateRow(context, "End Date", controller.endDate),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: () {
                if (controller.validateForm()) {
                  controller.updateTaskInBox(); // ✅ Saves to ObjectBox
                  Navigator.pop(
                    context,
                  ); // ✅ AllTaskController auto updates due to watch()
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: const Text(
                "Update Task",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.blueGrey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey.shade700),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required void Function(String?) onChanged,
    required BuildContext context,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.blueGrey.shade50),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items:
            options
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.blueGrey.shade900),
                    ),
                  ),
                )
                .toList(),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.blueGrey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey.shade700),
          ),
        ),
        dropdownColor: Colors.blueGrey.shade50,
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, String label, DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label: ${date.toString().split(' ')[0]}",
          style: const TextStyle(fontSize: 15),
        ),
        ElevatedButton(
          onPressed: () => _pickDate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Pick Date",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
