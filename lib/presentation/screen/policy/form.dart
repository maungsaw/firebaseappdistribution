import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.type != FormType.create && widget.data != null) {
      _policyNoController.text = widget.data!.no;
    }
  }

  @override
  void dispose() {
    _policyNoController.dispose();
    super.dispose();
  }

  void _handleAction() {
    if (widget.type == FormType.detail) {
      context.pop();
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final policyNo = _policyNoController.text.trim();

    if (widget.type == FormType.create) {
      context.read<PolicyBloc>().add(
        NewPolicyEvent(policyNo, PolicyStatus.draft.label),
      );
    } else if (widget.type == FormType.edit && widget.data != null) {
      final updatedPolicy = widget.data!.copyWith(no: policyNo);
      context.read<PolicyBloc>().add(UpdatePolicyEvent(updatedPolicy));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PolicyBloc, PolicyState>(
      listener: (context, state) {
        if (state is SuccessPolicyState) {
          context.pop();
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _policyNoController,
                readOnly: widget.type == FormType.detail,
                decoration: const InputDecoration(
                  labelText: 'Policy Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a policy number'
                    : null,
              ),
              const SizedBox(height: 20),
              if (widget.type != FormType.create) ...[
                Text('Status: ${widget.data?.status ?? 'N/A'}'),
                const SizedBox(height: 20),
              ],
              OutlinedButton(
                onPressed: _handleAction,
                child: Text(widget.type == FormType.detail ? 'Back' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
