import 'package:material_ui/material_ui.dart';
import 'package:sound_center/generated/l10n.dart';
import 'package:sound_center/shared/widgets/glass.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key, required this.filter});

  final SearchFilter filter;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late SearchFilter filter;

  @override
  void initState() {
    filter = widget.filter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Glass(
          borderRadius: 20,
          elevation: 8,
          useBorder: true,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: RadioGroup<SearchFilter>(
              onChanged: (v) {
                setState(() => filter = v!);
              },
              groupValue: filter,
              child: Column(
                mainAxisSize: .min,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5,
                    children: [
                      radioItem(SearchFilter.none, "None"),
                      radioItem(SearchFilter.tracks, "Tracks"),
                      radioItem(SearchFilter.albums, "Albums"),
                      radioItem(SearchFilter.playlists, "Playlists"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context, filter),
                    child: Text(S.of(context).ok),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget radioItem(SearchFilter filter, String languageName) {
    return GestureDetector(
      onTap: () {
        setState(() => this.filter = filter);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<SearchFilter>(value: filter),
            Expanded(child: Text(languageName)),
          ],
        ),
      ),
    );
  }
}
