import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/provider/color_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:provider/provider.dart';

class NanyangColorPicker extends StatefulWidget {
  final Color? color;

  const NanyangColorPicker({super.key, this.color = ColorTemplate.violetBlue});

  @override
  State<NanyangColorPicker> createState() => _NanyangColorPickerState();
}

class _NanyangColorPickerState extends State<NanyangColorPicker> {
  late Color dialogPickerColor;

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: dialogPickerColor,
      onColorChanged: (Color color) => setState(
        () {
          dialogPickerColor = color;
          Provider.of<ColorProvider>(context, listen: false).setColor(color);
        },
      ),
      width: dynamicWidth(40, context),
      height: dynamicHeight(40, context),
      borderRadius: 10,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: dynamicWidth(276, context),
      heading: Text(
        'Pilih Warna',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Pilih warna yang diinginkan',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Pilih warna yang diinginkan',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: false,
      },
    ).showPickerDialog(
      context,
      backgroundColor: ColorTemplate.periwinkle,
      surfaceTintColor: ColorTemplate.violetBlue,
      actionsPadding: dynamicPaddingAll(16, context),
      constraints: BoxConstraints(
          minHeight: dynamicHeight(480, context),
          minWidth: dynamicWidth(300, context),
          maxWidth: dynamicWidth(320, context)),
    );
  }

  @override
  void initState() {
    super.initState();
    dialogPickerColor = Provider.of<ColorProvider>(context, listen: false).color;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: widget.color,
      icon: const Icon(Icons.color_lens),
      onPressed: () async {
        await colorPickerDialog();
      },
    );
  }
}