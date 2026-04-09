import 'package:test/test.dart';
import 'package:chrono_dart/chrono_dart.dart' show Component, sv;
import './test_util.dart' show testSingleCase, testUnexpectedResult;

void main() {
  group('SV Casual', () {
    test('Test - Single Expression', () {
      testSingleCase(sv.casual, 'idag', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
      });

      testSingleCase(
          sv.casual, 'imorgon', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 11);
      });

      testSingleCase(sv.casual, 'igår', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 9);
      });

      testSingleCase(
          sv.casual, 'förrgår', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 8);
      });
    });

    test('Test - Combined Expression', () {
      testSingleCase(sv.casual, 'idag på morgonen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 6);
      });

      testSingleCase(sv.casual, 'idag på förmiddagen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 9);
      });

      testSingleCase(sv.casual, 'idag på middagen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 12);
      });

      testSingleCase(sv.casual, 'idag på eftermiddagen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 15);
      });

      testSingleCase(sv.casual, 'idag på kvällen', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 20);
      });

      testSingleCase(
          sv.casual, 'idag på natten', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.hour), 2);
      });

      testSingleCase(
          sv.casual, 'idag vid midnatt', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.hour), 0);
      });
    });
  });

  group('SV Little-endian', () {
    test('Test - Single expression', () {
      testSingleCase(
          sv.casual, 'den 15 augusti', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 15);
      });

      testSingleCase(
          sv.casual, '15 augusti 2012', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 15);
      });

      testSingleCase(
          sv.casual, '15 aug 2012', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 15);
      });
    });

    test('Test - Range expression', () {
      testSingleCase(
          sv.casual, '15-16 augusti', DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.day), 15);
        expect(result.end, isNotNull);
        expect(result.end!.get(Component.day), 16);
      });

      testSingleCase(
          sv.casual, '15 till 16 augusti', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.day), 15);
        expect(result.end, isNotNull);
        expect(result.end!.get(Component.day), 16);
      });
    });

    test('Test - Impossible Dates', () {
      testUnexpectedResult(sv.casual, '32 augusti', DateTime(2012, 8, 10));
    });
  });

  group('SV Weekday', () {
    test('Test - Single Expression', () {
      testSingleCase(sv.casual, 'måndag', DateTime(2012, 8, 9), (result, text) {
        expect(result.start.get(Component.weekday), 1);
      });

      testSingleCase(
          sv.casual, 'på måndag', DateTime(2012, 8, 9), (result, text) {
        expect(result.start.get(Component.weekday), 1);
      });
    });

    test('Test - Next/Last Week Expression', () {
      testSingleCase(
          sv.casual, 'nästa måndag', DateTime(2012, 8, 9), (result, text) {
        expect(result.start.get(Component.day), 13);
      });

      testSingleCase(
          sv.casual, 'förra måndag', DateTime(2012, 8, 9), (result, text) {
        expect(result.start.get(Component.day), 6);
      });
    });
  });

  group('SV Casual Relative Time Unit', () {
    test('Test - Positive time units', () {
      testSingleCase(
          sv.casual, 'nästa 2 veckor', DateTime(2016, 10, 1, 12),
          (result, text) {
        expect(result.start.get(Component.year), 2016);
        expect(result.start.get(Component.month), 10);
        expect(result.start.get(Component.day), 15);
      });

      testSingleCase(sv.casual, 'efter en timme', DateTime(2016, 10, 1, 15),
          (result, text) {
        expect(result.start.get(Component.hour), 16);
      });

      testSingleCase(
          sv.casual, '+15 minuter', DateTime(2012, 7, 10, 12, 14),
          (result, text) {
        expect(result.start.get(Component.hour), 12);
        expect(result.start.get(Component.minute), 29);
      });

      testSingleCase(
          sv.casual, '+1 dag 2 timmar', DateTime(2012, 7, 10, 12, 14),
          (result, text) {
        expect(result.start.get(Component.day), 11);
        expect(result.start.get(Component.hour), 14);
        expect(result.start.get(Component.minute), 14);
      });
    });

    test('Test - Negative time units', () {
      testSingleCase(
          sv.casual, 'förra 2 veckor', DateTime(2016, 10, 1, 12),
          (result, text) {
        expect(result.start.get(Component.year), 2016);
        expect(result.start.get(Component.month), 9);
        expect(result.start.get(Component.day), 17);
      });

      testSingleCase(
          sv.casual, '-2tim5min', DateTime(2016, 10, 1, 12), (result, text) {
        expect(result.start.get(Component.hour), 9);
        expect(result.start.get(Component.minute), 55);
      });
    });
  });
}

