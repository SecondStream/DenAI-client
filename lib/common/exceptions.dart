class LLMProviderException implements Exception {
  final String message;
  const LLMProviderException([this.message = ""]);

  @override
  String toString() {
    var report = "LLMProviderException";
    if (message.isNotEmpty) report += ": $message";
    return report;
  }
}