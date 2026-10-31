import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';
import 'package:sound_center/core/constants/constants.dart';
import 'package:sound_center/features/cloud/data/repository/cloud_player_rpository_imp.dart';
import 'package:sound_center/features/cloud/domain/entity/cloud_entity.dart';
import 'package:sound_center/features/cloud/presentation/Widgets/track_template/cloud_action_menu.dart';
import 'package:sound_center/features/cloud/presentation/Widgets/track_template/cloud_item_template.dart';
import 'package:sound_center/features/cloud/presentation/bloc/cloud_bloc.dart';
import 'package:sound_center/features/cloud/presentation/pages/playlist_info/playlist_detail.dart';
import 'package:sound_center/generated/l10n.dart';
import 'package:sound_center/shared/theme/themes.dart';
import 'package:sound_center/shared/widgets/network_image.dart';

class CloudListTemplate extends StatelessWidget {
  const CloudListTemplate(this.items, {super.key});

  final CloudEntity items;
  static const double _minPlaylistRowHeight = 90.0;
  static const double _sectionSpacing = 12.0;
  static const _sectionTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  bool _isValidItem(dynamic item) =>
      item is CloudTrack || item is CloudPlaylist;

  @override
  Widget build(BuildContext context) {
    final playerRepo = CloudPlayerRepositoryImp();
    if (items.playlists.isEmpty && items.tracks.isEmpty) {
      final genres = [
        'Trending',
        'Top 50 Pop',
        'Bollywood Hits',
        'Lo-Fi Beats',
        'Electronic',
        'Hip-Hop',
        'Acoustic',
        'Devotional',
      ];
      final bloc = BlocProvider.of<CloudBloc>(context);
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_queue_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Discover Music on SoundCloud',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap a genre to search and stream tracks instantly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: genres.map((genre) {
                  return ActionChip(
                    avatar: Icon(
                      Icons.music_note_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(genre),
                    onPressed: () {
                      bloc.add(
                        SearchCloud(
                          queryText: genre,
                          filter: SearchFilter.none,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }
    final currentAudio = playerRepo.getCurrentTrack;
    final bool hasTracks = items.tracks.isNotEmpty;
    final bool hasPlaylists = items.playlists.isNotEmpty;

    final double playlistRowHeight = ((MediaQuery.heightOf(context) / 100) * 20)
        .clamp(_minPlaylistRowHeight, double.infinity);

    return CustomScrollView(
      slivers: [
        if (hasPlaylists) ...[
          SliverPadding(
            padding: const EdgeInsetsDirectional.only(
              start: 8.0,
              top: 8.0,
              bottom: 6.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(S.of(context).playlists, style: _sectionTitleStyle),
            ),
          ),
          if (!hasTracks)
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 120),
              sliver: SliverFixedExtentList(
                itemExtent: LIST_ITEM_HEIGHT,
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildVerticalPlaylistItem(context, index),
                  childCount: items.playlists.length,
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: SizedBox(
                height: playlistRowHeight,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemCount: items.playlists.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final item = items.playlists[index];
                    if (!_isValidItem(item)) return const SizedBox.shrink();
                    return SizedBox(
                      width: playlistRowHeight,
                      child: _HorizontalPlaylistCard(
                        key: ValueKey(item.id),
                        title: item.title,
                        artworkUrl: item.artworkUrl,
                        heroTag: item.id,
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) => CloudActionMenu(track: item),
                          );
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlaylistDetail(playlist: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: _sectionSpacing)),
        ],
        if (hasTracks) ...[
          SliverPadding(
            padding: const EdgeInsetsDirectional.only(start: 8.0, bottom: 6.0),
            sliver: SliverToBoxAdapter(
              child: Text(S.of(context).tracks, style: _sectionTitleStyle),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 120),
            sliver: SliverFixedExtentList(
              itemExtent: LIST_ITEM_HEIGHT,
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = items.tracks[index];
                final isCurrent = currentAudio?.id == item.id;
                if (!_isValidItem(item)) return const SizedBox.shrink();
                return Material(
                  key: ValueKey(item.id),
                  color: isCurrent
                      ? ThemeManager.current.mediaColor
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<CloudBloc>(
                        context,
                      ).add(PlayTrack(tracks: items.tracks, index: index));
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => CloudActionMenu(track: item),
                      );
                    },
                    child: CloudItemTemplate(item: item),
                  ),
                );
              }, childCount: items.tracks.length),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVerticalPlaylistItem(BuildContext context, int index) {
    final item = items.playlists[index];
    if (!_isValidItem(item)) return const SizedBox.shrink();
    return InkWell(
      key: ValueKey(item.id),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) => CloudActionMenu(track: item),
        );
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PlaylistDetail(playlist: item)),
        );
      },
      child: CloudItemTemplate(item: item),
    );
  }
}

class _HorizontalPlaylistCard extends StatelessWidget {
  const _HorizontalPlaylistCard({
    super.key,
    required this.title,
    required this.artworkUrl,
    required this.heroTag,
    required this.onTap,
    required this.onLongPress,
  });

  final String title;
  final String? artworkUrl;
  final Object heroTag;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: NetworkCacheImage(
                      url: artworkUrl,
                      size: null,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
