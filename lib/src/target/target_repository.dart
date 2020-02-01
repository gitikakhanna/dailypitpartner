import 'package:dailypitpartner/src/target/target_provider.dart';

class TargetRepository implements ITargetProvider {
  final ITargetProvider targetProvider;

  TargetRepository(this.targetProvider);

  @override
  Future getPartnerTarget() async {
    return await targetProvider.getPartnerTarget();
  }

  @override
  Future updatePartnerTarget(String value) async {
    return await targetProvider.updatePartnerTarget(value);
  }
}
