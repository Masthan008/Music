import 'package:material_ui/material_ui.dart';
import 'package:sound_center/features/settings/data/settings_repository_imp.dart';
import 'package:sound_center/features/settings/domain/settings_repository.dart';
import 'package:sound_center/generated/l10n.dart';
import 'package:sound_center/shared/widgets/glass.dart';
import 'package:sound_center/shared/widgets/text_field_box.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderSettings extends StatefulWidget {
  const ProviderSettings({super.key});

  @override
  State<ProviderSettings> createState() => _ProviderSettingsState();
}

class _ProviderSettingsState extends State<ProviderSettings> {
  late final CustomTextEditingController key;
  late final CustomTextEditingController secret;
  late final SettingsRepositoryImp settingsRepository;
  late PodcastProvider provider;

  @override
  void initState() {
    super.initState();
    key = CustomTextEditingController(
      validator: (text) {
        return text?.isNotEmpty ?? false;
      },
    );
    secret = CustomTextEditingController(
      validator: (text) {
        return text?.isNotEmpty ?? false;
      },
    );
    settingsRepository = SettingsRepositoryImp();
    provider = settingsRepository.getPodcastProvider();
    Map<String, String>? podcastIndexInfo = settingsRepository
        .getPodcastIndexKeys();
    if (podcastIndexInfo != null) {
      key.text = podcastIndexInfo['key'] ?? "";
      secret.text = podcastIndexInfo['secret'] ?? "";
    }
  }

  @override
  void dispose() {
    key.dispose();
    secret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Glass(
        borderRadius: 20,
        elevation: 8,
        useBorder: true,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
          child: Column(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).selectProvider),
              const SizedBox(height: 5),
              RadioGroup<PodcastProvider>(
                groupValue: provider,
                onChanged: (p) => setState(() => provider = p!),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => provider = PodcastProvider.itunes),
                      child: Row(
                        children: [
                          Radio<PodcastProvider>(value: PodcastProvider.itunes),
                          const Text("iTunes"),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => provider = PodcastProvider.podcatIndex),
                      child: Row(
                        children: [
                          Radio<PodcastProvider>(value: PodcastProvider.podcatIndex),
                          const Text("Podcast Index"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (provider == PodcastProvider.podcatIndex) ...[
                TextFieldBox(controller: key, hintText: "Key"),
                const SizedBox(height: 10),
                TextFieldBox(controller: secret, hintText: "Secret"),
              ],
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      submit();
                      Navigator.pop(context);
                    },
                    child: Text(S.of(context).submit),
                  ),
                  if (provider == PodcastProvider.podcatIndex)
                    ElevatedButton(
                      onPressed: () async {
                        final Uri url = Uri.parse("https://api.podcastindex.org");
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      },
                      child: Text(S.of(context).getApiKey),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    settingsRepository.setPodcastIndexKeys(key.text.trim(), secret.text.trim());
    if (provider == PodcastProvider.podcatIndex) {
      if (!(key.isValid() && secret.isValid())) return;
    }
    settingsRepository.setPodcastProvider(provider);
  }
}
