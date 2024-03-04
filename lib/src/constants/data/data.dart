import 'package:ldcu/src/constants/constants.dart';

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

const buildings = [
  kLccBuildingName,
  kSacBuildingName,
  kWacBuildingName,
  kNacBuildingName,
  kEacBuildingName,
  kRodelsaName,
  kLibraryName,
  kCivilBuildingName,
];
