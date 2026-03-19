import 'package:flutter/cupertino.dart';

Future<bool> showCancelLearnedDialog(
    BuildContext context, String taskTitle) async {
  final result = await showCupertinoDialog<bool>(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: const Text('Cancel learned?'),
      content: Text(
        'The review schedule for "$taskTitle" will be deleted.\nAre you sure you want to cancel?',
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('No'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Confirm cancel'),
        ),
      ],
    ),
  );
  return result ?? false;
}
