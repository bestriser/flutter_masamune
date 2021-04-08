part of masamune;

extension TextEditingControllerExtensions on TextEditingController? {
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.text.isEmpty;
  }

  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.text.isNotEmpty;
  }
}

extension ButtonStyleExtension on ButtonStyle {
  ButtonStyle addState({
    Color? backgroundColor,
    Color? foregroundColor,
    Set<MaterialState> state = const {
      MaterialState.focused,
      MaterialState.hovered,
      MaterialState.pressed,
      MaterialState.selected,
    },
  }) {
    return copyWith(
      backgroundColor: MaterialStateProperty.resolveWith((st) {
        if (st.containsAny(state)) {
          return backgroundColor ?? this.backgroundColor?.resolve(st);
        }
        return this.backgroundColor?.resolve(st);
      }),
      foregroundColor: MaterialStateProperty.resolveWith((st) {
        if (st.containsAny(state)) {
          return foregroundColor ?? this.foregroundColor?.resolve(st);
        }
        return this.foregroundColor?.resolve(st);
      }),
    );
  }
}
