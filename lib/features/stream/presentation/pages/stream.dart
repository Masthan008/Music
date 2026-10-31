import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sound_center/features/stream/data/source/featured_stations.dart';
import 'package:sound_center/features/stream/domain/entity/stream_sub_entity.dart';
import 'package:sound_center/features/stream/presentation/bloc/stream_bloc.dart';
import 'package:sound_center/features/stream/presentation/bloc/stream_status.dart';
import 'package:sound_center/features/stream/presentation/pages/stream_detail/stream_detail.dart';
import 'package:sound_center/features/stream/presentation/widgets/radio/stream_action_menu.dart';
import 'package:sound_center/features/stream/presentation/widgets/stream_template.dart';
import 'package:sound_center/features/stream/presentation/widgets/stream_tool_bar.dart';
import 'package:sound_center/generated/l10n.dart';
import 'package:sound_center/shared/widgets/glass_pill.dart';

class StreamSearchController {
  static final ValueNotifier<bool> showSearchField = ValueNotifier(true);
}

class StreamPage extends StatefulWidget {
  const StreamPage({super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();

  bool resetStreamPage(BuildContext context) {
    final bloc = BlocProvider.of<StreamBloc>(context);
    final status = bloc.state.status;
    StreamSearchController.showSearchField.value = false;
    if (status is! SubscribedStreams) {
      bloc.add(GetSubscribedStreams());
      return false;
    }
    return true;
  }

  void handleDeepLink(BuildContext context, Map<String, String> params) {
    final bloc = BlocProvider.of<StreamBloc>(context);
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (_) => StreamDetail(
          stream: StreamSubEntity(
            title: '',
            url: '',
            startAt: DateTime.now(),
            isOnline: true,
            uuid: params['station']!,
          ),
        ),
      ),
    ).then((_) => bloc.add(GetSubscribedStreams()));
  }
}

class _StreamPageState extends State<StreamPage> {
  Completer<void>? refreshCompleter;
  String _selectedCategory = 'All';

  static const List<Map<String, dynamic>> _streamCategories = [
    {
      'id': 'All',
      'label': 'Featured',
      'icon': Icons.radio_rounded,
    },
    {
      'id': 'Hindi',
      'label': 'हिन्दी (Hindi)',
      'icon': Icons.language_rounded,
      'lang': 'hindi',
    },
    {
      'id': 'Telugu',
      'label': 'తెలుగు (Telugu)',
      'icon': Icons.movie_filter_rounded,
      'lang': 'telugu',
    },
    {
      'id': 'Tamil',
      'label': 'தமிழ் (Tamil)',
      'icon': Icons.music_note_rounded,
      'lang': 'tamil',
    },
    {
      'id': 'Urdu',
      'label': 'اردو (Urdu)',
      'icon': Icons.mic_external_on_rounded,
      'lang': 'urdu',
    },
    {
      'id': 'News',
      'label': 'News',
      'icon': Icons.newspaper_rounded,
      'tag': 'news',
    },
    {
      'id': 'Classical',
      'label': 'Classical',
      'icon': Icons.library_music_rounded,
      'tag': 'classical',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StreamBloc>(context);
    final categoryItems = _streamCategories
        .map(
          (c) => GlassPillItem(
            id: c['id'] as String,
            label: c['label'] as String,
            icon: c['icon'] as IconData,
          ),
        )
        .toList();

    return Column(
      children: [
        const StreamToolBar(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GlassPillBar(
            height: 38,
            items: categoryItems,
            selectedId: _selectedCategory,
            onSelected: (id) {
              setState(() => _selectedCategory = id);
              if (id == 'All') {
                bloc.add(GetSubscribedStreams());
              } else {
                final cat = _streamCategories.firstWhere((c) => c['id'] == id);
                if (cat.containsKey('lang')) {
                  bloc.add(
                    SearchStream(
                      offset: 0,
                      language: cat['lang'] as String,
                    ),
                  );
                } else if (cat.containsKey('tag')) {
                  bloc.add(
                    SearchStream(
                      offset: 0,
                      tag: cat['tag'] as String,
                    ),
                  );
                }
              }
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<StreamBloc, StreamState>(
            buildWhen: (previous, current) {
              bool notDownload =
                  current.status is! ErrorLoadStream &&
                  current.status is! StreamServer;
              return notDownload;
            },
            builder: (BuildContext context, StreamState state) {
              if (state.status is SubscribedStreams) {
                SubscribedStreams status = state.status as SubscribedStreams;
                final bool isFeatured = status.streams.isEmpty;
                final displayStreams = isFeatured
                    ? FeaturedStations.indianFeaturedStations
                    : status.streams;

                return RefreshIndicator(
                  onRefresh: () {
                    refreshCompleter = Completer<void>();
                    BlocProvider.of<StreamBloc>(
                      context,
                    ).add(CheckStreamsStatus(refreshCompleter));
                    return refreshCompleter!.future;
                  },
                  child: ListView.builder(
                    itemCount: displayStreams.length + (isFeatured ? 1 : 0),
                    padding: const EdgeInsets.only(bottom: 120),
                    itemBuilder: (context, index) {
                      if (isFeatured && index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.radio_rounded,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Featured Radio Stations',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final stream = isFeatured
                          ? displayStreams[index - 1]
                          : displayStreams[index];
                      return InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StreamDetail(stream: stream),
                            ),
                          );
                          bloc.add(GetSubscribedStreams());
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) => StreamActionMenu(stream: stream),
                          );
                        },
                        child: StreamTemplate(stats: stream),
                      );
                    },
                  ),
                );
              }
              if (state.status is SearchStreams) {
                SearchStreams status = state.status as SearchStreams;
                if (status.streams.isEmpty) {
                  return Center(child: Text(S.of(context).noStream));
                }
                return ListView.builder(
                  itemCount: status.streams.length,
                  padding: const EdgeInsets.only(bottom: 120),
                  itemBuilder: (context, index) {
                    final stream = status.streams[index];
                    return InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StreamDetail(stream: stream),
                          ),
                        );
                        bloc.add(GetSubscribedStreams());
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (_) => StreamActionMenu(stream: stream),
                        );
                      },
                      child: StreamTemplate(stats: stream),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
