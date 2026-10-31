import 'package:material_ui/material_ui.dart';
import 'package:sound_center/core/constants/constants.dart';
import 'package:sound_center/features/settings/presentation/pages/about_dialog.dart';
import 'package:sound_center/features/settings/presentation/pages/backup_dialog.dart';
import 'package:sound_center/features/settings/presentation/pages/language_settings.dart';
import 'package:sound_center/features/settings/presentation/pages/notification_settings.dart';
import 'package:sound_center/features/settings/presentation/pages/player_style_settings.dart';
import 'package:sound_center/features/settings/presentation/pages/provider_settings.dart';
import 'package:sound_center/features/settings/presentation/pages/theme_settings.dart';
import 'package:sound_center/generated/l10n.dart';
import 'package:sound_center/shared/widgets/glass.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  void openDialog(BuildContext context, Widget page) {
    showDialog(context: context, builder: (_) => page);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(18.0),
      child: Glass(
        borderRadius: 20,
        elevation: 8,
        useBorder: true,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 5,
              children: [
                Text(S.of(context).settings),
                const Divider(),
                TextButton(
                  onPressed: () => openDialog(context, ProviderSettings()),
                  child: Text(S.of(context).podcastApi),
                ),
                TextButton(
                  onPressed: () => openDialog(context, LanguageSettings()),
                  child: Text(S.of(context).language),
                ),
                TextButton(
                  onPressed: () => openDialog(context, ThemeSettings()),
                  child: Text(S.of(context).theme),
                ),
                TextButton(
                  onPressed: () => openDialog(context, PlayerStyleSettings()),
                  child: Text(S.of(context).playerStyle),
                ),
                TextButton(
                  onPressed: () => openDialog(context, NotificationSettings()),
                  child: Text(S.of(context).notification),
                ),
                TextButton(
                  onPressed: () => openDialog(context, BackupDialog()),
                  child: Text(S.of(context).backupRestore),
                ),
                TextButton(
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationVersion: VERSION_NAME,
                      applicationName: "Sound Center",
                      applicationLegalese:
                          "Sound Center Music Player\nAll-in-one Audio & Streaming Hub\nReleased under GNU GPLv3 License.",
                      applicationIcon: Image.asset(
                        'assets/app.png',
                        width: 30,
                        height: 30,
                      ),
                      children: [AboutDialogBody()],
                    );
                  },
                  child: Text(S.of(context).moreInfo),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
