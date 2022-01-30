import 'package:flutter_test/flutter_test.dart';
import 'package:reador/provider/theme_provider.dart';

void main() {
  /// [sut] stands for System Under Test
  /// In this case, it is [ThemeProvider].
  late ThemeProvider sut;

  setUp(() {
    sut = ThemeProvider();
  });

  group(
    'Testing Theme Provider Class',
    () {
      test(
        "Initial value of isDarkTheme is false",
        () async {
          expect(sut.isDarkTheme, false);
        },
      );

      test(
        "isDarkTheme changes its value when toggleTheme is called",
        () async {
          bool initialValue = sut.isDarkTheme;
          sut.toggleTheme(!initialValue);
          bool finalValue = sut.isDarkTheme;

          expect(initialValue, !finalValue);
        },
      );
    },
  );
}
