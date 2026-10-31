// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sound_center/features/cloud/presentation/Widgets/track_template/cloud_history_list.dart';
import 'package:sound_center/features/cloud/presentation/Widgets/track_template/cloud_list_template.dart';
import 'package:sound_center/features/cloud/presentation/Widgets/track_template/cloud_tool_bar.dart';
import 'package:sound_center/features/cloud/presentation/bloc/cloud_bloc.dart';
import 'package:sound_center/features/cloud/presentation/bloc/cloud_status.dart';
import 'package:sound_center/shared/widgets/loading.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';

class CloudSearchController {
  static final ValueNotifier<bool> showSearchField = ValueNotifier(true);
}

class CloudPage extends StatelessWidget {
  const CloudPage({super.key});

  bool resetCloudPage(BuildContext context) {
    final bloc = BlocProvider.of<CloudBloc>(context);
    final status = bloc.state.status;
    CloudSearchController.showSearchField.value = false;
    if (status is! CloudHistory) {
      bloc.add(LoadHistory());
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CloudToolBar(),
        const _SoundCloudLanguageBar(),
        const SizedBox(height: 6),
        Expanded(
          child: BlocBuilder<CloudBloc, CloudState>(
            builder: (BuildContext context, CloudState state) {
              if (state.status is SearchResultStatus) {
                SearchResultStatus status = state.status as SearchResultStatus;
                return CloudListTemplate(status.searchResult);
              }
              if (state.status is CloudHistory) {
                CloudHistory status = state.status as CloudHistory;
                return CloudHistoryList(history: status.history);
              }
              return const Loading();
            },
          ),
        ),
      ],
    );
  }
}

class _SoundCloudLanguageBar extends StatefulWidget {
  const _SoundCloudLanguageBar();

  @override
  State<_SoundCloudLanguageBar> createState() => _SoundCloudLanguageBarState();
}

class _SoundCloudLanguageBarState extends State<_SoundCloudLanguageBar> {
  String _selectedLanguage = 'All';

  static const List<Map<String, String>> _languages = [
    {'name': 'All', 'label': '⚡ Discover', 'query': 'Trending'},
    {'name': 'Hindi', 'label': '🇮🇳 हिन्दी (Hindi)', 'query': 'Hindi Hits'},
    {'name': 'Telugu', 'label': '🎬 తెలుగు (Telugu)', 'query': 'Telugu Hits'},
    {'name': 'Tamil', 'label': '🎵 தமிழ் (Tamil)', 'query': 'Tamil Hits'},
    {'name': 'Urdu', 'label': '🎙️ اردو (Urdu)', 'query': 'Urdu Melodies'},
    {'name': 'English', 'label': '🌍 English', 'query': 'English Top Hits'},
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CloudBloc>(context);
    final theme = Theme.of(context);
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _languages.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final lang = _languages[index];
          final isSelected = _selectedLanguage == lang['name'];
          return ChoiceChip(
            showCheckmark: false,
            label: Text(
              lang['label']!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
            selected: isSelected,
            selectedColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedLanguage = lang['name']!);
                if (lang['name'] == 'All') {
                  bloc.add(LoadHistory());
                } else {
                  bloc.add(
                    SearchCloud(
                      queryText: lang['query']!,
                      filter: SearchFilter.none,
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
