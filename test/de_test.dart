import 'package:test/test.dart';
import 'package:chrono_dart/chrono_dart.dart' show Component, de;
import './test_util.dart' show testSingleCase, testUnexpectedResult, toBeDate;

void main() {
  group('DE Casual', () {
    test('Test - Single Expression', () {
      testSingleCase(de.casual, 'Die Deadline ist jetzt',
          DateTime(2012, 8, 10, 8, 9, 10, 11), (result, text) {
        expect(result.index, 17);
        expect(result.text, 'jetzt');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start.get(Component.hour), 8);
        expect(result.start.get(Component.minute), 9);
        expect(result.start.get(Component.second), 10);
        expect(result.start.get(Component.millisecond), 11);
      });

      testSingleCase(
          de.casual, 'Die Deadline ist heute', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.text, 'heute');
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12)));
      });

      testSingleCase(
          de.casual, 'Die Deadline ist morgen', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.text, 'morgen');
        expect(result.start.get(Component.day), 11);
        expect(result.start, toBeDate(DateTime(2012, 8, 11, 12)));
      });

      testSingleCase(
          de.casual, 'Die Deadline war gestern', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.text, 'gestern');
        expect(result.start.get(Component.day), 9);
        expect(result.start, toBeDate(DateTime(2012, 8, 9, 12)));
      });

      testSingleCase(
          de.casual, 'Die Deadline war vorgestern', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.text, 'vorgestern');
        expect(result.start.get(Component.day), 8);
      });
    });

    test('Test - Casual Time Keywords', () {
      testSingleCase(de.casual, 'heute nachmittag', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.text, 'heute nachmittag');
        expect(result.start.get(Component.hour), 15);
      });

      testSingleCase(de.casual, 'mitternacht', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.start.get(Component.hour), 0);
      });
    });
  });

  group('DE Little-endian', () {
    test('Test - Single expression', () {
      testSingleCase(de.casual, '15. August 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 15);
      });

      testSingleCase(de.casual, 'am 8. Februar', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2013);
        expect(result.start.get(Component.month), 2);
        expect(result.start.get(Component.day), 8);
      });
    });

    test('Test - Range expression', () {
      testSingleCase(de.casual, '15. bis 16. August', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.day), 15);
        expect(result.end, isNotNull);
        expect(result.end!.get(Component.day), 16);
      });
    });
  });

  group('DE Weekday', () {
    test('Test - Weekday modifiers', () {
      testSingleCase(de.casual, 'nächsten Montag', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.weekday), DateTime.monday);
      });

      testSingleCase(de.casual, 'letzten Freitag', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.weekday), DateTime.friday);
      });
    });
  });

  group('DE Time Expression', () {
    test('Test - Specific time expression', () {
      testSingleCase(de.casual, 'um 17:30', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 17);
        expect(result.start.get(Component.minute), 30);
      });

      testSingleCase(de.casual, '8 Uhr abends', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 20);
      });
    });
  });

  group('DE Relative Expressions', () {
    test('Test - Relative duration', () {
      testSingleCase(de.casual, 'in 5 Tagen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start, toBeDate(DateTime(2012, 8, 15)));
      });

      testSingleCase(de.casual, 'letzte Woche', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start, toBeDate(DateTime(2012, 8, 3)));
      });
    });

    test('Test - Impossible dates', () {
      testUnexpectedResult(de.casual, '32. August', DateTime(2012, 8, 10));
    });
  });
}
