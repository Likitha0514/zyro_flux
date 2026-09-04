class EmiModel {
  final String id;
  final String name;
  final Map<String, double> monthlyAmounts;

  const EmiModel({
    required this.id,
    required this.name,
    required this.monthlyAmounts,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'monthlyAmounts': monthlyAmounts,
    };
  }

  factory EmiModel.fromJson(Map<String, dynamic> json) {
    return EmiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      monthlyAmounts: Map<String, double>.from(
        (json['monthlyAmounts'] as Map).map(
          (key, value) => MapEntry(
            key.toString(),
            (value as num).toDouble(),
          ),
        ),
      ),
    );
  }
}