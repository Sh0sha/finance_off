import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/utils/utils.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/general/list_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class SelectImageIconList extends StatefulWidget {
  final FinIconData? initialValue;

  final double iconSize;

  const SelectImageIconList({
    super.key,
    this.initialValue,
    required this.iconSize,
  });

  @override
  State<SelectImageIconList> createState() =>
      _SelectImageIconListState();
}

class _SelectImageIconListState extends State<SelectImageIconList> {
  late final VoidCallback? cleanUpImage;

  ImageFinIcon? value;

  bool busy = false;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue is ImageFinIcon
        ? widget.initialValue as ImageFinIcon
        : null;

    if (value != null) {
      final String initialImagePath = value!.imagePath;

      cleanUpImage = () {
        // If the image hasn't changed, no need to delete it.
        if (value != null) {
          if (value!.imagePath == initialImagePath) {
            return;
          }
        }

        File(
          path.join(
            ObjectBox.appDataDirectory,
            initialImagePath,
          ),
        ).deleteSync();
      };
    } else {
      cleanUpImage = null;
    }
  }

  @override
  void dispose() {
    if (cleanUpImage != null) {
      cleanUpImage!();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListModal(
      title: Text("flowIcon.type.image".t(context)),
      trailing: ButtonBar(
        children: [
          TextButton.icon(
            onPressed: () => context.pop(value),
            icon: const Icon(Symbols.check_rounded),
            label: Text(
              "general.done".t(context),
            ),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24.0),
          FinIcon(
            value ?? FinIconData.icon(Symbols.image_rounded),
            size: widget.iconSize,
            plated: true,
            onTap: updatePicture,
          ),
          const SizedBox(height: 8.0),
          TextButton.icon(
            onPressed: updatePicture,
            icon: const Icon(Symbols.add_photo_alternate_rounded),
            label: Text(
              "flowIcon.type.image.pick".t(context),
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  void updatePicture() async {
    if (busy) return;

    setState(() {
      busy = true;
    });

    try {
      final cropped = await pickAndCropSquareImage(context, maxDimension: 256);
      if (cropped == null) {
        // Error toast is handled in `pickAndCropSquareImage`
        return;
      }

      final byteData = await cropped.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      if (bytes == null) throw "";

      final dataDirectory = ObjectBox.appDataDirectory;
      final fileName = "${const Uuid().v4()}.png";
      final file = File(path.join(
        dataDirectory,
        "images",
        fileName,
      ));
      await file.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);

      value = ImageFinIcon.ImageFinIcon("images/$fileName");
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      log("[Select Icon Sheet] uploadPicture has failed due to: $e");
    } finally {
      busy = false;
      if (mounted) setState(() {});
    }
  }
}
