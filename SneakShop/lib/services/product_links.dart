class ProductLink {
  final String sneakerId;
  const ProductLink._(this.sneakerId);
  static String forSneaker(String id) => 'narxoz://store/product/$id';

  static ProductLink? fromSearch(String input) {
    final uri = Uri.tryParse(input.trim());
    if (uri == null) return null;
    if ((uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty &&
        !uri.hasQuery) {
      final route =
          uri.hasFragment ? Uri.tryParse(uri.fragment) : Uri(path: uri.path);
      return route == null ? null : parse(route);
    }
    return parse(uri);
  }

  static ProductLink? parse(Uri uri) {
    String? id;
    if (uri.scheme == 'narxoz' &&
        uri.host == 'store' &&
        uri.pathSegments.length == 2 &&
        uri.pathSegments.first == 'product') {
      id = uri.pathSegments.last;
    } else if (uri.scheme == 'sneakshop' &&
        uri.host == 'product' &&
        uri.pathSegments.length == 1) {
      id = uri.pathSegments.first;
    } else if (uri.scheme.isEmpty &&
        uri.pathSegments.length == 2 &&
        uri.pathSegments.first == 'product') {
      id = uri.pathSegments.last;
    }
    if (id == null ||
        !RegExp(r'^api_[1-9][0-9]{0,8}$').hasMatch(id) ||
        uri.hasQuery ||
        uri.hasFragment ||
        uri.userInfo.isNotEmpty ||
        uri.hasPort) {
      return null;
    }
    return ProductLink._(id);
  }
}
