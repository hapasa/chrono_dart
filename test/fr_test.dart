import 'package:test/test.dart';
import 'package:chrono_dart/chrono_dart.dart';
import 'package:chrono_dart/src/locales/fr/fr.dart' as fr;
import './test_util.dart' show testSingleCase, testUnexpectedResult, toBeDate;

void main() {
  // =========================================================================
  // Casual date/time tests
  // =========================================================================

  group('FR Casual', () {
    test('Test - Single Expression', () {
      testSingleCase(fr.casual, 'La deadline est maintenant',
          DateTime(2012, 8, 10, 8, 9, 10, 11), (result, text) {
        expect(result.index, 16);
        expect(result.text, 'maintenant');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start.get(Component.hour), 8);
        expect(result.start.get(Component.minute), 9);
        expect(result.start.get(Component.second), 10);
        expect(result.start.get(Component.millisecond), 11);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 8, 9, 10, 11)));
      });

      testSingleCase(
          fr.casual, "La deadline est aujourd'hui", DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.index, 16);
        expect(result.text, "aujourd'hui");
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12)));
      });

      testSingleCase(
          fr.casual, 'La deadline est demain', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.index, 16);
        expect(result.text, 'demain');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 11);
        expect(result.start, toBeDate(DateTime(2012, 8, 11, 12)));
      });

      testSingleCase(
          fr.casual, 'La deadline est demain', DateTime(2012, 8, 10, 1),
          (result, text) {
        expect(result.start, toBeDate(DateTime(2012, 8, 11, 1)));
      });

      testSingleCase(
          fr.casual, "La deadline était hier", DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.text, 'hier');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 9);
        expect(result.start, toBeDate(DateTime(2012, 8, 9, 12)));
      });

      testSingleCase(
          fr.casual, "La deadline était la veille", DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.text, 'la veille');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 9);
        expect(result.start.get(Component.hour), 0);
        expect(result.start, toBeDate(DateTime(2012, 8, 9, 0)));
      });

      testSingleCase(
          fr.casual, 'La deadline est ce matin', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.index, 16);
        expect(result.text, 'ce matin');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start.get(Component.hour), 8);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 8)));
      });

      testSingleCase(fr.casual, 'La deadline est cet après-midi',
          DateTime(2012, 8, 10, 12), (result, text) {
        expect(result.index, 16);
        expect(result.text, 'cet après-midi');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start.get(Component.hour), 14);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 14)));
      });

      testSingleCase(
          fr.casual, 'La deadline est cet aprem', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.index, 16);
        expect(result.text, 'cet aprem');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start.get(Component.hour), 14);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 14)));
      });

      testSingleCase(
          fr.casual, 'La deadline est ce soir', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.index, 16);
        expect(result.text, 'ce soir');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start.get(Component.hour), 18);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 18)));
      });

      testSingleCase(fr.casual, 'a midi', (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.hour), 12);
      });

      testSingleCase(fr.casual, 'à minuit', (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.hour), 0);
      });
    });

    test('Test - Combined Expression', () {
      testSingleCase(fr.casual, "La deadline est aujourd'hui 17:00",
          DateTime(2012, 8, 10, 12), (result, text) {
        expect(result.index, 16);
        expect(result.text, "aujourd'hui 17:00");
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start.get(Component.hour), 17);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 17)));
      });

      testSingleCase(
          fr.casual, 'La deadline est demain 17:00', DateTime(2012, 8, 10, 12),
          (result, text) {
        expect(result.index, 16);
        expect(result.text, 'demain 17:00');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 11);
        expect(result.start.get(Component.hour), 17);
        expect(result.start, toBeDate(DateTime(2012, 8, 11, 17)));
      });
    });
  });

  // =========================================================================
  // Little-endian date tests
  // =========================================================================

  group('FR Little-endian', () {
    test('Test - Single expression', () {
      testSingleCase(fr.casual, '10 Août 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.index, 0);
        expect(result.text, '10 Août 2012');
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12)));
      });

      testSingleCase(fr.casual, '8 Février', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2013);
        expect(result.start.get(Component.month), 2);
        expect(result.start.get(Component.day), 8);
        expect(result.index, 0);
        expect(result.text, '8 Février');
        expect(result.start, toBeDate(DateTime(2013, 2, 8, 12)));
      });

      testSingleCase(fr.casual, '1er Août 2012', DateTime(2012, 8, 1),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 1);
        expect(result.index, 0);
        expect(result.text, '1er Août 2012');
        expect(result.start, toBeDate(DateTime(2012, 8, 1, 12)));
      });

      testSingleCase(fr.casual, 'Dim 15 Sept', DateTime(2013, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'Dim 15 Sept');
        expect(result.start.get(Component.year), 2013);
        expect(result.start.get(Component.month), 9);
        expect(result.start.get(Component.day), 15);
        expect(result.start, toBeDate(DateTime(2013, 9, 15, 12)));
      });

      testSingleCase(
          fr.casual, 'La date limite est le 10 Août', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 22);
        expect(result.text, '10 Août');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12)));
      });

      testSingleCase(fr.casual, '31 mars 2016', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '31 mars 2016');
        expect(result.start.get(Component.year), 2016);
        expect(result.start.get(Component.month), 3);
        expect(result.start.get(Component.day), 31);
        expect(result.start, toBeDate(DateTime(2016, 3, 31, 12)));
      });
    });

    test('Test - Range expression', () {
      testSingleCase(fr.casual, '10 - 22 août 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '10 - 22 août 2012');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12)));
        expect(result.end, isNotNull);
        expect(result.end!.get(Component.year), 2012);
        expect(result.end!.get(Component.month), 8);
        expect(result.end!.get(Component.day), 22);
        expect(result.end, toBeDate(DateTime(2012, 8, 22, 12)));
      });

      testSingleCase(fr.casual, '10 au 22 août 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '10 au 22 août 2012');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.end, isNotNull);
        expect(result.end!.get(Component.year), 2012);
        expect(result.end!.get(Component.month), 8);
        expect(result.end!.get(Component.day), 22);
      });
    });

    test('Test - Date/Time combined expression', () {
      testSingleCase(fr.casual, '12 juillet à 19:00', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '12 juillet à 19:00');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 7);
        expect(result.start.get(Component.day), 12);
        expect(result.start, toBeDate(DateTime(2012, 7, 12, 19, 0)));
      });

      testSingleCase(fr.casual, '5 mai 12:00', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '5 mai 12:00');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 5);
        expect(result.start.get(Component.day), 5);
        expect(result.start, toBeDate(DateTime(2012, 5, 5, 12, 0)));
      });

      testSingleCase(fr.casual, '7 Mai 11:00', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '7 Mai 11:00');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 5);
        expect(result.start.get(Component.day), 7);
        expect(result.start.get(Component.hour), 11);
        expect(result.start, toBeDate(DateTime(2012, 5, 7, 11, 0)));
      });
    });

    test('Test - Accentuated text parsing', () {
      testSingleCase(fr.casual, '10 Août 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12)));
      });

      testSingleCase(fr.casual, '10 Février 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 2);
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 2, 10, 12)));
      });

      testSingleCase(fr.casual, '10 Décembre 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 12);
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 12, 10, 12)));
      });
    });

    test('Test - Unaccentuated text parsing', () {
      testSingleCase(fr.casual, '10 Aout 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12)));
      });

      testSingleCase(fr.casual, '10 Fevrier 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 2);
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 2, 10, 12)));
      });

      testSingleCase(fr.casual, '10 Decembre 2012', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 12);
        expect(result.start.get(Component.day), 10);
        expect(result.start, toBeDate(DateTime(2012, 12, 10, 12)));
      });
    });

    test('Test - Impossible Dates', () {
      testUnexpectedResult(fr.casual, '32 Août 2014', DateTime(2012, 8, 10));
      testUnexpectedResult(fr.casual, '29 Février 2014', DateTime(2012, 8, 10));
      testUnexpectedResult(fr.casual, '32 Aout', DateTime(2012, 8, 10));
      testUnexpectedResult(fr.casual, '29 Fevrier', DateTime(2013, 8, 10));
    });
  });

  // =========================================================================
  // Weekday tests
  // =========================================================================

  group('FR Weekday', () {
    test('Test - Single Expression', () {
      testSingleCase(fr.casual, 'Lundi', DateTime(2012, 8, 9), (result, text) {
        expect(result.index, 0);
        expect(result.text, 'Lundi');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 6);
        expect(result.start.get(Component.weekday), 1);
        expect(result.start.isCertain(Component.day), false);
        expect(result.start.isCertain(Component.month), false);
        expect(result.start.isCertain(Component.year), false);
        expect(result.start.isCertain(Component.weekday), true);
        expect(result.start, toBeDate(DateTime(2012, 8, 6, 12)));
      });

      testSingleCase(fr.casual, 'Lundi', DateTime(2012, 8, 9),
          ParsingOption(forwardDate: true), (result, text) {
        expect(result.index, 0);
        expect(result.text, 'Lundi');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 13);
        expect(result.start.get(Component.weekday), 1);
        expect(result.start, toBeDate(DateTime(2012, 8, 13, 12)));
      });

      testSingleCase(fr.casual, 'Jeudi', DateTime(2012, 8, 9), (result, text) {
        expect(result.index, 0);
        expect(result.text, 'Jeudi');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 9);
        expect(result.start.get(Component.weekday), 4);
        expect(result.start, toBeDate(DateTime(2012, 8, 9, 12)));
      });

      testSingleCase(fr.casual, 'Dimanche', DateTime(2012, 8, 9),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'Dimanche');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 12);
        expect(result.start.get(Component.weekday), 0);
        expect(result.start, toBeDate(DateTime(2012, 8, 12, 12)));
      });

      testSingleCase(fr.casual, 'la deadline était vendredi dernier...',
          DateTime(2012, 8, 9), (result, text) {
        expect(result.text, 'vendredi dernier');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 3);
        expect(result.start.get(Component.weekday), 5);
        expect(result.start, toBeDate(DateTime(2012, 8, 3, 12)));
      });

      testSingleCase(fr.casual, 'Planifions une réuinion vendredi prochain',
          DateTime(2015, 4, 18), (result, text) {
        expect(result.text, 'vendredi prochain');
        expect(result.start.get(Component.year), 2015);
        expect(result.start.get(Component.month), 4);
        expect(result.start.get(Component.day), 24);
        expect(result.start.get(Component.weekday), 5);
        expect(result.start, toBeDate(DateTime(2015, 4, 24, 12)));
      });
    });

    test('Test - Weekday Overlap', () {
      testSingleCase(
          fr.casual, 'Dimanche 7 décembre 2014', DateTime(2012, 8, 9),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'Dimanche 7 décembre 2014');
        expect(result.start.get(Component.year), 2014);
        expect(result.start.get(Component.month), 12);
        expect(result.start.get(Component.day), 7);
        expect(result.start.get(Component.weekday), 0);
        expect(result.start.isCertain(Component.day), true);
        expect(result.start.isCertain(Component.month), true);
        expect(result.start.isCertain(Component.year), true);
        expect(result.start.isCertain(Component.weekday), true);
        expect(result.start, toBeDate(DateTime(2014, 12, 7, 12)));
      });

      testSingleCase(fr.casual, 'Dimanche 7/12/2014', DateTime(2012, 8, 9),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'Dimanche 7/12/2014');
        expect(result.start.get(Component.year), 2014);
        expect(result.start.get(Component.month), 12);
        expect(result.start.get(Component.day), 7);
        expect(result.start.get(Component.weekday), 0);
        expect(result.start, toBeDate(DateTime(2014, 12, 7, 12)));
      });
    });
  });

  // =========================================================================
  // Slash date tests
  // =========================================================================

  group('FR Slash', () {
    test('Test - Single Expression', () {
      testSingleCase(fr.casual, '8/2/2016', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '8/2/2016');
        expect(result.start.get(Component.year), 2016);
        expect(result.start.get(Component.month), 2);
        expect(result.start.get(Component.day), 8);
        expect(result.start, toBeDate(DateTime(2016, 2, 8, 12)));
      });

      testSingleCase(fr.casual, 'le 8/2/2016', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2016);
        expect(result.start.get(Component.month), 2);
        expect(result.start.get(Component.day), 8);
        expect(result.start, toBeDate(DateTime(2016, 2, 8, 12)));
      });

      testSingleCase(fr.casual, 'le 8/2', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.year), 2013);
        expect(result.start.get(Component.month), 2);
        expect(result.start.get(Component.day), 8);
        expect(result.start, toBeDate(DateTime(2013, 2, 8, 12)));
      });
    });

    test('Test - Single Expression with weekday', () {
      testSingleCase(fr.casual, 'lundi 8/2/2016', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.text, 'lundi 8/2/2016');
        expect(result.start, toBeDate(DateTime(2016, 2, 8, 12)));
      });
    });
  });

  // =========================================================================
  // Time expression tests
  // =========================================================================

  group('FR Time Expression', () {
    test('Test - Specific time format (8h10)', () {
      testSingleCase(fr.casual, '8h10', DateTime(2012, 8, 10), (result, text) {
        expect(result.index, 0);
        expect(result.text, '8h10');
        expect(result.start.get(Component.hour), 8);
        expect(result.start.get(Component.minute), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 8, 10)));
      });

      testSingleCase(fr.casual, '8h10m', DateTime(2012, 8, 10), (result, text) {
        expect(result.index, 0);
        expect(result.text, '8h10m');
        expect(result.start.get(Component.hour), 8);
        expect(result.start.get(Component.minute), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 8, 10)));
      });

      testSingleCase(fr.casual, '8h10m00s', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '8h10m00s');
        expect(result.start.get(Component.hour), 8);
        expect(result.start.get(Component.minute), 10);
        expect(result.start.isCertain(Component.second), true);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 8, 10)));
      });
    });

    test('Test - Time with AM/PM', () {
      testSingleCase(fr.casual, '8:10 PM', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '8:10 PM');
        expect(result.start.get(Component.hour), 20);
        expect(result.start.get(Component.minute), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 20, 10)));
      });

      testSingleCase(fr.casual, '8h10 PM', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '8h10 PM');
        expect(result.start.get(Component.hour), 20);
        expect(result.start.get(Component.minute), 10);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 20, 10)));
      });

      testSingleCase(fr.casual, '5:16 p.m.', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '5:16 p.m.');
        expect(result.start.get(Component.hour), 17);
        expect(result.start.get(Component.minute), 16);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 17, 16)));
      });

      testSingleCase(fr.casual, 'RDV à 6.13 AM', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.start.get(Component.hour), 6);
        expect(result.start.get(Component.minute), 13);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 6, 13)));
      });
    });

    test('Test - Time range', () {
      testSingleCase(fr.casual, '13h-15h', DateTime(2012, 8, 10),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, '13h-15h');
        expect(result.start.get(Component.hour), 13);
        expect(result.start.get(Component.minute), 0);
        expect(result.start.get(Component.meridiem), 1);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 13, 0)));
        expect(result.end, isNotNull);
        expect(result.end!.get(Component.hour), 15);
        expect(result.end!.get(Component.minute), 0);
        expect(result.end!.get(Component.meridiem), 1);
        expect(result.end, toBeDate(DateTime(2012, 8, 10, 15, 0)));
      });
    });
  });

  // =========================================================================
  // Time units ago tests
  // =========================================================================

  group('FR Time Units Ago', () {
    test('Test - Single Expression', () {
      testSingleCase(fr.casual, 'il y a 5 jours, on a fait quelque chose',
          DateTime(2012, 8, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 5);
        expect(result.index, 0);
        expect(result.text, 'il y a 5 jours');
        expect(result.start, toBeDate(DateTime(2012, 8, 5)));
      });

      testSingleCase(fr.casual, 'il y a 10 jours, on a fait quelque chose',
          DateTime(2012, 8, 10, 13, 30), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 7);
        expect(result.start.get(Component.day), 31);
        expect(result.index, 0);
        expect(result.text, 'il y a 10 jours');
        expect(result.start, toBeDate(DateTime(2012, 7, 31, 13, 30)));
      });

      testSingleCase(
          fr.casual, 'il y a 15 minutes', DateTime(2012, 8, 10, 12, 14),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'il y a 15 minutes');
        expect(result.start.get(Component.hour), 11);
        expect(result.start.get(Component.minute), 59);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 11, 59)));
      });

      testSingleCase(
          fr.casual, '   il y a    12 heures', DateTime(2012, 8, 10, 12, 14),
          (result, text) {
        expect(result.text, 'il y a    12 heures');
        expect(result.start.get(Component.hour), 0);
        expect(result.start.get(Component.minute), 14);
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 0, 14)));
      });
    });

    test('Test - Single Expression (Casual)', () {
      testSingleCase(fr.casual, 'il y a 5 mois, on a fait quelque chose',
          DateTime(2012, 10, 10), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 5);
        expect(result.start.get(Component.day), 10);
        expect(result.index, 0);
        expect(result.text, 'il y a 5 mois');
        expect(result.start, toBeDate(DateTime(2012, 5, 10)));
      });

      testSingleCase(fr.casual, 'il y a 5 ans, on a fait quelque chose',
          DateTime(2012, 8, 10, 22, 22), (result, text) {
        expect(result.start.get(Component.year), 2007);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 10);
        expect(result.index, 0);
        expect(result.text, 'il y a 5 ans');
        expect(result.start, toBeDate(DateTime(2007, 8, 10, 22, 22)));
      });

      testSingleCase(fr.casual, 'il y a une semaine, on a fait quelque chose',
          DateTime(2012, 8, 3, 8, 34), (result, text) {
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 7);
        expect(result.start.get(Component.day), 27);
        expect(result.index, 0);
        expect(result.text, 'il y a une semaine');
        expect(result.start, toBeDate(DateTime(2012, 7, 27, 8, 34)));
      });
    });
  });

  // =========================================================================
  // Time units within tests
  // =========================================================================

  group('FR Time Units Within', () {
    test('Test - Single Expression', () {
      testSingleCase(fr.casual, 'On doit faire quelque chose dans 5 jours.',
          DateTime(2012, 8, 10), (result, text) {
        expect(result.index, 28);
        expect(result.text, 'dans 5 jours');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 15);
        expect(result.start, toBeDate(DateTime(2012, 8, 15)));
      });

      testSingleCase(fr.casual, 'On doit faire quelque chose dans cinq jours.',
          DateTime(2012, 8, 10, 11, 12), (result, text) {
        expect(result.index, 28);
        expect(result.text, 'dans cinq jours');
        expect(result.start.get(Component.year), 2012);
        expect(result.start.get(Component.month), 8);
        expect(result.start.get(Component.day), 15);
        expect(result.start, toBeDate(DateTime(2012, 8, 15, 11, 12)));
      });

      testSingleCase(fr.casual, 'dans 5 minutes', DateTime(2012, 8, 10, 12, 14),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'dans 5 minutes');
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12, 19)));
      });

      testSingleCase(fr.casual, 'pour 5 minutes', DateTime(2012, 8, 10, 12, 14),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'pour 5 minutes');
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12, 19)));
      });

      testSingleCase(fr.casual, 'en 1 heure', DateTime(2012, 8, 10, 12, 14),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'en 1 heure');
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 13, 14)));
      });

      testSingleCase(fr.casual, 'régler une minuterie de 5 minutes',
          DateTime(2012, 8, 10, 12, 14), (result, text) {
        expect(result.index, 21);
        expect(result.text, 'de 5 minutes');
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12, 19)));
      });

      testSingleCase(fr.casual, 'Dans 5 minutes je vais rentrer chez moi',
          DateTime(2012, 8, 10, 12, 14), (result, text) {
        expect(result.index, 0);
        expect(result.text, 'Dans 5 minutes');
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12, 19)));
      });

      testSingleCase(fr.casual, 'Dans 5 secondes une voiture va bouger',
          DateTime(2012, 8, 10, 12, 14), (result, text) {
        expect(result.index, 0);
        expect(result.text, 'Dans 5 secondes');
        expect(result.start, toBeDate(DateTime(2012, 8, 10, 12, 14, 5)));
      });

      testSingleCase(
          fr.casual, 'dans deux semaines', DateTime(2012, 8, 10, 12, 14),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'dans deux semaines');
        expect(result.start, toBeDate(DateTime(2012, 8, 24, 12, 14)));
      });

      testSingleCase(fr.casual, 'dans un mois', DateTime(2012, 8, 10, 7, 14),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'dans un mois');
        expect(result.start, toBeDate(DateTime(2012, 9, 10, 7, 14)));
      });

      testSingleCase(
          fr.casual, 'dans quelques mois', DateTime(2012, 7, 10, 22, 14),
          (result, text) {
        expect(result.index, 0);
        expect(result.text, 'dans quelques mois');
        expect(result.start, toBeDate(DateTime(2012, 10, 10, 22, 14)));
      });
    });
  });

  // =========================================================================
  // Time units casual relative tests
  // =========================================================================

  group('FR Time Units Casual Relative', () {
    test('Test - modifier mandatory just after', () {
      testUnexpectedResult(fr.casual, "le mois d'avril");
      testUnexpectedResult(fr.casual, "le mois d'avril prochain");
    });

    test('Test - relative date', () {
      testSingleCase(fr.casual, 'la semaine prochaine', DateTime(2017, 5, 12),
          (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2017);
        expect(result.start.get(Component.month), 5);
        expect(result.start.get(Component.day), 19);
      });

      testSingleCase(
          fr.casual, 'les 2 prochaines semaines', DateTime(2017, 5, 12, 18, 11),
          (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2017);
        expect(result.start.get(Component.month), 5);
        expect(result.start.get(Component.day), 26);
        expect(result.start.get(Component.hour), 18);
        expect(result.start.get(Component.minute), 11);
      });

      testSingleCase(
          fr.casual, 'les trois prochaines semaines', DateTime(2017, 5, 12),
          (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2017);
        expect(result.start.get(Component.month), 6);
        expect(result.start.get(Component.day), 2);
      });

      testSingleCase(fr.casual, 'le mois dernier', DateTime(2017, 5, 12),
          (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2017);
        expect(result.start.get(Component.month), 4);
        expect(result.start.get(Component.day), 12);
      });

      testSingleCase(
          fr.casual, 'les 30 jours précédents', DateTime(2017, 5, 12),
          (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2017);
        expect(result.start.get(Component.month), 4);
        expect(result.start.get(Component.day), 12);
      });

      testSingleCase(
          fr.casual, 'les 24 heures passées', DateTime(2017, 5, 12, 11, 27),
          (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2017);
        expect(result.start.get(Component.month), 5);
        expect(result.start.get(Component.day), 11);
        expect(result.start.get(Component.hour), 11);
        expect(result.start.get(Component.minute), 27);
      });

      testSingleCase(fr.casual, 'les 90 secondes suivantes',
          DateTime(2017, 5, 12, 11, 27, 3), (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2017);
        expect(result.start.get(Component.month), 5);
        expect(result.start.get(Component.day), 12);
        expect(result.start.get(Component.hour), 11);
        expect(result.start.get(Component.minute), 28);
        expect(result.start.get(Component.second), 33);
      });

      testSingleCase(fr.casual, 'les huit dernieres minutes',
          DateTime(2017, 5, 12, 11, 27), (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2017);
        expect(result.start.get(Component.month), 5);
        expect(result.start.get(Component.day), 12);
        expect(result.start.get(Component.hour), 11);
        expect(result.start.get(Component.minute), 19);
      });

      testSingleCase(
          fr.casual, 'le dernier trimestre', DateTime(2017, 5, 12, 11, 27),
          (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2017);
        expect(result.start.get(Component.month), 2);
        expect(result.start.get(Component.day), 12);
      });

      testSingleCase(
          fr.casual, "l'année prochaine", DateTime(2017, 5, 12, 11, 27),
          (result, text) {
        expect(result.text, text);
        expect(result.start.get(Component.year), 2018);
        expect(result.start.get(Component.month), 5);
        expect(result.start.get(Component.day), 12);
      });
    });
  });
}
