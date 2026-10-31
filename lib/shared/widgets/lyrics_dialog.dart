import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:sound_center/core/services/lyrics_service.dart';
import 'package:sound_center/main.dart';
import 'package:sound_center/shared/widgets/glass.dart';
import 'package:sound_center/shared/widgets/loading.dart';

class LyricsDialog extends StatefulWidget {
  const LyricsDialog({
    super.key,
    required this.trackName,
    required this.artistName,
    this.durationInSeconds,
  });

  final String trackName;
  final String artistName;
  final int? durationInSeconds;

  @override
  State<LyricsDialog> createState() => _LyricsDialogState();
}

class _LyricsDialogState extends State<LyricsDialog> {
  late Future<LyricsData> _lyricsFuture;
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _posSub;
  Duration _currentPos = Duration.zero;

  @override
  void initState() {
    super.initState();
    _lyricsFuture = LyricsService.fetchLyrics(
      trackName: widget.trackName,
      artistName: widget.artistName,
      durationInSeconds: widget.durationInSeconds,
    );

    _posSub = Stream.periodic(const Duration(milliseconds: 400)).listen((_) {
      final pos = audioHandler.playbackState.value.position;
      if (mounted && pos != _currentPos) {
        setState(() {
          _currentPos = pos;
        });
      }
    });
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  int _findActiveIndex(List<LyricLine> lines, Duration pos) {
    if (lines.isEmpty) return -1;
    for (int i = lines.length - 1; i >= 0; i--) {
      if (pos >= lines[i].timestamp) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Glass(
        borderRadius: 24,
        elevation: 8,
        useBorder: true,
        child: Container(
          width: double.infinity,
          height: MediaQuery.heightOf(context) * 0.65,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lyrics_rounded, color: cs.primary, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Lyrics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.trackName} • ${widget.artistName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const Divider(height: 24),
              Expanded(
                child: FutureBuilder<LyricsData>(
                  future: _lyricsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Loading());
                    }

                    final data = snapshot.data;
                    if (data == null ||
                        (data.lines.isEmpty && data.plainText.isEmpty)) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.music_off_rounded, size: 48, color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
                            const SizedBox(height: 12),
                            Text(
                              'No lyrics found for this song',
                              style: TextStyle(
                                fontSize: 14,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!data.isSynced) {
                      return SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            data.plainText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                      );
                    }

                    final activeIndex = _findActiveIndex(data.lines, _currentPos);

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: data.lines.length,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        final line = data.lines[index];
                        final isActive = index == activeIndex;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            line.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isActive ? 18 : 15,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive
                                  ? cs.primary
                                  : cs.onSurface.withValues(alpha: 0.5),
                              height: 1.4,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
