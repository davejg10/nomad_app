import 'package:logger/logger.dart';

class CustomLogPrinter extends PrettyPrinter {
  final String className;

  CustomLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.defaultLevelColors[event.level];
    var emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    return [color!('${DateTime.now()}: $emoji $className - ${event.message}')];
  }
}
