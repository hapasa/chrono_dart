# Chrono - Date parser for Dart (Flutter)

[![pub.dev/packages/chrono_dart](https://img.shields.io/pub/v/chrono_dart.svg "chrono_dart on pub.dev")](https://pub.dev/packages/chrono_dart)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A natural language date parser in Dart. Finds and extracts dates from user-generated text content.

Example use case – WhatsApp-like date parsing in dialogues:
<img src="https://github.com/g-30/chrono_dart/assets/8287493/f148289e-1e53-4b7d-9922-c28c6f1a12e5" height="290" alt="chrono_dart">


It is designed to handle most date/time formats and extract information from any given text:

* Today, Tomorrow, Yesterday, Last Friday, etc
* 17 August 2013 - 19 August 2013
* This Friday from 13:00 - 16.00
* 5 days ago
* 2 weeks from now
* Sat Aug 17 2013 18:40:39 GMT+0900 (JST)
* 2014-11-30T08:15:30-05:30

# Usage
1. Install manually or via pub - `dart pub add chrono_dart`
2. Simply pass a string to functions Chrono.parseDate or Chrono.parse.

```dart
import 'package:chrono_dart/chrono_dart.dart' show Chrono;

Chrono.parseDate('An appointment on Sep 12');
// DateTime('2023-09-12 12:00:00.000Z')
    
Chrono.parse('An appointment on Sep 12');
/* [<ParsingResult>{ 
    index: 18,
    text: 'Sep 12',
    date() => DateTime('2023-09-12T12:00:00'),
    ...
}] */
```

English, French, and Danish are supported.

## French Usage

```dart
import 'package:chrono_dart/src/locales/fr/fr.dart' as fr;

// Casual parsing
fr.casual.parseDate("La deadline est demain");
fr.parse("il y a 5 jours");

// Strict parsing
fr.strict.parse("10 Août 2012");
```

French supports: casual dates (maintenant, aujourd'hui, demain, hier), month names (accentuated and unaccentuated), weekdays, date ranges, time expressions (8h10, 13h-15h), "il y a" (ago), "dans" (within), and relative expressions (la semaine prochaine, le mois dernier).

## Danish Usage

```dart
import 'package:chrono_dart/src/locales/da/da.dart' as da;

// Casual parsing
da.casual.parseDate('Deadline er i morgen');
da.parse('næste 2 uger');

// Strict parsing
da.strict.parse('15 august 2012');
```


-----------
Port of Chrono to Dart lang.
For extended API information see [the original package](https://github.com/wanasit/chrono/).