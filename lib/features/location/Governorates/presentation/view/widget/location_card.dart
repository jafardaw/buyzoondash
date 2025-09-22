import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onAddPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onTap;

  const LocationCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onAddPressed,
    this.onEditPressed,
    this.onDeletePressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // أيقونة مميزة في البداية
                  Icon(
                    Icons.location_on_outlined,
                    color: theme.colorScheme.primary.withOpacity(0.8),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // الأزرار بتصميم مختلف ومدمج أكثر
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // وضع الأزرار لليمين
                children: [
                  if (onAddPressed != null)
                    _buildTextButton(
                      label: 'إضافة',
                      color: Colors.green.shade600,
                      onPressed: onAddPressed!,
                    ),
                  if (onEditPressed != null)
                    _buildTextButton(
                      label: 'تعديل',
                      color: Colors.blue.shade600,
                      onPressed: onEditPressed!,
                    ),
                  if (onDeletePressed != null)
                    _buildTextButton(
                      label: 'حذف',
                      color: Colors.red.shade600,
                      onPressed: onDeletePressed!,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // استخدام TextButton بدلاً من IconButton لتقليل الحدود وجعله أكثر اندماجًا
  Widget _buildTextButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: color, // لون النص
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: color.withOpacity(0.3),
              width: 0.8,
            ), // حدود خفيفة
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
