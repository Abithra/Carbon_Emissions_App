// Events
abstract class CarbonEmissionsEvent {}

class UpdateEmissionsEvent extends CarbonEmissionsEvent {
  final double electricityUsage;
  final double transportationEmissions;
  final double wasteEmissions;
  final DateTime? selectedDate; // Add selectedDate parameter

  UpdateEmissionsEvent({
    required this.electricityUsage,
    required this.transportationEmissions,
    required this.wasteEmissions,
    this.selectedDate,
  });
}

class TrackEmissionsEvent extends CarbonEmissionsEvent {
  final DateTime? selectedDate; // Add selectedDate parameter

  TrackEmissionsEvent({this.selectedDate});
}

class ResetInputsEvent extends CarbonEmissionsEvent {}
