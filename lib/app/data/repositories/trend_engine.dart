// TODO(Firebase Functions): خطوات إنشاء Function لحساب الترند كل ساعة
// 1) إنشاء مشروع Firebase عبر Firebase Console أو CLI: firebase projects:create trendwear-app
// 2) تفعيل Firebase Functions و Firestore: firebase init functions firestore
// 3) كتابة function (Node.js أو TypeScript) تقوم بقراءة تفاعلات العناصر، حساب trend_score وتحديث الحقول في Firestore
//    - استخدم مجاميع مجدولة لكل عنصر أو collectionGroup queries
//    - احفظ النتيجة في حقل trend_score و trend_rank
// 4) جدولة الوظيفة كل ساعة عبر: firebase deploy --only functions && firebase scheduler:schedules:create
//    راجع الوثائق: https://firebase.google.com/docs/functions/schedule-functions
//    وعمليات Firestore المجدولة: https://firebase.google.com/docs/firestore/solutions/schedule-export

import 'dart:math';

import '../models/item.dart';

class TrendEngine {
  const TrendEngine({
    this.weights = const TrendWeights(),
    this.recencyHalfLifeHours = 48,
  });

  final TrendWeights weights;
  final int recencyHalfLifeHours;

  TrendItem applyScore(TrendItem item) {
    final score = calculateScore(item);
    return item.copyWith(trendScore: score);
  }

  double calculateScore(TrendItem item) {
    final metrics = item.metrics;
    final now = DateTime.now();
    final hoursSinceInteraction =
        max(1, now.difference(metrics.lastInteraction).inHours);
    final recencyDecay = pow(0.5, hoursSinceInteraction / recencyHalfLifeHours);

    final baseScore = metrics.views * weights.views +
        metrics.saves * weights.saves +
        metrics.shares * weights.shares +
        metrics.clicks * weights.clicks;

    return baseScore * (1 + recencyDecay * weights.recencyBoost);
  }

  List<TrendItem> sortByTrend(List<TrendItem> items) {
    final scored = items.map(applyScore).toList();
    scored.sort((a, b) => (b.trendScore ?? 0).compareTo(a.trendScore ?? 0));
    return scored;
  }
}

class TrendWeights {
  const TrendWeights({
    this.views = 0.35,
    this.saves = 0.25,
    this.shares = 0.2,
    this.clicks = 0.2,
    this.recencyBoost = 0.6,
  });

  final double views;
  final double saves;
  final double shares;
  final double clicks;
  final double recencyBoost;
}
