import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerTextField extends StatefulWidget {
  const ColorPickerTextField(
      {super.key,
      required this.textFieldGrobalKey,
      this.title,
      this.helperText})
      : initColor = const Color(0xffffffff),
        width = 200,
        previewIcon = const Icon(Icons.circle),
        colorPickerIcon = const Icon(Icons.color_lens);
  final GlobalKey<FormFieldState<String>> textFieldGrobalKey;
  final String? title;
  final String? helperText;
  final Color initColor;
  final double width;
  final Icon previewIcon;
  final Icon colorPickerIcon;

  @override
  State<ColorPickerTextField> createState() => _ColorPickerTextFieldState();
}

class _ColorPickerTextFieldState extends State<ColorPickerTextField> {
  late Color pickerColor;
  late Color currentColor;
  final _controller = TextEditingController();

  @override
  void initState() {
    pickerColor = widget.initColor;
    currentColor = widget.initColor;
    _controller.text = currentColor.toHexString();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widget.width,
          child: TextFormField(
            // initialValue は使用せずinitStateで初期化
            key: widget.textFieldGrobalKey,
            controller: _controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9a-fA-F]')) // 数字およびa-f,A-Fのみ入力可能
            ],
            validator: (String? value) {
              if (value == null || value.isEmpty) return '値を入力してください。';
              if (value.length != 8) {
                return '8桁(ARGB)で指定してください。';
              }
              // 入力桁と入力文字の制限ですべてチェックできるはずなので不要かも
              if (value.toColor() == null) return '有効な入力値ではありません。';

              return null;
            },
            maxLength: 8,
            decoration: InputDecoration(
                counterText: '',
                // 左端の色プレビュー
                prefixIcon: widget.previewIcon,
                prefixIconColor: _controller.text.toColor(),
                // 右端のカラーピッカー起動ボタン
                suffixIcon: IconButton(
                    onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('決定'),
                                onPressed: () {
                                  setState(() {
                                    currentColor = pickerColor;
                                    _controller.text =
                                        currentColor.toHexString();
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                    icon: widget.colorPickerIcon),
                // その他外観
                border: const OutlineInputBorder(),
                labelText: widget.title,
                helperText: widget.helperText,
                helperMaxLines: 3),
            // テキスト直打ちしたときの処理
            onChanged: (text) => setState(() {
              currentColor = text.toColor() ?? const Color(0xffffffff);
              pickerColor = currentColor;
            }),
            // 桁数が足りない場合Fでパディングする
            onFieldSubmitted: (value) =>
                _controller.text = _controller.text.padLeft(8, 'F'),
            onEditingComplete: () =>
                _controller.text = _controller.text.padLeft(8, 'F'),
            onTapOutside: (event) =>
                _controller.text = _controller.text.padLeft(8, 'F'),
          ),
        )
      ],
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
}
