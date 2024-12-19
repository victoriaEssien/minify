class CodeMinifierService {
  static String minify(String code) {
    // Simple minification: Remove whitespace and comments
    return code
        .replaceAll(RegExp(r'//.*?\n'), '') // Remove single-line comments
        .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '') // Remove multi-line comments
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with one
        .trim();
  }
}
