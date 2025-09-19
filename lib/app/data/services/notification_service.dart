// TODO(Auth + FCM):
// 1) تفعيل Firebase Auth (Email/Phone/Anonymous) وإضافة GoogleService-Info.plist و google-services.json
// 2) إنشاء Cloud Functions لإرسال إشعارات FCM حسب Topics (مثل deals، auctions)
// 3) ربط معرف المستخدم بالمزايدات والمفضلة في Firestore
// 4) إعداد سياسات الإذن للإشعارات Android/iOS/Web + التعامل مع Notification API على الويب
//    docs: https://firebase.google.com/docs/cloud-messaging/flutter/client

abstract class NotificationService {
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Future<void> requestPermission();
}

class MockNotificationService implements NotificationService {
  const MockNotificationService();

  @override
  Future<void> requestPermission() async {
    // Local mock; no-op
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    // Local mock; store preference in GetStorage in future phases
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    // Local mock
  }
}
