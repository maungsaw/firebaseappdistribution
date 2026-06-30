import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/material.dart';

class PremiumTermForm extends StatefulWidget {
  final PremiumTermModel? data;
  final String formType;
  final String saveButtonText;
  final Function(PremiumTermModel?) onSave;

  const PremiumTermForm({
    super.key,
    this.data,
    required this.formType,
    this.saveButtonText = 'Save',
    required this.onSave,
  });

  @override
  State<PremiumTermForm> createState() => _PremiumTermFormState();
}

class _PremiumTermFormState extends State<PremiumTermForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    debugPrint("saveButtonText ${widget.data?.label}");
    _labelController = TextEditingController(text: widget.data?.label);
    _valueController = TextEditingController(
      text: widget.data?.value.toString(),
    );
  }

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks when the form leaves the screen
    _labelController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Pass the text values back up cleanly to your BLoC or Parent widget
      final premiumTerm = PremiumTermModel(
        id: widget.data!.id,
        label: _labelController.text,
        value: int.parse(_valueController.text),
      );
      widget.onSave(premiumTerm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _labelController,
            decoration: const InputDecoration(
              labelText: 'Enter Label',
              hintText: 'e.g., Year Term',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Label cannot be empty'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _valueController,
            decoration: const InputDecoration(
              labelText: 'Enter Value',
              hintText: 'e.g., 12',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Value cannot be empty'
                : null,
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: _submitForm,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.saveButtonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
