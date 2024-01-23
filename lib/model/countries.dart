class Countries {
  List<Countries>? countries;

  Countries({this.countries});

  Countries.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountriesRegulations {
  String? name;
  String? code;
  String? emissionsRegulations;

  CountriesRegulations({this.name, this.code, this.emissionsRegulations});

  CountriesRegulations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    emissionsRegulations = json['emissions_regulations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['emissions_regulations'] = emissionsRegulations;
    return data;
  }
}
