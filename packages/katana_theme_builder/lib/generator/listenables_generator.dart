part of katana_theme_builder;

/// Generator to automatically create Listenable groups.
///
/// Listenableのグループを自動作成するジェネレーター。
class ThemeGenerator extends GeneratorForAnnotation<AppTheme> {
  /// Generator to automatically create Listenable groups.
  ///
  /// Listenableのグループを自動作成するジェネレーター。
  ThemeGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (!element.library!.isNonNullableByDefault) {
      throw InvalidGenerationSourceError(
        "Generator cannot target libraries that have not been migrated to "
        "null-safety.",
        element: element,
      );
    }

    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        "`@AppTheme()` can only be used on classes.",
        element: element,
      );
    }

    final _class = ClassValue(element);

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...baseClass(_class),
          ],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format(
      "${generated.accept(emitter)}",
    );
  }
}
