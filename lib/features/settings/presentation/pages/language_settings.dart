import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_center/features/settings/data/settings_repository_imp.dart';
import 'package:sound_center/features/settings/presentation/bloc/setting_bloc.dart';
import 'package:sound_center/shared/widgets/glass.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  late final SettingsRepositoryImp settingsRepository;
  late Locale locale;
  late final SettingBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<SettingBloc>(context);
    settingsRepository = SettingsRepositoryImp();
    locale = settingsRepository.getLocale();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Glass(
          borderRadius: 24,
          elevation: 8,
          useBorder: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select Language',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RadioGroup<Locale>(
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => locale = v);
                    bloc.add(ChangeLocale(locale));
                  },
                  groupValue: locale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      radioItem(const Locale("en"), "English"),
                      radioItem(const Locale("hi"), "हिन्दी (Hindi)"),
                      radioItem(const Locale("te"), "తెలుగు (Telugu)"),
                      radioItem(const Locale("ta"), "தமிழ் (Tamil)"),
                      radioItem(const Locale("bn"), "বাংলা (Bengali)"),
                      radioItem(const Locale("fa"), "فارسی (Persian)"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget radioItem(Locale itemLocale, String languageName) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() => locale = itemLocale);
        bloc.add(ChangeLocale(itemLocale));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: [
            Radio<Locale>(value: itemLocale),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                languageName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
