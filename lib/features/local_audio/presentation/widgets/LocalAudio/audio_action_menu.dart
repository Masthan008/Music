import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sound_center/features/local_audio/domain/entities/audio.dart';
import 'package:sound_center/features/local_audio/presentation/bloc/local_bloc.dart';
import 'package:sound_center/generated/l10n.dart';
import 'package:sound_center/shared/widgets/confirm_dialog.dart';
import 'package:sound_center/shared/widgets/glass.dart';

class AudioActionMenu extends StatelessWidget {
  const AudioActionMenu({super.key, required this.audio});

  final AudioEntity audio;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Glass(
        borderRadius: 20,
        elevation: 8,
        useBorder: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  bool res =
                      await showDialog(
                        context: context,
                        builder: (_) => ConfirmDialog(),
                      ) ??
                      false;
                  if (res && context.mounted) {
                    BlocProvider.of<LocalBloc>(
                      context,
                    ).add(DeleteAudios([audio]));
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text(S.of(context).delete),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (!Platform.isLinux) {
                    try {
                      final file = File(audio.path);
                      if (await file.exists()) {
                        await SharePlus.instance.share(
                          ShareParams(
                            files: [XFile(audio.path, mimeType: 'audio/*')],
                            subject: '${audio.title} - ${audio.artist}',
                          ),
                        );
                      } else {
                        await SharePlus.instance.share(
                          ShareParams(text: '${audio.title} - ${audio.artist}'),
                        );
                      }
                    } catch (_) {
                      try {
                        await SharePlus.instance.share(
                          ShareParams(text: '${audio.title} - ${audio.artist}'),
                        );
                      } catch (_) {}
                    }
                  }
                },
                child: Text(S.of(context).share),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
