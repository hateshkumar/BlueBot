
import '../../core/util/future_extention.dart';
import 'home_repositry.dart';

final homeRepo = HomeRepository();

class RepositoryBarrel {
  static final RepositoryBarrel _instance = RepositoryBarrel._internal();

  RepositoryBarrel._internal();

  factory RepositoryBarrel() => _instance;

  /// You can only register adapters once, so keep track
  bool reposInitialized = false;

  static Future<void> resetAll() async {
    print("Resetting all repositories");
    try {
      //authRepo.reset();
      // All the async resets should go in here
      await FutureExt.allSettled(
        [
          homeRepo.reset(),
        ],
        onError: (error, stackTrace) => print(
            "Something failed while resetting a particular repository $stackTrace,$error"),
      );
      RepositoryBarrel().reposInitialized = false;
      print("Successfully resetted all repositories");
    } catch (e) {
      print("Error resetting all repositories $e");
    }
  }

  Future<void> initializeAll() async {
    if (reposInitialized) {
      print("Repos already initialized -- aborting");
      return;
    }
    await Future.wait([
      homeRepo.initialize(),
    ]);
    reposInitialized = true;
  }
}
