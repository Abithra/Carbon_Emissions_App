import 'package:flutter_bloc/flutter_bloc.dart';
import 'carbon_emissions_event.dart';
import 'carbon_emissions_state.dart';

class CarbonEmissionsBloc extends Bloc<CarbonEmissionsEvent, CarbonEmissionsState> {
  double electricityUsage = 0.0;
  double transportationEmissions = 0.0;
  double wasteEmissions = 0.0;
  double totalEmissions = 0.0;
  List<double> emissionsHistory = [];
  DateTime? selectedDate; // Add selectedDate property

  CarbonEmissionsBloc() : super(CarbonEmissionsInitialState()) {
    on<UpdateEmissionsEvent>((event, emit) {
      electricityUsage = event.electricityUsage;
      transportationEmissions = event.transportationEmissions;
      wasteEmissions = event.wasteEmissions;
      totalEmissions = electricityUsage + transportationEmissions + wasteEmissions;
      selectedDate = event.selectedDate; // Set selectedDate
      emit(CarbonEmissionsUpdatedState(totalEmissions, selectedDate));
    });

    on<TrackEmissionsEvent>((event, emit) {
      _trackEmissions();
      emit(CarbonEmissionsTrackedState(List.from(emissionsHistory), selectedDate));
    });

    on<ResetInputsEvent>((event, emit) {
      electricityUsage = 0.0;
      transportationEmissions = 0.0;
      wasteEmissions = 0.0;
      totalEmissions = 0.0;
      selectedDate = null; // Reset selectedDate
      emit(CarbonEmissionsResetState());
    });
  }

  @override
  Stream<CarbonEmissionsState> mapEventToState(CarbonEmissionsEvent event) async* {
    if (event is UpdateEmissionsEvent) {
      electricityUsage = event.electricityUsage;
      transportationEmissions = event.transportationEmissions;
      wasteEmissions = event.wasteEmissions;
      totalEmissions = electricityUsage + transportationEmissions + wasteEmissions;
      selectedDate = event.selectedDate; // Set selectedDate
      yield CarbonEmissionsUpdatedState(totalEmissions, selectedDate);
    } else if (event is TrackEmissionsEvent) {
      _trackEmissions();
      yield CarbonEmissionsTrackedState(List.from(emissionsHistory), selectedDate);
    } else if (event is ResetInputsEvent) {
      electricityUsage = 0.0;
      transportationEmissions = 0.0;
      wasteEmissions = 0.0;
      totalEmissions = 0.0;
      selectedDate = null; // Reset selectedDate
      yield CarbonEmissionsResetState();
    }
  }

  void _trackEmissions() {
    emissionsHistory.add(totalEmissions);
  }
}
