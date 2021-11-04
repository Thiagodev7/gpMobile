import 'package:flutter/material.dart';

import 'package:gpmobile/src/widgets/sign/responsive_ui.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final String labelText;
  final TextStyle labelStyle;
  final IconData icon;
  final bool readOnly;
  final Widget suffixIcon;

  const CustomTextField(
      {@required this.hint,
      @required this.textEditingController,
      @required this.keyboardType,
      @required this.icon,
      bool obscureText,
      FormFieldValidator<String> validator,
      InputDecoration decoration,
      this.suffixIcon,
      this.readOnly = false,
      this.labelText,
      this.labelStyle});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  double _width;

  double _pixelRatio;

  bool large;

  bool medium;

  @override
  Widget build(BuildContext context) {
    String campoVazio = 'Campo não pode ser vazio!';
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => (value),
        validator: (value) => (value),
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        cursorColor: Colors.orange[200],
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: widget.labelStyle,
          prefixIcon: Icon(widget.icon, color: Colors.orange[200], size: 20),
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2, color: Colors.red, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          errorStyle: TextStyle(
            height: 2,
            fontSize: 16.0,
            color: Color(0xFFC42224),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
