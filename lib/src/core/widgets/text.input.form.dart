import 'package:flutter/material.dart';

class TextInputForm extends StatefulWidget {
  const TextInputForm({
    Key? key,
    this.label,
    required this.placeholder,
    this.error,
    this.focusNode,
    this.enabled = true,
    this.initialValue,
    required this.onChanged,
    this.suffixText,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.maxLines = 1,
    this.elevation = 0,
    this.radius = 0,
    this.validator,
    this.minLines = 1,
    this.focusedBorderWidth,
    this.focusedBorderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keybardType,
    this.textInputAction,
    this.fillColor,
  }) : super(key: key);

  final Color? fillColor;
  final String? label;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final bool obscureText;
  final double radius;
  final double elevation;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FloatingLabelBehavior floatingLabelBehavior;
  final String? initialValue;
  final String? suffixText;
  final String placeholder;
  final TextInputType? keybardType;
  final Function(String val) onChanged;
  final String? error;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final double? focusedBorderWidth;
  final Color? focusedBorderColor;

  @override
  State<TextInputForm> createState() => _TextInputFormState();
}

class _TextInputFormState extends State<TextInputForm> {
  String? initialValue;
  @override
  void initState() {
    initialValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(widget.radius))),
          child: TextFormField(
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            keyboardType: widget.keybardType ?? TextInputType.multiline,
            minLines: widget.minLines,
            focusNode: widget.focusNode,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            initialValue: initialValue,
            textDirection: TextDirection.ltr,
            validator: widget.validator,
            textAlign: TextAlign.start,
            obscureText: widget.obscureText,
            textInputAction: widget.textInputAction ??
                (widget.maxLines > 1
                    ? TextInputAction.newline
                    : TextInputAction.done),
            decoration: InputDecoration(
              focusColor: Colors.grey.shade800,
              hintText: widget.placeholder,
              suffixText: widget.suffixText,
              errorMaxLines: 3,
              prefixIcon: widget.prefixIcon,

              suffixIcon: widget.suffixIcon,
              // constraints: BoxConstraints(maxHeight: 42),
              filled: true, fillColor: widget.fillColor ?? Colors.transparent,
              labelText: widget.label,
              labelStyle: TextStyle(color: Colors.grey.shade700),
              floatingLabelBehavior: widget.floatingLabelBehavior,

              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: widget.focusedBorderWidth ?? 0.3,
                      color: widget.focusedBorderColor ?? Colors.grey.shade300),
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.radius))),
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.grey.shade400),
              enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(width: 0.3, color: Colors.grey.shade300),
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.radius))),
              border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(width: 0.3, color: Colors.grey.shade300),
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.radius))),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: (widget.maxLines > 1) ? 14 : 0),
              // errorText:     !validCode ? widget.tr('field_required') : null,
            ),
            onChanged: (val) {
              widget.onChanged(val);
            },
          ),
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            child: Text(
              widget.error!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.red),
            ),
          )
      ],
    );
  }
}
