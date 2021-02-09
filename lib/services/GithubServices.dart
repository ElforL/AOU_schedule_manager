import 'package:github/github.dart';
import 'package:package_info/package_info.dart';

class GithubServices {
  final owner = 'ElforL';
  final repoName = 'AOU_schedule_manager';
  String currentVersion;
  var github = GitHub();

  GithubServices() {
    PackageInfo.fromPlatform().then((value) => currentVersion = value.version);
  }

  /// Checks if there's a newer version than [currentVersion]
  ///
  /// * returns the release if there is a newer version
  /// * returns null if there's not
  Future<Release> checkNewVersion() async {
    currentVersion ??= (await PackageInfo.fromPlatform()).version;
    var release = await github.repositories.getLatestRelease(RepositorySlug(owner, repoName));

    if (compare(currentVersion, release.tagName) == -1) {
      return release;
    }
    return null;
  }

  /// Comapres two software versions
  ///
  /// * returns 1 if v1 is newer
  /// * returns -1 if v2 is newer
  /// * returns 0 if the two versions are equal
  ///
  /// PS: Versions could start with v/V (i.g. v1.5.2). :)
  static int compare(String v1, String v2) {
    if (v1 == null || v2 == null) {
      throw ArgumentError.notNull(v1 == null ? 'v1' : 'v2');
    }

    // clean string
    v1 = v1.trim();
    v2 = v2.trim();
    if (v1[0].toLowerCase() == 'v') v1 = v1.substring(1);
    if (v2[0].toLowerCase() == 'v') v2 = v2.substring(1);

    var arr1 = [for (var x in v1.split('.')) int.parse(x)];
    var arr2 = [for (var x in v2.split('.')) int.parse(x)];

    if (arr1.length > arr2.length) {
      return -1;
    } else if (arr1.length < arr2.length) {
      return 1;
    }

    for (var i = 0; i < arr1.length; i++) {
      if (arr1[i] > arr2[i]) {
        return 1;
      } else if (arr1[i] < arr2[i]) {
        return -1;
      } else {
        continue;
      }
    }

    return 0;
  } // compare
}
