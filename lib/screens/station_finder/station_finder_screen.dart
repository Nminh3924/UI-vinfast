import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

class StationFinderScreen extends StatefulWidget {
  const StationFinderScreen({super.key});

  @override
  State<StationFinderScreen> createState() => _StationFinderScreenState();
}

class _StationFinderScreenState extends State<StationFinderScreen> {
  bool _isElectric = true; // true = trạm sạc, false = trạm xăng

  final List<_Station> _electricStations = [
    _Station(
      name: 'Trạm sạc VinFast - Vinhomes Grand Park',
      address: '12 Nguyễn Xiển, TP. Thủ Đức',
      distance: '1.2 km',
      type: 'V-Green',
      available: 4,
    ),
    _Station(
      name: 'Trạm sạc VinFast - Landmark 81',
      address: '720 Điện Biên Phủ, Bình Thạnh',
      distance: '3.5 km',
      type: 'VinFast',
      available: 2,
    ),
    _Station(
      name: 'Trạm sạc V-Green - Aeon Mall',
      address: 'Aeon Mall Tân Phú, Tân Phú',
      distance: '5.8 km',
      type: 'V-Green',
      available: 6,
    ),
  ];

  final List<_Station> _gasStations = [
    _Station(
      name: 'Petrolimex - 15 Nguyễn Huệ',
      address: '15 Nguyễn Huệ, Quận 1',
      distance: '0.8 km',
      type: 'Petrolimex',
      available: -1,
    ),
    _Station(
      name: 'PVOil - Lý Thường Kiệt',
      address: '200 Lý Thường Kiệt, Quận 10',
      distance: '2.1 km',
      type: 'PVOil',
      available: -1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final stations = _isElectric ? _electricStations : _gasStations;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceVariant = isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? Colors.white : AppColors.lightOnSurface;
    final subtextColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
        ),
        title: Text(
          'Tìm trạm',
          style: AppTextStyles.titleLarge(color: textColor),
        ),
      ),
      body: Column(
        children: [
          // ─── Toggle ───
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isElectric = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: _isElectric
                              ? AppColors.driverModeGradient
                              : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.ev_station_rounded,
                                size: 18,
                                color: _isElectric
                                    ? Colors.white
                                    : subtextColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Trạm sạc',
                                style: AppTextStyles.labelMedium(
                                  color: _isElectric
                                      ? Colors.white
                                      : subtextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isElectric = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: !_isElectric
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFFF9500),
                                    Color(0xFFFF6B00),
                                  ],
                                )
                              : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_gas_station_rounded,
                                size: 18,
                                color: !_isElectric
                                    ? Colors.white
                                    : subtextColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Trạm xăng',
                                style: AppTextStyles.labelMedium(
                                  color: !_isElectric
                                      ? Colors.white
                                      : subtextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ─── Map placeholder ───
          Container(
            height: 180,
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_rounded,
                        size: 48,
                        color: subtextColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bản đồ khu vực',
                        style: AppTextStyles.bodyMedium(
                          color: subtextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Current location dot
                Positioned(
                  top: 80,
                  left: 90,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ─── Results ───
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Row(
              children: [
                Text(
                  'Kết quả gần nhất',
                  style: AppTextStyles.titleMedium(color: textColor),
                ),
                const Spacer(),
                Text(
                  '${stations.length} trạm',
                  style: AppTextStyles.bodySmall(
                    color: subtextColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              itemCount: stations.length,
              itemBuilder: (context, index) {
                return _StationCard(
                  station: stations[index],
                  isElectric: _isElectric,
                  surfaceColor: surfaceColor,
                  surfaceVariant: surfaceVariant,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Station {
  final String name;
  final String address;
  final String distance;
  final String type;
  final int available;

  _Station({
    required this.name,
    required this.address,
    required this.distance,
    required this.type,
    required this.available,
  });
}

class _StationCard extends StatelessWidget {
  final _Station station;
  final bool isElectric;
  final Color surfaceColor;
  final Color surfaceVariant;
  final Color borderColor;
  final Color textColor;
  final Color subtextColor;

  const _StationCard({
    required this.station,
    required this.isElectric,
    required this.surfaceColor,
    required this.surfaceVariant,
    required this.borderColor,
    required this.textColor,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isElectric
                      ? AppColors.driverModeGlow.withValues(alpha: 0.1)
                      : const Color(0xFFFF9500).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isElectric
                      ? Icons.ev_station_rounded
                      : Icons.local_gas_station_rounded,
                  color: isElectric
                      ? (isElectric ? AppColors.primary : AppColors.driverModeGlow)
                      : const Color(0xFFFF9500),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: AppTextStyles.titleMedium(color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      station.address,
                      style: AppTextStyles.bodySmall(
                        color: subtextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Distance
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      station.distance,
                      style: AppTextStyles.labelSmall(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  station.type,
                  style: AppTextStyles.labelSmall(
                    color: subtextColor,
                  ),
                ),
              ),
              if (station.available >= 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${station.available} trụ trống',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              // Navigate button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.navigation_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Đi',
                        style: AppTextStyles.labelSmall(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
