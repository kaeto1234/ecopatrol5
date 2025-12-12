import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import '../helpers/db_helper.dart';

final reportListProvider =
    StateNotifierProvider<ReportListNotifier, AsyncValue<List<ReportModel>>>((
      ref,
    ) {
      return ReportListNotifier();
    });

class ReportListNotifier extends StateNotifier<AsyncValue<List<ReportModel>>> {
  ReportListNotifier() : super(const AsyncValue.loading()) {
    load();
  }

  final DBHelper _db = DBHelper();

  Future<void> load() async {
    try {
      final list = await _db.getAllReports();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addReport(ReportModel r) async {
    await _db.insertReport(r);
    await load();
  }

  Future<void> updateReport(ReportModel r) async {
    await _db.updateReport(r);
    await load();
  }

  Future<void> deleteReport(int id) async {
    await _db.deleteReport(id);
    await load();
  }
}
