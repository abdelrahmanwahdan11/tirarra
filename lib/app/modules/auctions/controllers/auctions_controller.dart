// TODO(Firestore Realtime + Transactions):
// 1) إنشاء مجموعات Firestore: auctions/{auctionId}/bids
// 2) استخدام معاملات Firestore لضمان increment ثابت وتحديث current_price
// 3) Cloud Function تغلق المزاد وتحدد الفائز ثم ترسل إشعار FCM
// 4) بث مباشر للأسعار عبر snapshots أو WebSockets

import 'package:get/get.dart';

import '../../../data/models/auction.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../routes/app_routes.dart';

class AuctionsController extends GetxController {
  AuctionsController({required this.repository});

  final MockRepository repository;

  final RxList<Auction> auctions = <Auction>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAuctions();
  }

  void loadAuctions() {
    auctions.assignAll(repository.loadAuctions());
  }

  void openAuction(Auction auction) {
    Get.toNamed(Routes.auctionDetail, arguments: auction);
  }
}
