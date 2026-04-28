import 'package:voucher_app/features/voucher/data/models/voucher_model.dart';

abstract class VoucherRepository {
  Future<VoucherModel> fetchVoucher();
}
