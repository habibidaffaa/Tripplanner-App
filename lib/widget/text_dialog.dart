import 'package:flutter/material.dart';
import 'package:iterasi1/resource/custom_colors.dart';

Future<T?> showTextDialog<T>(
  BuildContext context, {
  required String title,
  required String value,
}) =>
    showDialog<T>(
      context: context,
      builder: (context) => TextDialogWidget(
        title: title,
        value: value,
      ),
    );

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;
  const TextDialogWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  State<TextDialogWidget> createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController controller;
  String? errorText;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
    isButtonEnabled = _isInputValid(widget.value);
  }

  bool _isInputValid(String input) {
    return input.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              onChanged: (value) {
                setState(() {
                  isButtonEnabled = _isInputValid(value);
                  if (!isButtonEnabled) {
                    errorText = "Judul tidak boleh kosong!";
                  } else {
                    errorText = null;
                  }
                });
              },
              decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  hintText: 'Cth. Trip Bromo',
                  errorText: errorText,
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: CustomColor.primary, width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.disabled)) {
                            return Colors.grey;
                          }
                          return CustomColor
                              .buttonColor; // Return the default color
                        }),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: isButtonEnabled
                        ? () {
                            Navigator.of(context).pop(controller.text);
                          }
                        : null,
                    child: const Text(
                      'Selesai',
                      style: TextStyle(color: CustomColor.surface),
                    )),
              ),
            ),
          ],
        ),
      );
}
