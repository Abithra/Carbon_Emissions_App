// States
abstract class CarbonEmissionsState {}

class CarbonEmissionsInitialState extends CarbonEmissionsState {}

class CarbonEmissionsUpdatedState extends CarbonEmissionsState {
  final double totalEmissions;

  CarbonEmissionsUpdatedState(this.totalEmissions, DateTime? selectedDate);
}

class CarbonEmissionsTrackedState extends CarbonEmissionsState {
  final List<double> emissionsHistory;

  CarbonEmissionsTrackedState(this.emissionsHistory, DateTime? selectedDate);
}

class CarbonEmissionsResetState extends CarbonEmissionsState {}