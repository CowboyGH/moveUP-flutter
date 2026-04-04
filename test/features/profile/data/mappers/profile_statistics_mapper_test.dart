import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/features/profile/data/dto/stats/frequency_response_dto.dart';
import 'package:moveup_flutter/features/profile/data/mappers/profile_statistics_mapper.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/frequency_period.dart';

import '../../support/profile_statistics_dto_fixtures.dart';

void main() {
  group('ProfileStatisticsMapper', () {
    test('maps volume statistics dto to volume entity', () {
      final result = createVolumeStatisticsDto().toEntity();

      expect(result.exerciseId, testVolumeExerciseId);
      expect(result.title, testVolumeExerciseTitle);
      expect(result.averageScorePercent, testVolumeAverageScorePercent);
      expect(result.period.weekOffset, testVolumeWeekOffset);
      expect(result.chart.first.label, 'Пн');
    });

    test('maps frequency statistics dto to frequency entity with fallback period', () {
      final result =
          createFrequencyStatisticsDto(
            includePeriodInfo: false,
          ).toEntity(
            fallbackPeriod: FrequencyPeriod.year,
            fallbackOffset: 2,
          );

      expect(result.period, FrequencyPeriod.year);
      expect(result.offset, 2);
      expect(result.averagePerWeek, 2.3);
    });

    test('maps weekly frequency dto without short_label', () {
      final result =
          createFrequencyStatisticsDto(
            periodInfo: FrequencyPeriodInfoDto(
              type: 'week',
              offset: 0,
              label: 'Текущяя неделя',
              itemsCount: 7,
            ),
            chart: [
              FrequencyChartItemDto(
                dayIndex: 0,
                dayNumber: 1,
                weekIndex: null,
                weekNumber: null,
                label: 'Пн',
                dateFormatted: '30.03',
                startDate: null,
                endDate: null,
                count: 0,
                goal: null,
              ),
            ],
          ).toEntity(
            fallbackPeriod: FrequencyPeriod.month,
            fallbackOffset: 0,
          );

      expect(result.period, FrequencyPeriod.week);
      expect(result.chart.first.label, 'Пн');
      expect(result.chart.first.shortLabel, 'Пн');
    });

    test('maps workout selector dto to profile workout options', () {
      final result = createProfileWorkoutsResponseDto().data.toEntity();

      expect(result, hasLength(1));
      expect(result.first.id, testTrendWorkoutId);
      expect(result.first.title, testTrendWorkoutTitle);
      expect(result.first.completedAtFormatted, '18.03.2026');
    });
  });
}
