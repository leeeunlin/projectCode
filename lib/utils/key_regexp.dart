// ignore_for_file: non_constant_identifier_names
const String localUri = '192.168.0.58:8080';
const String serverUri = 'api.rayomeet.com';
const String cdnUri = 'https://data.rayomeet.com/';
const String statusCode = 'statusCode';
const String data = 'data';
const String pagination = 'pagination';
// RegExp NAME_REG_EXP = RegExp(r'[a-z|A-Z|0-9|_|\-|+|.]');
RegExp REG_number = RegExp(r'[0-9]');
RegExp REG_mailInput = RegExp(r'[a-zA-Z0-9@._-]');
RegExp REG_firstBlank = RegExp(r'^\S.*$');
RegExp REG_mail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
