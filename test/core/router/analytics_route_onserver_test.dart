// ignore_for_file: unawaited_futures

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/router/analytics_route_observer.dart';
import 'package:moveup_flutter/core/utils/analytics/app_analytics.dart';

import 'analytics_route_onserver_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppAnalytics>()])
void main() {
  late AppAnalytics mockAnalytics;
  late AnalyticsRouteObserver analyticsRouteObserver;

  Future<void> pumpNavigator(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [analyticsRouteObserver],
        home: const Scaffold(body: Text('Home Screen')),
        routes: {'/test': (context) => const Scaffold(body: Text('Test Screen'))},
      ),
    );
  }

  setUp(() {
    mockAnalytics = MockAppAnalytics();
    analyticsRouteObserver = AnalyticsRouteObserver(mockAnalytics);
  });

  group('AnalyticsRouteObserver', () {
    group('didPush', () {
      testWidgets('should log screen view when pushing a named route', (tester) async {
        // Arrange
        await pumpNavigator(tester);
        clearInteractions(mockAnalytics);

        // Act
        final context = tester.element(find.text('Home Screen'));
        Navigator.pushNamed(context, '/test');
        await tester.pumpAndSettle();

        // Assert
        verify(mockAnalytics.logScreenView('/test')).called(1);
      });

      testWidgets('should not log screen view when pushing a route without name', (tester) async {
        // Arrange
        await pumpNavigator(tester);
        clearInteractions(mockAnalytics);

        // Act
        final context = tester.element(find.text('Home Screen'));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SizedBox()));
        await tester.pumpAndSettle();

        // Assert
        verifyNever(mockAnalytics.logScreenView('/test'));
      });
    });

    group('didPop', () {
      testWidgets('should log previous route name when popping current route', (tester) async {
        // Arrange
        await pumpNavigator(tester);
        final context = tester.element(find.text('Home Screen'));
        Navigator.pushNamed(context, '/test');
        await tester.pumpAndSettle();
        clearInteractions(mockAnalytics);

        // Act
        Navigator.pop(context, tester.element(find.text('Test Screen')));
        await tester.pumpAndSettle();

        // Assert
        verify(mockAnalytics.logScreenView('/')).called(1);
      });
    });

    group('Initialization', () {
      testWidgets('should log initial route on app start', (tester) async {
        await pumpNavigator(tester);
        verify(mockAnalytics.logScreenView('/')).called(1);
      });
    });
  });
}
