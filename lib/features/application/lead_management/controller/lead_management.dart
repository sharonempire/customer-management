import 'package:flutter_riverpod/flutter_riverpod.dart';

final infoCollectionProgression = StateProvider((ref) => 0);
final leadMangementcontroller = StateNotifierProvider<LeadController, bool>((
  ref,
) {
  return LeadController(ref);
});

class LeadController extends StateNotifier<bool> {
  final Ref ref;

  LeadController(this.ref) : super(true);

  void increaseProgression() {
    ref.read(infoCollectionProgression.notifier).update((state) => state + 1);
  }

  void decreaseProgression() {
    ref.read(infoCollectionProgression.notifier).update((state) => state - 1);
  }
}
