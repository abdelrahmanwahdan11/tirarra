import 'item.dart';

class Deal {
  const Deal({
    required this.id,
    required this.item,
    required this.discountPercent,
    required this.startTime,
    required this.endTime,
    required this.badgeLabel,
  });

  final String id;
  final TrendItem item;
  final double discountPercent;
  final DateTime startTime;
  final DateTime endTime;
  final String badgeLabel;

  Duration get remaining => endTime.difference(DateTime.now());
}
