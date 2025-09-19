// TODO(TensorFlow Lite): تدريب نموذج صغير وتحويله إلى .tflite
// 1) جمع بيانات تاريخية (CSV) تشمل: brand, material, category, region, base_price, sold_price
// 2) تدريب نموذج انحدار (مثل XGBoost أو شبكة بسيطة) باستخدام بايثون أو كولاب
//    - مثال أوّلي: https://www.tensorflow.org/tutorials/keras/regression
// 3) تحويل النموذج إلى TFLite عبر: tensorflow_lite_converter --saved_model_dir=saved_model --output_file=price_model.tflite
// 4) دمجه لاحقاً في التطبيق باستخدام حزمة tflite_flutter وتشغيل الاستدلال محلياً
//    راجع: https://pub.dev/packages/tflite_flutter و https://www.tensorflow.org/lite/guide

import '../models/item.dart';

class PriceEstimator {
  PriceEstimator();

  double estimate(TrendItem item) {
    final materialFactor = _materialFactor(item.tags);
    final brandFactor = _brandPrestige(item.brand);
    final demandFactor = (item.metrics.saves + item.metrics.shares) / 1000;
    final recencyFactor =
        1 + (72 - DateTime.now().difference(item.dropDate).inHours).clamp(0, 48) / 240;

    final estimated = item.basePrice * (1 + materialFactor + brandFactor + demandFactor);
    return (estimated * recencyFactor).clamp(item.basePrice * 0.8, item.basePrice * 1.8);
  }

  double _materialFactor(List<String> tags) {
    if (tags.any((tag) => tag.contains('leather') || tag.contains('holographic'))) {
      return 0.25;
    }
    if (tags.any((tag) => tag.contains('sustainable') || tag.contains('recycled'))) {
      return 0.18;
    }
    if (tags.any((tag) => tag.contains('techwear'))) {
      return 0.2;
    }
    return 0.12;
  }

  double _brandPrestige(String brand) {
    const premiumBrands = ['Nebula Atelier', 'Orbit Lace'];
    const elevatedBrands = ['Luma Line', 'Pulsecraft'];

    if (premiumBrands.contains(brand)) {
      return 0.3;
    }
    if (elevatedBrands.contains(brand)) {
      return 0.2;
    }
    return 0.1;
  }
}
