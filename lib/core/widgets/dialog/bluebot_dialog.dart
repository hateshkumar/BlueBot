import 'package:bluebot_turing/config/export.dart';

import 'package:markdown/markdown.dart' as md;

enum DialogButtonTypes {
  PRIMARY,
  SECONDARY,
  SECONDARY_FILLED,
  SECONDARY_OUTLINE,
}

/// Priority
/// 1. child
/// 2. label
/// 3 icon
class BlueBotDialogButton<T> {
  final String? label;
  final IconData? icon;
  final BehaviorSubject<bool>? disabledSubject;
  final Function? onPressed;
  final bool dismisses;
  final DialogButtonTypes dialogButtonType;
  final BehaviorSubject<T>? data$;

  final T? value;

  /// Dialog button [dismisses] the dialog by default.
  /// set [dismisses] to false to keep the dialog open.
  const BlueBotDialogButton({
    this.label,
    this.value,
    this.icon,
    this.onPressed,
    this.data$,
    this.dismisses = true,
    this.disabledSubject,
    this.dialogButtonType = DialogButtonTypes.SECONDARY,
  });
}

abstract class BlueBotDialog<T> extends StatelessWidget {
  final String? title;
  final List<BlueBotDialogButton>? actions;
  final EdgeInsets margin;
  const BlueBotDialog({
    this.margin = const EdgeInsets.symmetric(horizontal: 36.0, vertical: 52.0),
    this.title,
    this.actions,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: APPColors.appPrimaryColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      child: Container(
        margin: margin,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(context),
            buildContent(context),
            distanceBetweenContentAndActionButtons,
            ...buildActions(context)
                .map(
                  (BlueBotDialogButton action) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: createActionButton(context, action),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  SizedBox get distanceBetweenContentAndActionButtons =>
      const SizedBox(height: 24.0);

  BlueBotDialogButton dismissButton({String? message}) {
    return BlueBotDialogButton(
      label: message ?? 'GREAT',
      dismisses: true,
    );
  }

  Widget createActionButton(BuildContext context, BlueBotDialogButton action) {
    switch (action.dialogButtonType) {
      case DialogButtonTypes.PRIMARY:
        return BlueBotButton.primaryFilled(
          label: action.label,
          icon: action.icon != null ? Icon(action.icon) : null,
          disabledSubject: action.disabledSubject,
          iconPosition: BlueBotBaseButtonIconPosition.RIGHT,
          onPressed: () {
            if (action.dismisses) Navigator.of(context).pop();
            if (action.onPressed != null) action.onPressed!();
          },
        );

      case DialogButtonTypes.SECONDARY:
        return BlueBotButton.secondaryBorderless(
          label: action.label,
          icon: action.icon != null ? Icon(action.icon) : null,
          disabledSubject: action.disabledSubject,
          onPressed: () {
            if (action.dismisses) Navigator.of(context).pop();
            if (action.onPressed != null) action.onPressed!();
          },
        );
      case DialogButtonTypes.SECONDARY_FILLED:
        return BlueBotButton.secondaryFilled(
          label: action.label,
          disabledSubject: action.disabledSubject,
          onPressed: () {
            if (action.dismisses) Navigator.of(context).pop();
            if (action.onPressed != null) action.onPressed!();
          },
        );
      case DialogButtonTypes.SECONDARY_OUTLINE:
        return BlueBotButton.secondaryOutlined(
          label: action.label,
          disabledSubject: action.disabledSubject,
          onPressed: () {
            if (action.dismisses) Navigator.of(context).pop();
            if (action.onPressed != null) action.onPressed!();
          },
        );
    }
  }

  Widget buildContent(BuildContext context);

  MarkdownStyleSheet getMarkdownStyle(BuildContext context) =>
      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: BlueBotTheme.of(context).textTheme.bodyMedium,
        textAlign: WrapAlignment.center,
        h1: BlueBotTheme.of(context)
            .textTheme
            .bodyMedium
            .copyWith(fontWeight: FontWeight.bold),
        a: BlueBotTheme.of(context)
            .textTheme
            .bodyMedium
            .copyWith(color: BlueBotTheme.of(context).colorTheme.secondary),
      );

  Widget buildMarkdown(
    BuildContext context, {
    required String data,
    MarkdownTapLinkCallback? onTapLink,
  }) =>
      Markdown(
        extensionSet: md.ExtensionSet.gitHubWeb,
        padding: EdgeInsets.zero,
        styleSheet: getMarkdownStyle(context),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        data: data,
        onTapLink: onTapLink,
      );

  Widget buildTitle(BuildContext context) {
    final synergyTheme = BlueBotTheme.of(context);
    return title != null && title != ''
        ? Column(
            children: [
              Text(
                title!,
                style: synergyTheme.textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24.0,
              ),
            ],
          )
        : const Empty();
  }

  List<BlueBotDialogButton> buildActions(BuildContext context) {
    return actions ?? [];
  }

  Future<T?> show({dismissible: true}) {
    return globalBloc.showBlueBotDialog(this, dismissible: dismissible);
  }
}

/// Right now very much the same as BlueBotErrorDialog
class BlueBotInfoDialog<T> extends BlueBotDialog<T> {
  final String? title;
  // Not sure yet if we will ever have non-string contents,
  // so for now I allow either message or content
  final Widget? content;
  final String? subTitle;
  final List<BlueBotDialogButton<T>>? actions;

  const BlueBotInfoDialog({
    this.title,
    this.content,
    this.subTitle,
    this.actions = const [],
  })  : assert((subTitle != null) ^ (content != null),
            "One of them should be non null"),
        super(
          title: title,
          actions: actions,
        );
  const BlueBotInfoDialog.small({
    this.title,
    this.content,
    this.subTitle,
    this.actions = const [],
  })  : assert((subTitle != null) ^ (content != null),
            "One of them should be non null"),
        super(
          title: title,
          actions: actions,
          margin: const EdgeInsets.all(36.0),
        );

  @override
  List<BlueBotDialogButton> buildActions(BuildContext context);

  @override
  Widget buildContent(BuildContext context) {
    final synergyTheme = BlueBotTheme.of(context);
    return content ??
        Text(
          subTitle ?? '',
          style: synergyTheme.secondaryTextTheme.bodyMedium,
          textAlign: TextAlign.center,
        );
  }
}
