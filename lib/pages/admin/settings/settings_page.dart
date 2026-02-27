import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/repositories/store_settings/store_settings_repository.dart';
import 'package:universal_pos_system_v1/pages/admin/settings/provider/settings_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/functions/show_snackbar.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(
        context.read<StoreSettingsRepository>(),
      ),
      builder: (context, _) {
        return Consumer<SettingsProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // Header
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerTheme.color ?? Colors.grey,
                        width: AppBorderWidth.thin,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Sozlamalar',
                        style: textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: provider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Store Info Card
                              Container(
                                constraints: BoxConstraints(maxWidth: 800),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.dividerTheme.color ?? Colors.grey,
                                    width: AppBorderWidth.thin,
                                  ),
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Card Header
                                    Container(
                                      padding: EdgeInsets.all(AppSpacing.lg),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(AppRadius.md),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(AppSpacing.sm),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary.withAlpha(30),
                                              borderRadius: BorderRadius.circular(AppRadius.sm),
                                            ),
                                            child: Icon(
                                              LucideIcons.store,
                                              color: theme.colorScheme.primary,
                                              size: 24,
                                            ),
                                          ),
                                          SizedBox(width: AppSpacing.md),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Do\'kon ma\'lumotlari',
                                                style: textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: AppSpacing.xs),
                                              Text(
                                                'Do\'kon nomi, telefon va manzilini kiriting',
                                                style: textTheme.bodySmall?.copyWith(
                                                  color: theme.colorScheme.onSurface.withAlpha(150),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(height: 1),

                                    // Form Fields
                                    Padding(
                                      padding: EdgeInsets.all(AppSpacing.lg),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Store Name & Phone in one row
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Store Name
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Do\'kon nomi',
                                                      style: textTheme.bodyMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(height: AppSpacing.sm),
                                                    TextField(
                                                      controller: provider.storeNameController,
                                                      decoration: InputDecoration(
                                                        hintText: 'Do\'kon nomini kiriting',
                                                        prefixIcon: Icon(LucideIcons.store, size: 20),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(AppRadius.sm),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: AppSpacing.md),
                                              // Phone
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Telefon raqami',
                                                      style: textTheme.bodyMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(height: AppSpacing.sm),
                                                    TextField(
                                                      controller: provider.phoneController,
                                                      decoration: InputDecoration(
                                                        hintText: 'Telefon raqamini kiriting',
                                                        prefixIcon: Icon(LucideIcons.phone, size: 20),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(AppRadius.sm),
                                                        ),
                                                      ),
                                                      keyboardType: TextInputType.phone,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: AppSpacing.lg),

                                          // Address
                                          Text(
                                            'Manzil',
                                            style: textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: AppSpacing.sm),
                                          TextField(
                                            controller: provider.addressController,
                                            decoration: InputDecoration(
                                              hintText: 'Manzilni kiriting',
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.only(bottom: 24),
                                                child: Icon(LucideIcons.mapPin, size: 20),
                                              ),
                                              prefixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 48),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                              ),
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg),

                              // Printer Settings Card
                              Container(
                                constraints: BoxConstraints(maxWidth: 800),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.dividerTheme.color ?? Colors.grey,
                                    width: AppBorderWidth.thin,
                                  ),
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Card Header
                                    Container(
                                      padding: EdgeInsets.all(AppSpacing.lg),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(AppRadius.md),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(AppSpacing.sm),
                                            decoration: BoxDecoration(
                                              color: Colors.purple.withAlpha(30),
                                              borderRadius: BorderRadius.circular(AppRadius.sm),
                                            ),
                                            child: Icon(
                                              LucideIcons.printer,
                                              color: Colors.purple,
                                              size: 24,
                                            ),
                                          ),
                                          SizedBox(width: AppSpacing.md),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Printer sozlamalari',
                                                  style: textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(height: AppSpacing.xs),
                                                Text(
                                                  'Barcode va chek printerlarini tanlang',
                                                  style: textTheme.bodySmall?.copyWith(
                                                    color: theme.colorScheme.onSurface.withAlpha(150),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => provider.refreshPrinters(),
                                            icon: Icon(LucideIcons.refreshCw, size: 18),
                                            tooltip: 'Printerlarni yangilash',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(height: 1),

                                    // Printer Fields
                                    Padding(
                                      padding: EdgeInsets.all(AppSpacing.lg),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Barcode & Receipt Printers in one row
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Barcode Printer
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Barcode printer',
                                                      style: textTheme.bodyMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(height: AppSpacing.sm),
                                                    DropdownButtonFormField<String>(
                                                      initialValue: provider.selectedBarcodePrinter.isEmpty ? null : provider.selectedBarcodePrinter,
                                                      decoration: InputDecoration(
                                                        hintText: 'Printer tanlang',
                                                        prefixIcon: Icon(LucideIcons.barChart, size: 20),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(AppRadius.sm),
                                                        ),
                                                      ),
                                                      items: provider.availablePrinters.map((printer) {
                                                        return DropdownMenuItem<String>(
                                                          value: printer.name,
                                                          child: Text(
                                                            printer.name,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          provider.setBarcodePrinter(value);
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: AppSpacing.md),
                                              // Receipt Printer
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Chek printer',
                                                      style: textTheme.bodyMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(height: AppSpacing.sm),
                                                    DropdownButtonFormField<String>(
                                                      initialValue: provider.selectedReceiptPrinter.isEmpty ? null : provider.selectedReceiptPrinter,
                                                      decoration: InputDecoration(
                                                        hintText: 'Printer tanlang',
                                                        prefixIcon: Icon(LucideIcons.receipt, size: 20),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(AppRadius.sm),
                                                        ),
                                                      ),
                                                      items: provider.availablePrinters.map((printer) {
                                                        return DropdownMenuItem<String>(
                                                          value: printer.name,
                                                          child: Text(
                                                            printer.name,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          provider.setReceiptPrinter(value);
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: AppSpacing.lg),

                                          // Auto Print Toggle
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: AppSpacing.md,
                                              vertical: AppSpacing.sm,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: theme.dividerTheme.color ?? Colors.grey,
                                                width: AppBorderWidth.thin,
                                              ),
                                              borderRadius: BorderRadius.circular(AppRadius.sm),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  LucideIcons.zap,
                                                  size: 20,
                                                  color: provider.autoPrint ? Colors.amber : theme.colorScheme.onSurface.withAlpha(120),
                                                ),
                                                SizedBox(width: AppSpacing.md),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Avtomatik print',
                                                        style: textTheme.bodyMedium?.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Sotuv yakunlanganda avtomatik chek chiqarish',
                                                        style: textTheme.bodySmall?.copyWith(
                                                          color: theme.colorScheme.onSurface.withAlpha(150),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Switch(
                                                  value: provider.autoPrint,
                                                  onChanged: (value) => provider.toggleAutoPrint(value),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppSpacing.xl),

                              // Save Button
                              Container(
                                constraints: BoxConstraints(maxWidth: 800),
                                width: double.infinity,
                                child: Button(
                                  onPressed: provider.isSaving
                                      ? null
                                      : () async {
                                          final success = await provider.saveSettings();
                                          if (context.mounted) {
                                            showAppSnackBar(
                                              context,
                                              success ? 'Sozlamalar saqlandi' : 'Xatolik yuz berdi',
                                              type: success ? SnackBarType.success : SnackBarType.error,
                                            );
                                          }
                                        },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (!provider.isSaving) Icon(LucideIcons.save, size: 18),
                                      if (!provider.isSaving) SizedBox(width: AppSpacing.sm),
                                      Text(provider.isSaving ? 'Saqlanmoqda...' : 'Saqlash'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
