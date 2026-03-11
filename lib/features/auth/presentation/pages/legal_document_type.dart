/// Types of built-in legal documents available in the app.
enum LegalDocumentType {
  /// Privacy policy document.
  privacyPolicy(
    title: 'Политика конфиденциальности',
    assetPath: 'assets/legal/privacy_policy.txt',
  ),

  /// Personal data processing consent document.
  dataProcessingConsent(
    title: 'Согласие на обработку персональных данных',
    assetPath: 'assets/legal/data_processing_consent.txt',
  ),

  /// Public offer document.
  publicOffer(
    title: 'Публичная оферта',
    assetPath: 'assets/legal/public_offer.txt',
  )
  ;

  /// Visible title of the document page.
  final String title;

  /// Text asset path for the document body.
  final String assetPath;

  /// Creates a [LegalDocumentType].
  const LegalDocumentType({required this.title, required this.assetPath});
}
