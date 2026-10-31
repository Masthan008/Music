// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sound_center/features/cloud/presentation/Widgets/track_template/cloud_history_list.dart';
import 'package:sound_center/features/cloud/presentation/Widgets/track_template/cloud_list_template.dart';
import 'package:sound_center/features/cloud/presentation/Widgets/track_template/cloud_tool_bar.dart';
import 'package:sound_center/features/cloud/presentation/bloc/cloud_bloc.dart';
import 'package:sound_center/features/cloud/presentation/bloc/cloud_status.dart';
import 'package:sound_center/shared/widgets/glass_pill.dart';
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

  static const List<Map<String, dynamic>> _languages = [
    {
      'id': 'All',
      'label': 'Discover',
      'icon': Icons.auto_awesome_rounded,
      'query': 'Trending',
    },
    {
      'id': 'Hindi',
      'label': 'हिन्दी (Hindi)',
      'icon': Icons.language_rounded,
      'query': 'Hindi Hits',
    },
    {
      'id': 'Telugu',
      'label': 'తెలుగు (Telugu)',
      'icon': Icons.movie_filter_rounded,
      'query': 'Telugu Hits',
    },
    {
      'id': 'Tamil',
      'label': 'தமிழ் (Tamil)',
      'icon': Icons.music_note_rounded,
      'query': 'Tamil Hits',
    },
    {
      'id': 'Urdu',
      'label': 'اردو (Urdu)',
      'icon': Icons.mic_external_on_rounded,
      'query': 'Urdu Melodies',
    },
    {
      'id': 'Punjabi',
      'label': 'ਪੰਜਾਬੀ (Punjabi)',
      'icon': Icons.queue_music_rounded,
      'query': 'Punjabi Hits',
    },
    {
      'id': 'English',
      'label': 'English Hits',
      'icon': Icons.public_rounded,
      'query': 'English Top Hits',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CloudBloc>(context);
    final items = _languages
        .map(
          (lang) => GlassPillItem(
            id: lang['id'] as String,
            label: lang['label'] as String,
            icon: lang['icon'] as IconData,
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GlassPillBar(
        height: 38,
        items: items,
        selectedId: _selectedLanguage,
        onSelected: (id) {
          setState(() => _selectedLanguage = id);
          if (id == 'All') {
            bloc.add(LoadHistory());
          } else {
            final lang = _languages.firstWhere((l) => l['id'] == id);
            bloc.add(
              SearchCloud(
                queryText: lang['query'] as String,
                filter: SearchFilter.none,
              ),
            );
          }
        },
      ),
    );
  }
}
