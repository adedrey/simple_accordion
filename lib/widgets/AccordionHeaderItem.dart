import 'package:flutter/material.dart';
import 'package:simple_accordion/model/SimpleAccordionState.dart';
import 'package:simple_accordion/widgets/AccordionItem.dart';

class AccordionHeaderItem extends StatefulWidget {
  AccordionHeaderItem(
      {this.isOpen,
      Key? key,
      this.title,
      required this.children,
      this.child,
      this.headerColor,
      this.index = 0,
      this.headerTextStyle,
      this.itemTextStyle,
      this.iconSize,
      this.iconColor,
      this.showBorder = true,
      this.borderColor,
      this.itemColor})
      : assert(title != null || child != null),
        super(key: key);

  /// set default state of header (open/close)
  final bool? isOpen;
  final String? title;
  final Widget? child;
  final List<AccordionItem> children;
  final double? iconSize;
  final Color? iconColor;
  final bool showBorder;
  final Color? borderColor;

  /// set the color of header
  Color? headerColor;

  /// set the color of current header items
  Color? itemColor;

  /// don't use this property, it'll use to another feature
  int index;

  /// if you're using title instead of child in AccordionHeaderItem
  TextStyle? headerTextStyle;

  /// if you're using title instead of child in AccordionItem
  TextStyle? itemTextStyle;

  @override
  State<StatefulWidget> createState() => _AccordionHeaderItem();
}

class _AccordionHeaderItem extends State<AccordionHeaderItem> {
  late bool isOpen;

  @override
  void initState() {
    isOpen = widget.isOpen ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = SimpleAccordionState.of(context);
    final header = InkWell(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: widget.showBorder
                ? Border(
                    bottom: BorderSide(
                        width: 1,
                        color: widget.borderColor ?? const Color(0xffe6e6e6)),
                  )
                : null,
            color: widget.headerColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.child ??
                Text(
                  widget.title!,
                  style: widget.headerTextStyle,
                ),
            Icon(
              isOpen
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
              size: widget.iconSize,
              color: widget.iconColor ?? const Color(0xffd4d4d4),
            )
          ],
        ),
      ),
    );
    return AnimatedCrossFade(
      crossFadeState:
          isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
      firstChild: header,
      secondChild: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          Container(
            color: widget.itemColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children
                  .map((e) => e
                    ..indexGroup = widget.index
                    ..checked = e.checked ??
                        (state?.selectedItems ?? [])
                            .any((w) => w.title == e.title)
                    ..itemTextStyle = e.itemTextStyle ?? widget.itemTextStyle)
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
