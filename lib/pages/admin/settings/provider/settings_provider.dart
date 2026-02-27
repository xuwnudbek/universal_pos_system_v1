import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/repositories/store_settings/store_settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final StoreSettingsRepository _repository;

  SettingsProvider(this._repository) {
    _init();
  }

  StoreSetting? _settings;
  StoreSetting? get settings => _settings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  final storeNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  List<Printer> _availablePrinters = [];
  List<Printer> get availablePrinters => _availablePrinters;

  String _selectedBarcodePrinter = '';
  String get selectedBarcodePrinter => _selectedBarcodePrinter;

  String _selectedReceiptPrinter = '';
  String get selectedReceiptPrinter => _selectedReceiptPrinter;

  bool _autoPrint = false;
  bool get autoPrint => _autoPrint;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load available printers
      _availablePrinters = await Printing.listPrinters();

      _settings = await _repository.getSettings();
      if (_settings != null) {
        storeNameController.text = _settings!.storeName;
        phoneController.text = _settings!.phone;
        addressController.text = _settings!.address;
        _selectedBarcodePrinter = _settings!.barcodePrinter;
        _selectedReceiptPrinter = _settings!.receiptPrinter;
        _autoPrint = _settings!.autoPrint;
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setBarcodePrinter(String printerName) {
    _selectedBarcodePrinter = printerName;
    notifyListeners();
  }

  void setReceiptPrinter(String printerName) {
    _selectedReceiptPrinter = printerName;
    notifyListeners();
  }

  void toggleAutoPrint(bool value) {
    _autoPrint = value;
    notifyListeners();
  }

  Future<void> refreshPrinters() async {
    _availablePrinters = await Printing.listPrinters();
    notifyListeners();
  }

  Future<bool> saveSettings() async {
    _isSaving = true;
    notifyListeners();

    try {
      await _repository.saveSettings(
        storeName: storeNameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        barcodePrinter: _selectedBarcodePrinter,
        receiptPrinter: _selectedReceiptPrinter,
        autoPrint: _autoPrint,
      );
      _settings = await _repository.getSettings();
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving settings: $e');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    storeNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
