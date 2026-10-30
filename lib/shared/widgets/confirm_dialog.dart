import 'package:material_ui/material_ui.dart';
import 'package:sound_center/generated/l10n.dart';
import 'package:sound_center/shared/widgets/glass.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Glass(
        borderRadius: 20,
        elevation: 8,
        useBorder: true,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                Text(S.of(context).areYouSureAboutThat),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(S.of(context).no),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(S.of(context).yes),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
