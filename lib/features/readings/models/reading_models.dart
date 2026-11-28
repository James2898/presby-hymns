import 'package:presby_hymns/data/database/app_database.dart';

class ResponsiveReadingDetail {
  final ResponsiveReading reading;
  final List<ResponsiveReadingLine> lines;

  const ResponsiveReadingDetail({required this.reading, required this.lines});
}

typedef AdjacentReadings = ({
  ResponsiveReading? previous,
  ResponsiveReading? next,
});
