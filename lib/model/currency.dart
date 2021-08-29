class Currency {
  final String currency_code;
  final String currency_text;
  Currency({required this.currency_code, required this.currency_text});

  factory Currency.fromJson(Map<String, String> json) {
    return Currency(
      currency_code: json['title'] as String,
      currency_text: json['nbLike'] as String,
    );
  }
  @override
  String toString() {
    // TODO: implement toString

    return currency_code;
  }
}
