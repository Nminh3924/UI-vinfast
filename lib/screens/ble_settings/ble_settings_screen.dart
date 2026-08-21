import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

class BleSettingsScreen extends StatefulWidget {
  const BleSettingsScreen({super.key});

  @override
  State<BleSettingsScreen> createState() => _BleSettingsScreenState();
}

class _BleSettingsScreenState extends State<BleSettingsScreen> {
  bool _bleEnabled = true;
  bool _isScanning = false;

  final List<_BleDevice> _pairedDevices = [
    _BleDevice(name: 'HFM-ESP32-001', mac: 'AA:BB:CC:DD:EE:01', isOnline: true),
    _BleDevice(name: 'HFM-ESP32-002', mac: 'AA:BB:CC:DD:EE:02', isOnline: false),
  ];

  @override
  Widget build(BuildContext context) {
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
          'Thiết bị BLE',
          style: AppTextStyles.titleLarge(color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── BLE Toggle ───
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _bleEnabled
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.bluetooth_rounded,
                      color: _bleEnabled
                          ? AppColors.primary
                          : subtextColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bluetooth Low Energy',
                          style: AppTextStyles.titleMedium(
                            color: textColor,
                          ),
                        ),
                        Text(
                          _bleEnabled ? 'Đang bật' : 'Đã tắt',
                          style: AppTextStyles.bodySmall(
                            color: _bleEnabled
                                ? AppColors.success
                                : subtextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _bleEnabled,
                    onChanged: (v) => setState(() => _bleEnabled = v),
                    activeThumbColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Paired devices ───
            Row(
              children: [
                Text(
                  'Thiết bị đã ghép đôi',
                  style: AppTextStyles.titleMedium(color: textColor),
                ),
                const Spacer(),
                Text(
                  '${_pairedDevices.length} thiết bị',
                  style: AppTextStyles.bodySmall(
                    color: subtextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ..._pairedDevices.map((device) => _DeviceCard(
                  device: device,
                  surfaceColor: surfaceColor,
                  surfaceVariant: surfaceVariant,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                )),

            const SizedBox(height: 24),

            // ─── Scan button ───
            Container(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary),
              ),
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() => _isScanning = !_isScanning);
                },
                icon: _isScanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : const Icon(Icons.search_rounded),
                label: Text(
                  _isScanning ? 'Đang quét...' : 'Quét thiết bị mới',
                  style: AppTextStyles.labelLarge(color: AppColors.primary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ─── Button map ───
            Text(
              'Sơ đồ nút điều khiển',
              style: AppTextStyles.titleMedium(color: textColor),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _ButtonMapRow(
                    number: '1',
                    icon: Icons.person_search_rounded,
                    label: 'Hỏi người gửi',
                    description: 'Đọc tên người gửi tin nhắn mới nhất',
                    color: AppColors.primary,
                    textColor: textColor,
                    subtextColor: subtextColor,
                  ),
                  const SizedBox(height: 12),
                  _ButtonMapRow(
                    number: '2',
                    icon: Icons.directions_car_rounded,
                    label: 'Bật/tắt Driver',
                    description: 'Bật tắt chế độ lái xe',
                    color: AppColors.driverModeGlow,
                    textColor: textColor,
                    subtextColor: subtextColor,
                  ),
                  const SizedBox(height: 12),
                  _ButtonMapRow(
                    number: '3',
                    icon: Icons.local_gas_station_rounded,
                    label: 'Tìm trạm',
                    description: 'Tìm trạm sạc/xăng gần nhất',
                    color: AppColors.success,
                    textColor: textColor,
                    subtextColor: subtextColor,
                  ),
                  const SizedBox(height: 12),
                  _ButtonMapRow(
                    number: '4',
                    icon: Icons.sos_rounded,
                    label: 'SOS khẩn cấp',
                    description: 'Gửi SMS kèm vị trí GPS',
                    color: AppColors.error,
                    textColor: textColor,
                    subtextColor: subtextColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _BleDevice {
  final String name;
  final String mac;
  final bool isOnline;
  _BleDevice({required this.name, required this.mac, required this.isOnline});
}

class _DeviceCard extends StatelessWidget {
  final _BleDevice device;
  final Color surfaceColor;
  final Color surfaceVariant;
  final Color borderColor;
  final Color textColor;
  final Color subtextColor;

  const _DeviceCard({
    required this.device,
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
        border: Border.all(
          color: device.isOnline
              ? AppColors.success.withValues(alpha: 0.3)
              : borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: device.isOnline
                  ? AppColors.success.withValues(alpha: 0.1)
                  : surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.bluetooth_connected_rounded,
              color: device.isOnline
                  ? AppColors.success
                  : subtextColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: AppTextStyles.titleMedium(color: textColor),
                ),
                Text(
                  device.mac,
                  style: AppTextStyles.bodySmall(
                    color: subtextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: device.isOnline
                  ? AppColors.success.withValues(alpha: 0.1)
                  : surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: device.isOnline
                        ? AppColors.success
                        : subtextColor,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  device.isOnline ? 'Online' : 'Offline',
                  style: AppTextStyles.labelSmall(
                    color: device.isOnline
                        ? AppColors.success
                        : subtextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonMapRow extends StatelessWidget {
  final String number;
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final Color textColor;
  final Color subtextColor;

  const _ButtonMapRow({
    required this.number,
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.textColor,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.labelLarge(color: color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelMedium(color: textColor),
              ),
              Text(
                description,
                style: AppTextStyles.bodySmall(
                  color: subtextColor,
                ).copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
