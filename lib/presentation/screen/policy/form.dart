// ignore_for_file: deprecated_member_use

import 'package:firebaseappdistribution/core/core.dart'
    show FormType, GlobalSnackbar, PolicyStatus;
import 'package:firebaseappdistribution/data/data.dart' show PolicyModel;
import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PolicyForm extends StatefulWidget {
  final FormType type;
  final PolicyModel? data;
  const PolicyForm({super.key, required this.type, this.data});

  @override
  State<PolicyForm> createState() => _PolicyFormState();
}

class _PolicyFormState extends State<PolicyForm> {
  final _formKey = GlobalKey<FormState>();

  final _policyNoController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sumAssuredController = TextEditingController();
  final _premiumAmountController = TextEditingController();
  final _genderController = TextEditingController();

  String filePath = '';
  double rate = 0.0;
  DateTime? _selectedBirthday;
  String _selectedStatus = PolicyStatus.draft.label;

  // Custom tracking for boundary validation
  String? _ageValidationError;

  int? _selectedTerm;
  double? _selectedPolicy;

  @override
  void initState() {
    super.initState();
    if (widget.type != FormType.create && widget.data != null) {
      final data = widget.data!;
      _policyNoController.text = data.no;
      _nameController.text = data.name;
      _ageController.text = data.age.toString();
      _sumAssuredController.text = data.sumAssured.toString();
      _premiumAmountController.text = data.premiumAmount.toString();
      _genderController.text = data.gender.toString();

      filePath = data.filePath;
      _selectedBirthday = data.birthday;
      _selectedStatus = data.status;
      _selectedTerm = data.term;
      _selectedPolicy = data.policy;

      // Perform initial boundary check for editing flow
      _validateAgeBounds(data.age);
    }
  }

  @override
  void dispose() {
    _policyNoController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _sumAssuredController.dispose();
    _premiumAmountController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  // --- Core Validation Matrix for Min/Max Age Constraints ---
  bool _validateAgeBounds(int age) {
    if (age < 5 || age > 60) {
      setState(() {
        _ageValidationError =
            'Age must be between 5 and 60 years old (Selected: $age)';
        _selectedTerm = null;
        _selectedPolicy = null;
      });
      return false;
    }

    setState(() {
      _ageValidationError = null;
    });
    return true;
  }

  void _calculateAgeAndFetchOptions(DateTime birthday) {
    final today = DateTime.now();
    int age = today.year - birthday.year;

    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    double premiumAmount = 0.0;
    if (_sumAssuredController.text.isNotEmpty &&
        _genderController.text.isNotEmpty &&
        _selectedTerm != null) {
      if (_validateAgeBounds(age)) {
        context.read<PolicyBloc>().add(
          LoadPremiumOptionsEvent(age, _selectedTerm!, _genderController.text),
        );
      }
      debugPrint("Rate in state $rate");
      premiumAmount = (double.parse(_sumAssuredController.text) / 1000) * rate;
    }

    setState(() {
      _selectedBirthday = birthday;
      _premiumAmountController.text = premiumAmount.toString();
      _ageController.text = age.toString();
    });

    // Only hit the database via Bloc if age is completely valid
  }

  Future<void> _selectBirthday(BuildContext context) async {
    if (widget.type == FormType.detail) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedBirthday ??
          DateTime(2015), // Sensible default within 5-60 bound
      firstDate: DateTime(DateTime.now().year - 65),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _calculateAgeAndFetchOptions(picked);
    }
  }

  void _handleAction() {
    if (widget.type == FormType.detail) {
      context.pop();
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    // Explicit safety block checking
    if (_selectedBirthday == null || _ageValidationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _ageValidationError ?? 'Please select a valid birthday',
          ),
        ),
      );
      return;
    }

    if (_selectedTerm == null || _selectedPolicy == null) {
      GlobalSnackbar.showError(
        context,
        'Please select an eligible Premium Term and Policy option.',
      );
      return;
    }

    final policyNo = _policyNoController.text.trim();
    final name = _nameController.text.trim();
    final age = int.parse(_ageController.text);
    final sumAssured = double.tryParse(_sumAssuredController.text) ?? 100.0;
    final premiumAmount = double.tryParse(_premiumAmountController.text) ?? 1.0;
    final gender = _genderController.text.trim();

    if (widget.type == FormType.create) {
      final policyModel = PolicyModel(
        no: policyNo,
        status: PolicyStatus.draft.label,
        filePath: filePath,
        birthday: _selectedBirthday!,
        age: age,
        name: name,
        sumAssured: sumAssured,
        premiumAmount: premiumAmount,
        term: _selectedTerm!,
        policy: _selectedPolicy!,
        gender: gender,
      );
      context.read<PolicyBloc>().add(NewPolicyEvent(policyModel));
    } else if (widget.type == FormType.edit && widget.data != null) {
      final updatedPolicy = widget.data!.copyWith(
        no: policyNo,
        name: name,
        age: age,
        sumAssured: sumAssured,
        premiumAmount: premiumAmount,
        term: _selectedTerm,
        policy: _selectedPolicy,
        birthday: _selectedBirthday,
        filePath: filePath,
        status: _selectedStatus,
      );
      context.read<PolicyBloc>().add(UpdatePolicyEvent(updatedPolicy));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = widget.type == FormType.detail;

    return BlocListener<PolicyBloc, PolicyState>(
      listener: (context, state) {
        if (state is SuccessPolicyState) {
          context.pop();
        }
        if (state is PremiumOptionsLoadedState && _ageValidationError == null) {
          debugPrint('Rate -> ${state.rate}');
          setState(() {
            rate = state.rate;
            setState(() {
              rate = state.rate;

              // Calculate the actual premium amount using the freshly received rate
              final sumAssured =
                  double.tryParse(_sumAssuredController.text) ?? 0.0;
              double premiumAmount = (sumAssured / 1000) * rate;
              if (_selectedPolicy != null) {
                premiumAmount = premiumAmount * _selectedPolicy!;
              }

              // Update the controller so the user can see it reactively
              _premiumAmountController.text = premiumAmount.toString();
            });
          });
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalFormField(
                controller: _policyNoController,
                labelText: 'Policy Number',
                hintText: 'Enter client name',
                isReadOnly: isReadOnly,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              GlobalFormField(
                controller: _nameController,
                labelText: 'Client Name',
                hintText: 'Enter client name',
                isReadOnly: isReadOnly,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GlobalFormField(
                      controller: _sumAssuredController,
                      labelText: 'Sum Assured',
                      hintText: 'Enter sum assured',
                      keyboardType: TextInputType.number,
                      isReadOnly: isReadOnly,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GlobalFormField(
                      controller: _genderController,
                      labelText: 'Gender',
                      hintText: 'Enter gender ',
                      isReadOnly: isReadOnly,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...[
                const Text(
                  'Select Premium Term',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                BlocConsumer<PremiumTermBloc, PremiumTermState>(
                  listener: (context, state) => debugPrint('$state'),
                  builder: (context, state) {
                    if (state is InitialPremiumTermState) {
                      context.watch<PremiumTermBloc>().add(
                        FetchedPremiumTermEvent(),
                      );
                      return GlobalWidget.loadingView();
                    }
                    if (state is SuccessPremiumTermState) {
                      return Column(
                        children: state.data
                            .map(
                              (policy) => RadioListTile<int>(
                                title: Text(policy.label),
                                value: policy.id!,
                                groupValue: _selectedTerm,
                                onChanged: isReadOnly
                                    ? null
                                    : (val) =>
                                          setState(() => _selectedTerm = val),
                              ),
                            )
                            .toList(),
                      );
                    }
                    return Text(state.message);
                  },
                ),
                const SizedBox(height: 24),

                const Text(
                  'Select Premium Policy',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                BlocConsumer<PremiumPolicyBloc, PremiumPolicyState>(
                  listener: (context, state) => debugPrint('$state'),
                  builder: (context, state) {
                    if (state is InitialPremiumPolicyState) {
                      context.watch<PremiumPolicyBloc>().add(
                        FetchedPremiumPolicyEvent(),
                      );
                      return GlobalWidget.loadingView();
                    }
                    if (state is SuccessPremiumPolicyState) {
                      return Column(
                        children: state.premiumPolicys
                            .map(
                              (policy) => RadioListTile<double>(
                                title: Text(policy.label),
                                value: policy.value,
                                groupValue: _selectedPolicy,
                                onChanged: isReadOnly
                                    ? null
                                    : (val) =>
                                          setState(() => _selectedPolicy = val),
                              ),
                            )
                            .toList(),
                      );
                    }
                    return Text(state.message);
                  },
                ),
              ],
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectBirthday(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Birthday',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _selectedBirthday == null
                              ? 'Select Date'
                              : "${_selectedBirthday!.toLocal()}".split(' ')[0],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Age (Auto)',
                        border: const OutlineInputBorder(),
                        errorText: _ageValidationError != null
                            ? 'Invalid'
                            : null,
                      ),
                    ),
                  ),
                ],
              ),

              // Custom validation feedback message context
              if (_ageValidationError != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Text(
                    _ageValidationError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              if (widget.type != FormType.create) ...[
                Text(
                  'Status: ${_selectedStatus.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
              ],
              if (_premiumAmountController.text.isNotEmpty) ...[
                Text(
                  'Premium: ${_premiumAmountController.text.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
              ],

              filePath.isEmpty
                  ? (isReadOnly
                        ? const Text('No document uploaded.')
                        : FilePickerView(
                            onPickDocument: (path) {
                              setState(() {
                                filePath = path;
                              });
                            },
                            extensions: ['pdf'],
                            label: 'Upload Doc',
                          ))
                  : ListTile(
                      leading: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                      ),
                      title: Text(filePath.split('/').last),
                      trailing: isReadOnly
                          ? null
                          : IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onPressed: () => setState(() => filePath = ''),
                            ),
                    ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleAction,
                  child: Text(
                    widget.type == FormType.detail ? 'Back' : 'Save Policy',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
