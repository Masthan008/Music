import 'dart:async';
import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_center/features/podcast/data/source/featured_podcasts.dart';
import 'package:sound_center/features/podcast/domain/entity/subscription_entity.dart';
import 'package:sound_center/features/podcast/presentation/bloc/podcast_bloc.dart';
import 'package:sound_center/features/podcast/presentation/pages/podcast_detail/podcast_detail.dart';
import 'package:sound_center/features/podcast/presentation/widgets/podcast_templates/subscribed/subscribe_template.dart';

class SubscribedPodcastList extends StatelessWidget {
  const SubscribedPodcastList(this.podcasts, {super.key});

  final List<SubscriptionEntity> podcasts;

  @override
  Widget build(BuildContext context) {
    Completer<void>? refreshCompleter;
    final bloc = BlocProvider.of<PodcastBloc>(context);
    final int count = math.max(3, MediaQuery.widthOf(context) ~/ 130);
    final bool isFeatured = podcasts.isEmpty;
    final displayList = isFeatured ? FeaturedPodcasts.popularPodcasts : podcasts;

    return RefreshIndicator(
      onRefresh: () async {
        refreshCompleter = Completer<void>();
        bloc.add(CheckPodcastUpdates(refreshCompleter));
        return refreshCompleter!.future;
      },
      child: CustomScrollView(
        slivers: [
          if (isFeatured)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.podcasts_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Featured Podcasts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final podcast = displayList[index];
                  return InkWell(
                    key: Key(podcast.feedUrl),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PodcastDetail(
                            feedUrl: podcast.feedUrl,
                            defaultImg: podcast.artworkUrl,
                            needToUpdate: podcast.haveNewEpisode,
                          ),
                        ),
                      );
                      bloc.add(GetSubscribedPodcasts());
                    },
                    child: SubscribeTemplate(podcast: podcast),
                  );
                },
                childCount: displayList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
