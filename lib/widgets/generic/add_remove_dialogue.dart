import 'package:flutter/material.dart';
import 'package:nomad/constants.dart';

enum ConfirmationAction { add, remove }

Future<bool?> showAddRemoveDialogue({
  required BuildContext context,
  required String contextName,
  required ConfirmationAction action,
  required VoidCallback onConfirm,
  String? title,
  String? contentPrefix,
  String? confirmButtonText,
  String? cancelButtonText,
}) {
  final bool isRemoving = action == ConfirmationAction.remove;
  final String defaultTitle = title ?? "Confirm Action";
  final String actionText = isRemoving ? "remove" : "add";
  final String effectiveConfirmText =
      confirmButtonText ?? (isRemoving ? "Remove" : "Add");
  final Color confirmColor = isRemoving
      ? Theme.of(context).colorScheme.error
      : Theme.of(context).colorScheme.primary;
  final IconData dialogIcon = isRemoving
      ? Icons.warning_amber_rounded
      : Icons.help_outline_rounded;

  return showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      final theme = Theme.of(dialogContext);

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: kCardBorderRadius,
        ),
        elevation: kCardElevation,
        backgroundColor: theme.dialogBackgroundColor,

        titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
        title: Row(
          children: [
            Icon(
              dialogIcon,
              color: isRemoving ? confirmColor : theme.colorScheme.primary,
              size: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                defaultTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),

        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (contentPrefix != null) ...[
                Text(contentPrefix, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
              ],
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Are you sure you want to $actionText '),
                    TextSpan(
                      text: contextName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: isRemoving ? ' from your itinerary?' : ' to your itinerary?'),
                  ],
                ),
              ),
            ],
          ),
        ),

        actionsPadding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 16.0),
        actionsAlignment: MainAxisAlignment.end,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              foregroundColor: theme.colorScheme.onSurfaceVariant,
            ),
            child: Text(cancelButtonText ?? 'Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
          ),
          const SizedBox(width: 8),

          ElevatedButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: kButtonShape,
            ),
            label: Text(effectiveConfirmText),
            onPressed: () {
              onConfirm();
              Navigator.of(dialogContext).pop(true);
            },
          ),
        ],
      );
    },
  );
}