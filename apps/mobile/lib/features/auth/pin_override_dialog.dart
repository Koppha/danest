import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/session.dart';
import '../../data/local/auth_repository.dart';

/// A logged-in attendant can perform a sensitive action (cancel a wash,
/// void a payment, a manual loyalty adjustment) by having a supervisor
/// type *their own* PIN into the device, without swapping logged-in
/// accounts — mirrors the backend's PinOverrideGuard rule exactly.
///
/// Returns the approving user's id and the reason given, or null if the
/// dialog was cancelled.
Future<({String approvedByUserId, String reason})?> showPinOverrideDialog(
  BuildContext context,
  WidgetRef ref, {
  required String actionDescription,
}) {
  return showDialog<({String approvedByUserId, String reason})>(
    context: context,
    builder: (ctx) => _PinOverrideDialog(ref: ref, actionDescription: actionDescription),
  );
}

class _PinOverrideDialog extends StatefulWidget {
  final WidgetRef ref;
  final String actionDescription;
  const _PinOverrideDialog({required this.ref, required this.actionDescription});

  @override
  State<_PinOverrideDialog> createState() => _PinOverrideDialogState();
}

class _PinOverrideDialogState extends State<_PinOverrideDialog> {
  final _pinController = TextEditingController();
  final _reasonController = TextEditingController();
  final _overrideUsernameController = TextEditingController();
  bool _obscurePin = true;
  bool _submitting = false;
  String? _error;

  Future<void> _submit() async {
    final pin = _pinController.text.trim();
    final reason = _reasonController.text.trim();
    if (pin.isEmpty || reason.isEmpty) {
      setState(() => _error = 'A PIN and a reason are both required.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final currentUserId = widget.ref.read(sessionProvider).user!.id;
      final overrideUsername = _overrideUsernameController.text.trim();
      final approvedByUserId = await widget.ref.read(authRepositoryProvider).verifyPinOverride(
            pin: pin,
            overrideUsername: overrideUsername.isEmpty ? null : overrideUsername,
            currentUserId: currentUserId,
          );
      if (mounted) Navigator.of(context).pop((approvedByUserId: approvedByUserId, reason: reason));
    } on InvalidPinOverrideException catch (e) {
      setState(() => _error = e.toString());
    } catch (e) {
      setState(() => _error = 'Could not verify: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Supervisor approval required'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.actionDescription} needs a supervisor (or above) to approve with their PIN.'),
          const SizedBox(height: 16),
          TextField(
            controller: _overrideUsernameController,
            decoration: const InputDecoration(labelText: 'Approving username (leave blank if it\'s you)'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pinController,
            obscureText: _obscurePin,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'PIN',
              suffixIcon: IconButton(
                icon: Icon(_obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscurePin = !_obscurePin),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(controller: _reasonController, decoration: const InputDecoration(labelText: 'Reason')),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Approve'),
        ),
      ],
    );
  }
}
