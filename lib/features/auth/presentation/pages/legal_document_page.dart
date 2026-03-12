import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/app_back_button.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import 'legal_document_type.dart';

/// Page that displays a bundled legal document from local text assets.
class LegalDocumentPage extends StatelessWidget {
  /// Type of document to display.
  final LegalDocumentType legalDocumentType;

  /// Creates a [LegalDocumentPage].
  const LegalDocumentPage({required this.legalDocumentType, super.key});

  Future<String> _loadDocument() => rootBundle.loadString(legalDocumentType.assetPath);

  void _handleBack(BuildContext context) =>
      Navigator.of(context).canPop() ? context.pop() : context.go(AppRoutePaths.signUpPath);

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AppBackButton(onPressed: () => _handleBack(context)),
              ),
              const SizedBox(height: 24),
              Text(
                legalDocumentType.title,
                textAlign: TextAlign.center,
                style: textTheme.title,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: FutureBuilder<String>(
                  future: _loadDocument(),
                  builder: (context, snapshot) {
                    final colorTheme = AppColorTheme.of(context);
                    final bodyStyle = textTheme.body.copyWith(color: colorTheme.onSurface);

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          AppStrings.legalDocumentLoadError,
                          textAlign: TextAlign.center,
                          style: textTheme.body.copyWith(color: colorTheme.onSurface),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(strokeWidth: 4),
                      );
                    }
                    return SingleChildScrollView(
                      child: SelectionArea(
                        child: Text(
                          snapshot.data!,
                          style: bodyStyle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
