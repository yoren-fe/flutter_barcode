import 'dart:convert';

const int _CHAR_TILDE = 126;
const int _CODE_FNC1 = 102;

const int _SET_START_A = 103;
const int _SET_START_B = 104;
const int _SET_START_C = 105;
const int _SET_SHIFT = 98;
const int _SET_CODE_A = 101;
const int _SET_CODE_B = 100;
const int _SET_STOP = 106;

const _REPLACE_CODES = {
  _CHAR_TILDE: _CODE_FNC1 //~ corresponds to FNC1 in GS1-128 standard
};

const Map<String, int> _CODE_SET = {'ANY': 1, 'AB': 2, 'A': 3, 'B': 4, 'C': 5};
Map<String, int> _barC = {'currcs': _CODE_SET['C']};

const PATTERNS = [
  [2, 1, 2, 2, 2, 2, 0, 0], // 0
  [2, 2, 2, 1, 2, 2, 0, 0], // 1
  [2, 2, 2, 2, 2, 1, 0, 0], // 2
  [1, 2, 1, 2, 2, 3, 0, 0], // 3
  [1, 2, 1, 3, 2, 2, 0, 0], // 4
  [1, 3, 1, 2, 2, 2, 0, 0], // 5
  [1, 2, 2, 2, 1, 3, 0, 0], // 6
  [1, 2, 2, 3, 1, 2, 0, 0], // 7
  [1, 3, 2, 2, 1, 2, 0, 0], // 8
  [2, 2, 1, 2, 1, 3, 0, 0], // 9
  [2, 2, 1, 3, 1, 2, 0, 0], // 10
  [2, 3, 1, 2, 1, 2, 0, 0], // 11
  [1, 1, 2, 2, 3, 2, 0, 0], // 12
  [1, 2, 2, 1, 3, 2, 0, 0], // 13
  [1, 2, 2, 2, 3, 1, 0, 0], // 14
  [1, 1, 3, 2, 2, 2, 0, 0], // 15
  [1, 2, 3, 1, 2, 2, 0, 0], // 16
  [1, 2, 3, 2, 2, 1, 0, 0], // 17
  [2, 2, 3, 2, 1, 1, 0, 0], // 18
  [2, 2, 1, 1, 3, 2, 0, 0], // 19
  [2, 2, 1, 2, 3, 1, 0, 0], // 20
  [2, 1, 3, 2, 1, 2, 0, 0], // 21
  [2, 2, 3, 1, 1, 2, 0, 0], // 22
  [3, 1, 2, 1, 3, 1, 0, 0], // 23
  [3, 1, 1, 2, 2, 2, 0, 0], // 24
  [3, 2, 1, 1, 2, 2, 0, 0], // 25
  [3, 2, 1, 2, 2, 1, 0, 0], // 26
  [3, 1, 2, 2, 1, 2, 0, 0], // 27
  [3, 2, 2, 1, 1, 2, 0, 0], // 28
  [3, 2, 2, 2, 1, 1, 0, 0], // 29
  [2, 1, 2, 1, 2, 3, 0, 0], // 30
  [2, 1, 2, 3, 2, 1, 0, 0], // 31
  [2, 3, 2, 1, 2, 1, 0, 0], // 32
  [1, 1, 1, 3, 2, 3, 0, 0], // 33
  [1, 3, 1, 1, 2, 3, 0, 0], // 34
  [1, 3, 1, 3, 2, 1, 0, 0], // 35
  [1, 1, 2, 3, 1, 3, 0, 0], // 36
  [1, 3, 2, 1, 1, 3, 0, 0], // 37
  [1, 3, 2, 3, 1, 1, 0, 0], // 38
  [2, 1, 1, 3, 1, 3, 0, 0], // 39
  [2, 3, 1, 1, 1, 3, 0, 0], // 40
  [2, 3, 1, 3, 1, 1, 0, 0], // 41
  [1, 1, 2, 1, 3, 3, 0, 0], // 42
  [1, 1, 2, 3, 3, 1, 0, 0], // 43
  [1, 3, 2, 1, 3, 1, 0, 0], // 44
  [1, 1, 3, 1, 2, 3, 0, 0], // 45
  [1, 1, 3, 3, 2, 1, 0, 0], // 46
  [1, 3, 3, 1, 2, 1, 0, 0], // 47
  [3, 1, 3, 1, 2, 1, 0, 0], // 48
  [2, 1, 1, 3, 3, 1, 0, 0], // 49
  [2, 3, 1, 1, 3, 1, 0, 0], // 50
  [2, 1, 3, 1, 1, 3, 0, 0], // 51
  [2, 1, 3, 3, 1, 1, 0, 0], // 52
  [2, 1, 3, 1, 3, 1, 0, 0], // 53
  [3, 1, 1, 1, 2, 3, 0, 0], // 54
  [3, 1, 1, 3, 2, 1, 0, 0], // 55
  [3, 3, 1, 1, 2, 1, 0, 0], // 56
  [3, 1, 2, 1, 1, 3, 0, 0], // 57
  [3, 1, 2, 3, 1, 1, 0, 0], // 58
  [3, 3, 2, 1, 1, 1, 0, 0], // 59
  [3, 1, 4, 1, 1, 1, 0, 0], // 60
  [2, 2, 1, 4, 1, 1, 0, 0], // 61
  [4, 3, 1, 1, 1, 1, 0, 0], // 62
  [1, 1, 1, 2, 2, 4, 0, 0], // 63
  [1, 1, 1, 4, 2, 2, 0, 0], // 64
  [1, 2, 1, 1, 2, 4, 0, 0], // 65
  [1, 2, 1, 4, 2, 1, 0, 0], // 66
  [1, 4, 1, 1, 2, 2, 0, 0], // 67
  [1, 4, 1, 2, 2, 1, 0, 0], // 68
  [1, 1, 2, 2, 1, 4, 0, 0], // 69
  [1, 1, 2, 4, 1, 2, 0, 0], // 70
  [1, 2, 2, 1, 1, 4, 0, 0], // 71
  [1, 2, 2, 4, 1, 1, 0, 0], // 72
  [1, 4, 2, 1, 1, 2, 0, 0], // 73
  [1, 4, 2, 2, 1, 1, 0, 0], // 74
  [2, 4, 1, 2, 1, 1, 0, 0], // 75
  [2, 2, 1, 1, 1, 4, 0, 0], // 76
  [4, 1, 3, 1, 1, 1, 0, 0], // 77
  [2, 4, 1, 1, 1, 2, 0, 0], // 78
  [1, 3, 4, 1, 1, 1, 0, 0], // 79
  [1, 1, 1, 2, 4, 2, 0, 0], // 80
  [1, 2, 1, 1, 4, 2, 0, 0], // 81
  [1, 2, 1, 2, 4, 1, 0, 0], // 82
  [1, 1, 4, 2, 1, 2, 0, 0], // 83
  [1, 2, 4, 1, 1, 2, 0, 0], // 84
  [1, 2, 4, 2, 1, 1, 0, 0], // 85
  [4, 1, 1, 2, 1, 2, 0, 0], // 86
  [4, 2, 1, 1, 1, 2, 0, 0], // 87
  [4, 2, 1, 2, 1, 1, 0, 0], // 88
  [2, 1, 2, 1, 4, 1, 0, 0], // 89
  [2, 1, 4, 1, 2, 1, 0, 0], // 90
  [4, 1, 2, 1, 2, 1, 0, 0], // 91
  [1, 1, 1, 1, 4, 3, 0, 0], // 92
  [1, 1, 1, 3, 4, 1, 0, 0], // 93
  [1, 3, 1, 1, 4, 1, 0, 0], // 94
  [1, 1, 4, 1, 1, 3, 0, 0], // 95
  [1, 1, 4, 3, 1, 1, 0, 0], // 96
  [4, 1, 1, 1, 1, 3, 0, 0], // 97
  [4, 1, 1, 3, 1, 1, 0, 0], // 98
  [1, 1, 3, 1, 4, 1, 0, 0], // 99
  [1, 1, 4, 1, 3, 1, 0, 0], // 100
  [3, 1, 1, 1, 4, 1, 0, 0], // 101
  [4, 1, 1, 1, 3, 1, 0, 0], // 102
  [2, 1, 1, 4, 1, 2, 0, 0], // 103
  [2, 1, 1, 2, 1, 4, 0, 0], // 104
  [2, 1, 1, 2, 3, 2, 0, 0], // 105
  [2, 3, 3, 1, 1, 1, 2, 0] // 106
];

class Code123C {
  Code123C._();

  static List<int> stringToCode128(String data) {
    List<int> bytes = _getBytes(data);
    int index = bytes[0] == _CHAR_TILDE ? 1 : 0;
    int csa1 = bytes.length > 0 ? _codeSetAllowedFor(bytes[index++]) : _CODE_SET['AB'];
    int csa2 = bytes.length > 0 ? _codeSetAllowedFor(bytes[index++]) : _CODE_SET['AB'];
    _barC['currcs'] = _getBestStartSet(csa1, csa2);
    _barC['currcs'] = _perhapsCodeC(bytes, _barC['currcs']);

    List<int> codes = [];
    switch (_barC['currcs']) {
      case 3:
        codes.add(_SET_START_A);
        break;
      case 4:
        codes.add(_SET_START_B);
        break;
      default:
        codes.add(_SET_START_C);
        break;
    }

    for (int i = 0; i < bytes.length; i++) {
      int b1 = bytes[i];
      if (_REPLACE_CODES.containsKey(b1)) {
        codes.add(_REPLACE_CODES[b1]);
        i++; //jump to next
        b1 = bytes[i];
      }
      int b2 = bytes.length > (i + 1) ? bytes[i + 1] : -1;
      codes.addAll(_codesForChar(b1, b2, _barC['currcs']));
      //code C takes 2 chars each time
      if (_barC['currcs'] == _CODE_SET['C']) i++;
    }

    //calculate checksum according to Code 128 standards
    int checksum = codes[0];
    for (int weight = 1; weight < codes.length; weight++) {
      checksum += (weight * codes[weight]);
    }
    codes.add(checksum % 103);

    codes.add(_SET_STOP);
    return codes;
  }

  static List<int> _getBytes(String str) {
    return utf8.encode(str);
  }

  static int _codeSetAllowedFor(int chr) {
    if (chr >= 48 && chr <= 57) {
      //0-9
      return _CODE_SET['ANY'];
    } else if (chr >= 32 && chr <= 95) {
      //0-9 A-Z
      return _CODE_SET['AB'];
    } else {
      //if non printable
      return chr < 32 ? _CODE_SET['A'] : _CODE_SET['B'];
    }
  }

  static int _getBestStartSet(int csa1, int csa2) {
    //tries to figure out the best codeset
    //to start with to get the most compact code
    int vote = 0;
    vote += csa1 == _CODE_SET['A'] ? 1 : 0;
    vote += csa1 == _CODE_SET['B'] ? -1 : 0;
    vote += csa2 == _CODE_SET['A'] ? 1 : 0;
    vote += csa2 == _CODE_SET['B'] ? -1 : 0;
    //tie goes to B due to my own predudices
    return vote > 0 ? _CODE_SET['A'] : _CODE_SET['B'];
  }

  static int _perhapsCodeC(List<int> bytes, int codeset) {
    for (var byte in bytes) {
      if ((byte < 48 || byte > 57) && byte != _CHAR_TILDE) return codeset;
    }
    return _CODE_SET['C'];
  }

  static List<int> _codesForChar(int chr1, int chr2, int currcs) {
    List<int> result = [];
    int shifter = -1;
    if (_charCompatible(chr1, currcs)) {
      if (currcs == _CODE_SET['C']) {
        if (chr2 == -1) {
          shifter = _SET_CODE_B;
          currcs = _CODE_SET['B'];
        } else if ((chr2 != -1) && !_charCompatible(chr2, currcs)) {
          //need to check ahead as well
          if (_charCompatible(chr2, _CODE_SET['A'])) {
            shifter = _SET_CODE_A;
            currcs = _CODE_SET['A'];
          } else {
            shifter = _SET_CODE_B;
            currcs = _CODE_SET['B'];
          }
        }
      }
    } else {
      //if there is a next char AND that next char is also not compatible
      if ((chr2 != -1) && !_charCompatible(chr2, currcs)) {
        if (currcs == _CODE_SET['A']) {
          shifter = _SET_CODE_B;
          currcs = _CODE_SET['B'];
        } else if (currcs == _CODE_SET['B']) {
          shifter = _SET_CODE_A;
          currcs = _CODE_SET['A'];
        }
        //need to switch code sets
      } else {
        //no need to shift code sets, a temporary SHIFT will suffice
        shifter = _SET_SHIFT;
      }
    }

    //ok some type of shift is nessecary
    if (shifter != -1) {
      result.add(shifter);
      //result.push(_codeValue(chr2)); <- fix a bug for code128C
      result.add(_codeValue(chr1, null));
    } else {
      if (currcs == _CODE_SET['C']) {
        //include next as well
        result.add(_codeValue(chr1, chr2));
      } else {
        result.add(_codeValue(chr1, null));
      }
    }
    _barC['currcs'] = currcs;
    return result;
  }

  static bool _charCompatible(int chr, int codeset) {
    int csa = _codeSetAllowedFor(chr);
    if (csa == _CODE_SET['ANY']) return true;
    //if we need to change from current
    if (csa == _CODE_SET['AB']) return true;
    if (csa == _CODE_SET['A'] && codeset == _CODE_SET['A']) return true;
    if (csa == _CODE_SET['B'] && codeset == _CODE_SET['B']) return true;
    return false;
  }

//reduce the ascii code to fit into the Code128 char table
  static int _codeValue(int chr1, int chr2) {
    if (chr2 == null) {
      return chr1 >= 32 ? chr1 - 32 : chr1 + 64;
    } else {
      return int.parse((String.fromCharCode(chr1) + String.fromCharCode(chr2)));
    }
  }
}
