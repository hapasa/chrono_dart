import 'package:test/test.dart';
import 'package:chrono_dart/chrono_dart.dart' show Component;
import 'package:chrono_dart/src/locales/da/da.dart' as da;
import './test_util.dart' show testSingleCase, testUnexpectedResult;

void main() {
  group('DA Casual', () {
    test('Test - Single Expression', () {
      testSingleCase(da.casual, 'idag', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
      });

      testSingleCase(
          da.casual, 'i morgen', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 11);
      });

      testSingleCase(
          da.casual, 'imorgen', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 11);
      });

      testSingleCase(
          da.casual, 'overmorgen', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 12);
      });

      testSingleCase(da.casual, 'igår', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 9);
      });

      testSingleCase(
          da.casual, 'forgårs', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 8);
      });
    });

    test('Test - Combined Expression', () {
      testSingleCase(da.casual, 'idag om morgenen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start.get(Component.hour), 6);
      });

      testSingleCase(da.casual, 'idag om formiddagen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 9);
      });

      testSingleCase(da.casual, 'idag om middagen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 12);
      });

      testSingleCase(da.casual, 'idag om eftermiddagen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 15);
      });

      testSingleCase(da.casual, 'idag om aftenen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 20);
      });

      testSingleCase(
          da.casual, 'idag om natten', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.hour), 2);
      });

      testSingleCase(
          da.casual, 'idag midnat', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.hour), 0);
      });
    });
  });

  group('DA Little-endian', () {
    test('Test - Single expression', () {
      testSingleCase(
          da.casual, 'den 15 august', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 15);
      });

      testSingleCase(
          da.casual, '15 august 2012', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 15);
      });

      testSingleCase(
          da.casual, '15 aug 2012', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 15);
      });
    });

    test('Test - Range expression', () {
      testSingleCase(
          da.casual, '15-16 august', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.day), 15);
        expect(result.end, isNotNull);
        expect(result.end!.get(Component.day), 16);
      });

      testSingleCase(
          da.casual, '15 til 16 august', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.day), 15);
        expect(result.end, isNotNull);
        expect(result.end!.get(Component.day), 16);
      });
    });

    test('Test - Impossible Dates', () {
      testUnexpectedResult(da.casual, '32 august', DateTime(2012, 8, 10));
    });
  });

  group('DA Weekday', () {
    test('Test - Single Expression', () {
      testSingleCase(da.casual, 'mandag', DateTime(2012, 8, 9), (result, text) {
        expect(result.start.get(Component.weekday), 1);
      });

      testSingleCase(
          da.casual, 'på mandag', DateTime(2012, 8, 9), (result, text) {
        expect(result.start.get(Component.weekday), 1);
      });
    });

    test('Test - Next/Last Week Expression', () {
      testSingleCase(
          da.casual, 'næste mandag', DateTime(2012, 8, 9), (result, text) {
        expect(result.start.get(Component.day), 13);
      });

      testSingleCase(
          da.casual, 'forrige mandag', DateTime(2012, 8, 9), (result, text) {
        expect(result.start.get(Component.day), 6);
      });
    });
  });

  group('DA Casual Relative Time Unit', () {
    test('Test - Positive time units', () {
      testSingleCase(
          da.casual, 'næste 2 uger', DateTime(2016, 10, 1, 12),
          (result, text) {
        expect(result.start.get(Component.year), 2016);
        expect(result.start.get(Component.month), 10);
        expect(result.start.get(Component.day), 15);
      });

      testSingleCase(da.casual, 'efter en time', DateTime(2016, 10, 1, 15),
          (result, text) {
        expect(result.start.get(Component.hour), 16);
      });

      testSingleCase(
          da.casual, '+15 minutter', DateTime(2012, 7, 10, 12, 14),
          (result, text) {
        expect(result.start.get(Component.hour), 12);
        expect(result.start.get(Component.minute), 29);
      });
    });

    test('Test - Negative time units', () {
      testSingleCase(
          da.casual, 'forrige 2 uger', DateTime(2016, 10, 1, 12),
          (result, text) {
        expect(result.start.get(Component.year), 2016);
        expect(result.start.get(Component.month), 9);
        expect(result.start.get(Component.day), 17);
      });

      testSingleCase(da.casual, '-2 timer 5 min', DateTime(2016, 10, 1, 12),
          (result, text) {
        expect(result.start.get(Component.hour), 9);
        expect(result.start.get(Component.minute), 55);
      });
    });
  });
}
