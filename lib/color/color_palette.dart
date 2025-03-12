import 'package:rayo/utils/import_index.dart';

/*  색상 투명도 참고
    FF = 100%
    F2 = 95%
    E6 = 90%
    D9 = 85%
    CC = 80%
    BF = 75%
    B3 = 70%
    A6 = 65%
    99 = 60%
    8C = 55%
    80 = 50%
    73 = 45%
    66 = 40%
    59 = 35%
    4D = 30%
    40 = 25%
    33 = 20%
    26 = 15%
    1A = 10%
    0D = 5%
    00 = 0%
*/
const MaterialColor red = MaterialColor(
  0xFFDC0000,
  <int, Color>{},
);

const MaterialColor skyBlue = MaterialColor(0xFFDEEAF6, <int, Color>{});

const MaterialColor yellow = MaterialColor(
  0xFFFFD400,
  <int, Color>{
    1: Color(0xFFFFEB8C),
    2: Color(0xFFFFB600),
    3: Color(0xFFFF8C00),
    4: Color(0x4DFFD400),
  },
);

// 기본 민트 색상
const MaterialColor mint = MaterialColor(
  0xFF60EFE1,
  <int, Color>{
    2: Color(0xFF48B3A9),
  },
);

const MaterialColor purple = MaterialColor(
  0xFFB868CB,
  <int, Color>{},
);

const MaterialColor black = MaterialColor(
  0xFF3C3C46,
  <int, Color>{
    20: Color(0xFFDCDCE6),
    40: Color(0xFFC8C8D2),
    60: Color(0xFFA5A5AF),
    80: Color(0xFF82828C),
    100: Color(0x993C3C46),
    120: Color(0x33141414), // 투명도 blackbox1
    160: Color(0x99141414), // 투명도 blackbox2
  },
);

const MaterialColor white = MaterialColor(0xFFFFFFFF, <int, Color>{
  80: Color(0xFFEEEEEE),
  90: Color(0xFFF3F3F3),
  150: Color(0x80FFFFFF),
  180: Color(0xCCFFFFFF)
});

const MaterialColor blackShadow = MaterialColor(
  0x263C3C46,
  <int, MaterialColor>{},
);
