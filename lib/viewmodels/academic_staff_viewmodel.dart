import 'package:flutter/foundation.dart';

import '../data/models/academic_staff.dart';
import '../data/repositories/academic_staff_repository.dart';

/// ViewModel for the Academic Staff (Akademik Kadro) page.
class AcademicStaffViewModel extends ChangeNotifier {
  List<AcademicStaff> _allStaff = [];
  List<AcademicStaff> _filtered = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  // ── Getters ───────────────────────────────────────────────────────
  List<AcademicStaff> get staff => _filtered;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get hasData => _allStaff.isNotEmpty;

  // ── Load data ─────────────────────────────────────────────────────
  Future<void> loadStaff({bool forceLocal = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AcademicStaffRepository.load(forceLocal: forceLocal);
      _allStaff = result.staff;
      _errorMessage = result.error;
      _applyFilter();
    } catch (e) {
      _errorMessage = 'Veri yüklenemedi: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── Search/Filter ─────────────────────────────────────────────────
  void search(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = List.from(_allStaff);
      return;
    }
    final q = _searchQuery.toLowerCase().trim();
    _filtered = _allStaff.where((s) {
      return s.name.toLowerCase().contains(q) ||
          s.title.toLowerCase().contains(q) ||
          s.email.toLowerCase().contains(q) ||
          s.office.toLowerCase().contains(q) ||
          (s.department?.toLowerCase().contains(q) ?? false);
    }).toList();
  }
}
