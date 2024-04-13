import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ParkioSlidable extends StatefulWidget {
  final Widget child;
  final Function()? onRemove;

  const ParkioSlidable({
    super.key,
    required this.child,
    this.onRemove,
  });

  @override
  State<ParkioSlidable> createState() => _ParkioSlidableState();
}

class _ParkioSlidableState extends State<ParkioSlidable> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: widget.onRemove == null
                ? null
                : (context) {
                    widget.onRemove!();
                  },
            backgroundColor: const Color(0xFFFB9EA0),
            foregroundColor: Colors.white,
            label: AppLocalizations.of(context)!.delete,
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: widget.child,
    );
  }
}
