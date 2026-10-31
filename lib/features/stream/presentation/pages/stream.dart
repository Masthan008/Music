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

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StreamBloc>(context);
    return Column(
      children: [
        const StreamToolBar(),
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
