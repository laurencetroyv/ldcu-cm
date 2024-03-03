import 'eac_data.dart';
import 'liceo_civic_center.dart';
import 'nac_data.dart';
import 'rodelsa_hall.dart';
import 'sac_data.dart';
import 'wac_data.dart';

export 'eac_data.dart';
export 'liceo_civic_center.dart';
export 'nac_data.dart';
export 'rodelsa_hall.dart';
export 'sac_data.dart';
export 'wac_data.dart';

const data = [
  ...eacData,
  ...lccData,
  ...nacData,
  ...rhData,
  ...sacData,
  ...wacData
];

const buildings = ["WAC", "NAC", "EAC", "SAC", "LCC", "Rodelsa Hall"];
