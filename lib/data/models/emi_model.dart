class EmiModel {
  final String id;
  final String name;

  // The month from which this EMI starts.
  final String startMonth;

  // Number of months the EMI will continue.
  final int durationMonths;

  // Default amount for the EMI.
  final double defaultAmount;

  // Stores month-specific amount changes.
  final Map<String, double> monthlyAmounts;

  const EmiModel({
    required this.id,
    required this.name,
    required this.startMonth,
    required this.durationMonths,
    required this.defaultAmount,
    required this.monthlyAmounts,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startMonth': startMonth,
      'durationMonths': durationMonths,
      'defaultAmount': defaultAmount,
      'monthlyAmounts': monthlyAmounts,
    };
  }

  factory EmiModel.fromJson(Map<String, dynamic> json) {
    return EmiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startMonth: json['startMonth'] as String,
      durationMonths: json['durationMonths'] as int,
      defaultAmount: (json['defaultAmount'] as num).toDouble(),
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