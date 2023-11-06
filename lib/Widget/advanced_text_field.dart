import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum TypingStatus { typing, stopped }

class AdvancedTextField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<TypingStatus>? onStatusChange;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;

  const AdvancedTextField({
    Key? key,
    this.onStatusChange,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.hintText,
  }) : super(key: key);

  @override
  _AdvancedTextFieldState createState() => _AdvancedTextFieldState();
}

class _AdvancedTextFieldState extends State<AdvancedTextField> {
  late final BehaviorSubject<String> _streamController;
  late final FocusNode _focusNode;
  bool _started = false;
  bool _stopped = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    _streamController = BehaviorSubject<String>();
    final stream = _streamController.stream;


    stream.debounceTime(const Duration(milliseconds: 800)).listen((s) {
      if (!_started) {
        _started = true;
        _stopped = false;
        widget.onStatusChange?.call(TypingStatus.typing);
      } else {
        _started = false;
        _stopped = true;
        widget.onStatusChange?.call(TypingStatus.stopped);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (value) {
        widget.onChanged?.call(value);
        _streamController.add(value);
      },
      onSubmitted: (value) {
        widget.onSubmitted?.call(value);
        _focusNode.requestFocus();
      },
      controller: widget.controller,
      decoration: InputDecoration(hintText: widget.hintText),
    );
  }
}
