import 'package:sound_center/features/stream/domain/entity/stream_sub_entity.dart';

class FeaturedStations {
  static List<StreamSubEntity> get indianFeaturedStations => [
        StreamSubEntity(
          title: 'AIR Vividh Bharati',
          url: 'https://air.pc.cdn.bitgravity.com/air/live/pbaudio001/playlist.m3u8',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'air-vividh-bharati',
        ),
        StreamSubEntity(
          title: 'AIR FM Gold (Delhi)',
          url: 'https://air.pc.cdn.bitgravity.com/air/live/pbaudio002/playlist.m3u8',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'air-fm-gold',
        ),
        StreamSubEntity(
          title: 'Mirchi Top 20 (Hindi Hits)',
          url: 'https://stream.zeno.fm/4e5e4kww0k0uv',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'mirchi-hindi-hits',
        ),
        StreamSubEntity(
          title: 'Bollywood Retro Classics',
          url: 'https://stream.zeno.fm/6s23b2d1p0quv',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'bollywood-retro-classics',
        ),
        StreamSubEntity(
          title: 'Telugu Hits Live',
          url: 'https://stream.zeno.fm/u7m459n9p0quv',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'telugu-hits-live',
        ),
        StreamSubEntity(
          title: 'Tamil Super Hits Radio',
          url: 'https://stream.zeno.fm/wvq7h1xwp8quv',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'tamil-super-hits',
        ),
        StreamSubEntity(
          title: 'Punjabi Dhol & Beats',
          url: 'https://stream.zeno.fm/4q57m3q3e5quv',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'punjabi-dhol-beats',
        ),
        StreamSubEntity(
          title: 'BBC World Service News',
          url: 'https://stream.live.vc.bbcmedia.co.uk/bbc_world_service',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'bbc-world-service',
        ),
      ];
}
