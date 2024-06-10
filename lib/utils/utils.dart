import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/routes/utils/obrezka_image.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/utils/toast.dart';
import 'package:financeOFF/widgets/general/button.dart';
import 'package:financeOFF/widgets/general/list_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
export 'extensions.dart';

Future<bool> openUrl(
  Uri uri, [
  LaunchMode mode = LaunchMode.externalApplication,
]) async {
  final canOpen = await canLaunchUrl(uri);
  if (!canOpen) return false;

  try {
    return await launchUrl(uri);
  } catch (e) {
    log("[Fin] Не удалось запустить uri ($uri) из-за $e");
    return false;
  }
}

void numpadHaptic() {
  HapticFeedback.mediumImpact();
}

Future<File?> pickJsonFile({String? dialogTitle}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    dialogTitle: dialogTitle ?? "Выберите файл резервной копии",
    initialDirectory: await getApplicationDocumentsDirectory()
        .then<String?>((value) => value.path)
        .catchError((_) => null),
    allowedExtensions: ["json"],
    type: FileType.custom,
    allowMultiple: false,
  );

  if (result == null) {
    return null;
  }

  return File(result.files.single.path!);
}

extension CustomDialogs on BuildContext {
  Future<bool?> showConfirmDialog({
    Function(bool?)? callback,
    String? title,
    String? mainActionLabelOverride,
    bool isDeletionConfirmation = false,
    Widget? child,
  }) async {
    final bool? result = await showModalBottomSheet(
      context: this,
      builder: (context) => ListModal(
        title: Text(title ?? "general.areYouSure".t(context)),
        trailing: ButtonBar(
          children: [
            Button(
              onTap: () => context.pop(false),
              child: Text(
                "general.cancel".t(context),
              ),
            ),
            Button(
              onTap: () => context.pop(true),
              child: Text(
                mainActionLabelOverride ??
                    (isDeletionConfirmation
                        ? "general.delete".t(context)
                        : "general.confirm".t(context)),
                style: isDeletionConfirmation
                    ? TextStyle(color: context.flowColors.rashod)
                    : null,
              ),
            ),
          ],
        ),
        child: child ??
            (isDeletionConfirmation
                ? Text(
                    "general.delete.permanentWarning".t(context),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.flowColors.rashod,
                    ),
                    textAlign: TextAlign.center,
                  )
                : null),
      ),
    );

    if (callback != null) {
      callback(result);
    }

    return result;
  }
}

Future<XFile?> pickImage({
  ImageSource source = ImageSource.gallery,
  double? maxWidth,
  double? maxHeight,
}) async {
  final xfile = ImagePicker().pickImage(
    source: source,
    maxHeight: maxHeight,
    maxWidth: maxWidth,
    requestFullMetadata: false,
    imageQuality: 100,
  );

  return xfile;
}

Future<ui.Image?> pickAndCropSquareImage(
  BuildContext context, {
  double? maxDimension,
}) async {
  final xfile = await pickImage(
    maxWidth: 512,
    maxHeight: 512,
  );

  if (xfile == null) {
    if (context.mounted) {
      context.showErrorToast(error: "error.input.noImagePicked".t(context));
    }
    return null;
  }
  if (!context.mounted) return null;

  final image = Image.file(File(xfile.path));

  final cropped = await context.push<ui.Image>(
    "/utils/cropsquare",
    extra: CropSquareImagePageProps(image: image),
  );

  if (cropped == null) {
    if (context.mounted) {
      context.showErrorToast(error: "error.input.cropFailed".t(context));
    }
    return null;
  }

  return cropped;
}

bool isDesktop() {
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}

String getDecimalSeparatorForCurrency(String? currency) {
  return currency == null
      ? "."
      : NumberFormat.simpleCurrency(name: currency).symbols.DECIMAL_SEP;
}
