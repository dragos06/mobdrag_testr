import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device.dart';
import '../viewmodels/device_viewmodel.dart';

class UpdateDeviceScreen extends StatefulWidget {
  final Device device;

  const UpdateDeviceScreen({super.key, required this.device});

  @override
  State<UpdateDeviceScreen> createState() => _UpdateDeviceScreenState();
}

class _UpdateDeviceScreenState extends State<UpdateDeviceScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _modelController;
  late TextEditingController _osController;
  late TextEditingController _screenController;
  late TextEditingController _usedByController;
  late TextEditingController _notesController;
  late DeviceStatus _status;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: widget.device.model);
    _osController = TextEditingController(text: widget.device.os);
    _screenController =
        TextEditingController(text: widget.device.screenResolution);
    _usedByController =
        TextEditingController(text: widget.device.usedBy ?? '');
    _notesController = TextEditingController(text: widget.device.notes ?? '');
    _status = widget.device.status;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedDevice = widget.device.copyWith(
        model: _modelController.text.trim(),
        os: _osController.text.trim(),
        screenResolution: _screenController.text.trim(),
        status: _status,
        usedBy: _usedByController.text.trim().isEmpty
            ? null
            : _usedByController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      context.read<DeviceViewModel>().updateDevice(updatedDevice);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _modelController.dispose();
    _osController.dispose();
    _screenController.dispose();
    _usedByController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text(
          'Edit Device',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF0F0F0),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _modelController,
                          decoration: _inputDecoration('Model'),
                          cursorColor: Colors.blue,
                          cursorHeight: 20,
                          cursorWidth: 2,
                          maxLength: 50,
                          validator: (value) =>
                          (value == null || value.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _osController,
                          decoration: _inputDecoration('OS'),
                          cursorColor: Colors.blue,
                          cursorHeight: 20,
                          cursorWidth: 2,
                          maxLength: 30,
                          validator: (value) =>
                          (value == null || value.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _screenController,
                          decoration: _inputDecoration('Screen Resolution'),
                          cursorColor: Colors.blue,
                          cursorHeight: 20,
                          cursorWidth: 2,
                          maxLength: 20,
                          validator: (value) =>
                          (value == null || value.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _usedByController,
                          decoration: _inputDecoration('Used By'),
                          cursorColor: Colors.blue,
                          cursorHeight: 20,
                          cursorWidth: 2,
                          maxLength: 50,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          decoration: _inputDecoration('Notes'),
                          cursorColor: Colors.blue,
                          cursorHeight: 20,
                          cursorWidth: 2,
                          maxLength: 200,
                          minLines: 3,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<DeviceStatus>(
                          value: _status,
                          decoration: _inputDecoration('Status'),
                          dropdownColor: const Color(0xFFF0F0F0),
                          items: DeviceStatus.values.map((s) {
                            String text;
                            switch (s) {
                              case DeviceStatus.available:
                                text = 'Available';
                                break;
                              case DeviceStatus.inUse:
                                text = 'In Use';
                                break;
                              case DeviceStatus.retired:
                                text = 'Retired';
                                break;
                            }
                            return DropdownMenuItem(
                              value: s,
                              child: Text(text),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => _status = value!),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
