import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Lightweight HTTP wrapper with timeout, retry, and error translation.
class WebScraper {
  WebScraper._();

  static const Duration _timeout = Duration(seconds: 15);
  static const int _maxRetries = 2;

  /// Fetches the HTML body of [url].
  /// Throws [WebScraperException] on failure.
  static Future<String> fetchHtml(String url) async {
    http.Response? response;
    Exception? lastError;

    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        response = await http.get(
          Uri.parse(url),
          headers: {
            'User-Agent': 'AltinbasKampusApp/1.0',
            'Accept': 'text/html,application/xhtml+xml',
            'Accept-Language': 'tr-TR,tr;q=0.9,en;q=0.5',
          },
        ).timeout(_timeout);

        if (response.statusCode == 200) {
          return response.body;
        }

        lastError = WebScraperException(
          'HTTP ${response.statusCode}',
          url: url,
          statusCode: response.statusCode,
        );
      } on TimeoutException {
        lastError = WebScraperException(
          'İstek zaman aşımına uğradı (timeout).',
          url: url,
        );
      } on SocketException catch (e) {
        lastError = WebScraperException(
          'Ağ bağlantısı kurulamadı: ${e.message}',
          url: url,
        );
      } on http.ClientException catch (e) {
        lastError = WebScraperException(
          'HTTP istemci hatası: ${e.message}',
          url: url,
        );
      } catch (e) {
        lastError = WebScraperException(
          'Beklenmeyen hata: $e',
          url: url,
        );
      }

      // Wait before retrying.
      if (attempt < _maxRetries) {
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }

    throw lastError ?? WebScraperException('Bilinmeyen hata.', url: url);
  }
}

/// Custom exception for web‑scraping errors.
class WebScraperException implements Exception {
  final String message;
  final String? url;
  final int? statusCode;

  WebScraperException(this.message, {this.url, this.statusCode});

  @override
  String toString() =>
      'WebScraperException: $message${url != null ? ' (url: $url)' : ''}';
}
