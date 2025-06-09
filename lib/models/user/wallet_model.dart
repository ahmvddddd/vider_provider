class WalletModel {
  final double balance;
  final String subscriptionPlan;

  WalletModel({
    required this.balance,
    required this.subscriptionPlan
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] ?? 0).toDouble(),
        subscriptionPlan: json['subscriptionPlan'] ?? ''
      );
  }
}