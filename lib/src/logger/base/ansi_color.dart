/// Creates Ansi color escape codes to use in a terminal.
/// Based on this: https://github.com/leisim/logger/blob/master/lib/src/ansi_color.dart
class AnsiColor {
  static const _ansiEsc = '\x1B[';
  static const _ansiDefault = '${_ansiEsc}0m';

  final int fg;

  AnsiColor.none() : fg = null;
  AnsiColor(this.fg);

  @override
  String toString() {
    if (fg != null) {
      return '${_ansiEsc}38;5;${fg}m';
    } else {
      return '';
    }
  }

  String call(String msg) {
    return '${this}$msg$_ansiDefault';
  }
  
  static AnsiColor grey() => AnsiColor(232 + (0.5.clamp(0.0, 1.0) * 23).round());
}