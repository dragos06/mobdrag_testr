import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device.dart';
import '../viewmodels/device_viewmodel.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();

  final _modelController = TextEditingController();
  final _osController = TextEditingController();
  final _screenController = TextEditingController();
  final _usedByController = TextEditingController();
  final _notesController = TextEditingController();

  DeviceStatus _status = DeviceStatus.available;
  bool _isSaving = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final device = Device(
        localId: 0, 
        model: _modelController.text.trim(),
        os: _osController.text.trim(),
        screenResolution: _screenController.text.trim(),
        status: _status,
        usedBy: _usedByController.text.trim().isEmpty ? null : _usedByController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      try {
        await context.read<DeviceViewModel>().addDevice(device);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding device: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
        title: const Text('Add Device', style: TextStyle(fontWeight: FontWeight.w600)),
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
                          maxLength: 50, 
                          decoration: _inputDecoration('Model'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _osController,
                          maxLength: 30, 
                          decoration: _inputDecoration('OS'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _screenController,
                          maxLength: 20, 
                          decoration: _inputDecoration('Screen Resolution'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _usedByController,
                          maxLength: 50, 
                          decoration: _inputDecoration('Used By'),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          maxLength: 200, 
                          decoration: _inputDecoration('Notes'),
                          maxLines: 3,
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isSaving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Add Device'),
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