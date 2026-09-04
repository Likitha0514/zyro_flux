import '../../data/models/emi_model.dart';

class CalculateMonthlyEmi {
  double call(
    List<EmiModel> emis,
    String month,
  ) {
    return emis.fold(
      0,
      (total, emi) {
        return total + (emi.monthlyAmounts[month] ?? 0);
      },
    );
  }
}