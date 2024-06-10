import 'dart:io';

import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:path/path.dart' as path;

class ProfileImage extends StatefulWidget {
  final VoidCallback? onTap;

  final bool showOverlayUponHover;
  final IconData overlayIcon;

  final String? filePath;

  final double size;

  const ProfileImage({
    super.key,
    this.size = 90.0,
    this.onTap,
    required this.filePath,
    this.showOverlayUponHover = false,
    this.overlayIcon = Symbols.add_a_photo_rounded,
  });

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  bool showOverlay = false;

  @override
  Widget build(BuildContext context) {
    final file = widget.filePath == null
        ? null
        : File(path.join(ObjectBox.appDataDirectory, widget.filePath!));

    final child = ClipOval(
      child: Container(
        color: context.colorScheme.primary,
        child: file?.existsSync() == true
            ? Image.file(
                file!,
                width: widget.size,
                height: widget.size,
              )
            : FinIcon(
                const IconFinIcon(Symbols.person_rounded),
                size: widget.size,
                color: context.colorScheme.onPrimary,
              ),
      ),
    );

    if (widget.onTap == null) {
      return child;
    }

    return MouseRegion(
      onEnter: widget.showOverlayUponHover
          ? (event) =>
              setState(() => showOverlay = event.distance <= widget.size)
          : null,
      onExit: widget.showOverlayUponHover
          ? (event) => setState(() => showOverlay = false)
          : null,
      child: Stack(
        children: [
          child,
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(999.9),
            child: AnimatedOpacity(
              opacity: showOverlay ? 1.0 : 0,
              duration: const Duration(milliseconds: 200),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x40000000),
                ),
                child: SizedBox.square(
                  dimension: widget.size,
                  child: Icon(
                    widget.overlayIcon,
                    size: widget.size / 2,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
