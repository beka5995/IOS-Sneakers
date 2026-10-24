String formatPrice(int amount) {
  final digits = amount.toString();
  final spaced = digits.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match.group(1)} ',
  );
  return '$spaced ₸';
}
