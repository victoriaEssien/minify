class CodeMinifierService {
  static String minify(String code) {
    // 1. Remove single-line comments
    code = code.replaceAll(RegExp(r'//.*?\n'), '');

    // 2. Remove multi-line comments
    code = code.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');

    // 3. Remove unnecessary whitespaces
    code = code.replaceAll(
        RegExp(r'\s+'), ' '); // Replace multiple spaces with one
    code = code.replaceAll(
        RegExp(r'\s*\{\s*'), '{'); // Remove space before opening brace
    code = code.replaceAll(
        RegExp(r'\s*\}\s*'), '}'); // Remove space after closing brace
    code = code.trim(); // Remove leading/trailing spaces

    // 4. Minimize `if (x == true)` to `if (x)` for simplicity
    code =
        code.replaceAll(RegExp(r'if\s*\(\s*(\w+)\s*==\s*true\s*\)'), r'if($1)');

    // 5. Remove redundant `else` after `return` statement
    code =
        code.replaceAll(RegExp(r'return\s*[^;]+;\s*else\s*{'), r'return $1;');

    // 6. Shorten variable names (e.g., myVar -> a)
    // Improved regex to match other types of variable declarations
    code = code.replaceAllMapped(
        RegExp(
            r'\b(var|final|int|String|double|bool|const)\s+([a-zA-Z_][a-zA-Z0-9_]*)\b'),
        (match) {
      var originalName = match.group(2); // Capture the variable name
      return '${match.group(1)} ${_getShortenedName()}'; // Use shortened name
    });

    return code;
  }

  static int _shortenNameCounter = 97; // ASCII for 'a'

  // Generate shortened variable names starting from 'a'
  static String _getShortenedName() {
    String shortName = String.fromCharCode(_shortenNameCounter);
    _shortenNameCounter++;
    return shortName;
  }
}
