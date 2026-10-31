import 'package:sound_center/features/stream/domain/entity/stream_sub_entity.dart';

class FeaturedStations {
  static List<StreamSubEntity> get indianFeaturedStations => [
        StreamSubEntity(
          title: 'AIR Vividh Bharati',
          url:
              'https://air.pc.cdn.bitgravity.com/air/live/pbaudio001/playlist.m3u8',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'air-vividh-bharati',
        ),
        StreamSubEntity(
          title: 'Bolly 92.3FM (Hindi Hits)',
          url: 'http://www.streamcontrol.net:12010/;',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'bolly-923fm',
        ),
        StreamSubEntity(
          title: 'Vividh Bharati 102.8 FM Hyderabad',
          url:
              'https://air.pc.cdn.bitgravity.com/air/live/pbaudio034/playlist.m3u8',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'air-vividh-bharati-hyd',
        ),
        StreamSubEntity(
          title: 'Fnf.Fm Hindi Hits',
          url: 'http://192.99.8.192:5032/;stream',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'fnf-fm-hindi',
        ),
        StreamSubEntity(
          title: 'London Telugu Radio',
          url: 'https://c8.radioboss.fm/stream/33',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'london-telugu-radio',
        ),
        StreamSubEntity(
          title: 'Melody Radio Telugu',
          url: 'https://a1.asurahosting.com:9580/radio.mp3',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'melody-radio-telugu',
        ),
        StreamSubEntity(
          title: '89.4 Tamil FM',
          url: 'https://centova.aarenworld.com/proxy/894tamilfm/stream',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: '894-tamil-fm',
        ),
        StreamSubEntity(
          title: 'AIR Urdu Live',
          url:
              'https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio006/hlspbaudio00632kbps.m3u8',
          startAt: DateTime(2025, 1, 1),
          isOnline: true,
          uuid: 'air-urdu-live',
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
