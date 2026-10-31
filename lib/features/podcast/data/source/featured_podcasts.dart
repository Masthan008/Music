import 'package:sound_center/features/podcast/domain/entity/subscription_entity.dart';

class FeaturedPodcasts {
  static List<SubscriptionEntity> get popularPodcasts => [
        SubscriptionEntity(
          title: 'The Ranveer Show (TRS)',
          feedUrl: 'https://anchor.fm/s/2eb03960/podcast/rss',
          subscribedAt: DateTime(2025, 1, 1),
          lastListenAt: DateTime(2025, 1, 1),
          updateTime: DateTime(2025, 1, 1),
          totalEpisodes: 500,
          haveNewEpisode: false,
          author: 'BeerBiceps',
          artworkUrl:
              'https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/6121408/6121408-1605705350993-9426f4f21db59.jpg',
        ),
        SubscriptionEntity(
          title: 'Finshots Daily',
          feedUrl: 'https://anchor.fm/s/1155986c/podcast/rss',
          subscribedAt: DateTime(2025, 1, 1),
          lastListenAt: DateTime(2025, 1, 1),
          updateTime: DateTime(2025, 1, 1),
          totalEpisodes: 300,
          haveNewEpisode: false,
          author: 'Finshots',
          artworkUrl:
              'https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/2290460/2290460-1577786435649-4aa2ea12e3e5c.jpg',
        ),
        SubscriptionEntity(
          title: 'The Daily',
          feedUrl: 'https://feeds.simplecast.com/54nAGcIl',
          subscribedAt: DateTime(2025, 1, 1),
          lastListenAt: DateTime(2025, 1, 1),
          updateTime: DateTime(2025, 1, 1),
          totalEpisodes: 1000,
          haveNewEpisode: false,
          author: 'The New York Times',
          artworkUrl:
              'https://image.simplecastcdn.com/images/037320b9-3738-40a2-aa02-e2b2ab6222b2/eb1e4334-039c-48d0-ad17-640a3118cf67/image.jpg',
        ),
        SubscriptionEntity(
          title: 'TED Talks Daily',
          feedUrl: 'https://feeds.feedburner.com/TEDTalks_audio',
          subscribedAt: DateTime(2025, 1, 1),
          lastListenAt: DateTime(2025, 1, 1),
          updateTime: DateTime(2025, 1, 1),
          totalEpisodes: 800,
          haveNewEpisode: false,
          author: 'TED',
          artworkUrl:
              'https://pi.tedcdn.com/r/pb-assets.tedcdn.com/system/ba/assets/1075/TEDTalks_Audio_1400x1400_300dpi.png',
        ),
        SubscriptionEntity(
          title: 'BBC Global News Podcast',
          feedUrl: 'https://podcasts.files.bbci.co.uk/p02nq0gn.rss',
          subscribedAt: DateTime(2025, 1, 1),
          lastListenAt: DateTime(2025, 1, 1),
          updateTime: DateTime(2025, 1, 1),
          totalEpisodes: 1200,
          haveNewEpisode: false,
          author: 'BBC World Service',
          artworkUrl:
              'https://ichef.bbci.co.uk/images/ic/1024x1024/p02nq0gn.jpg',
        ),
        SubscriptionEntity(
          title: 'Maha Bharat with Dhruv Rathee',
          feedUrl: 'https://feeds.megaphone.fm/GLT6442687105',
          subscribedAt: DateTime(2025, 1, 1),
          lastListenAt: DateTime(2025, 1, 1),
          updateTime: DateTime(2025, 1, 1),
          totalEpisodes: 50,
          haveNewEpisode: false,
          author: 'Spotify Studios',
          artworkUrl:
              'https://cms.megaphone.fm/channel_images/63519c22-901c-11eb-a0aa-d790d96ae234/1400.jpg',
        ),
      ];
}
