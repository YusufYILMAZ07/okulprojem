import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/web_scraper.dart';
import '../models/academic_staff.dart';

/// Service that scrapes Altınbaş University's website
/// to fetch the academic staff listing.
class AcademicStaffService {
  AcademicStaffService._();

  /// Scrape the academic staff page and return a list of [AcademicStaff].
  ///
  /// Falls back to an empty list with error info on failure.
  /// Handles:
  ///  - Network errors (timeout, DNS, etc.)
  ///  - HTML structure changes (missing selectors)
  ///  - Malformed data (null fields)
  static Future<({List<AcademicStaff> staff, String? error})>
      fetchStaff() async {
    try {
      final htmlBody = await WebScraper.fetchHtml(AppStrings.academicStaffUrl);
      final document = html_parser.parse(htmlBody);

      final staffList = <AcademicStaff>[];

      // ── Strategy 1: Try structured card/list selectors ────────
      // Altınbaş typically renders staff in card components.
      final cards = document.querySelectorAll(
        '.academic-staff-card, .staff-item, .team-member, '
        '.card-body, .people-item, [class*="kadro"], [class*="staff"]',
      );

      if (cards.isNotEmpty) {
        for (final card in cards) {
          final staff = _parseCard(card);
          if (staff != null) staffList.add(staff);
        }
      }

      // ── Strategy 2: Fallback to table rows ────────────────────
      if (staffList.isEmpty) {
        final rows = document.querySelectorAll('table tbody tr, table tr');
        for (final row in rows) {
          final staff = _parseTableRow(row);
          if (staff != null) staffList.add(staff);
        }
      }

      // ── Strategy 3: Fallback to any repeated list structure ───
      if (staffList.isEmpty) {
        final items = document.querySelectorAll(
          'ul li, .list-group-item, .row > div',
        );
        for (final item in items) {
          final staff = _parseGenericItem(item);
          if (staff != null) staffList.add(staff);
        }
      }

      if (staffList.isEmpty) {
        return (
          staff: <AcademicStaff>[],
          error: 'HTML yapısı tanınamadı. Site güncellenmiş olabilir.',
        );
      }

      return (staff: staffList, error: null);
    } on WebScraperException catch (e) {
      return (staff: <AcademicStaff>[], error: e.message);
    } catch (e) {
      return (
        staff: <AcademicStaff>[],
        error: 'Beklenmeyen hata: $e',
      );
    }
  }

  // ── Parse helpers ─────────────────────────────────────────────────

  static AcademicStaff? _parseCard(Element card) {
    try {
      final nameEl = card.querySelector(
        'h3, h4, h5, .name, .title, [class*="name"], [class*="title"]',
      );
      final name = nameEl?.text.trim() ?? '';
      if (name.isEmpty || name.length < 3) return null;

      final emailEl = card.querySelector('a[href^="mailto:"]');
      final email =
          emailEl?.attributes['href']?.replaceFirst('mailto:', '').trim() ?? '';

      final allText = card.text;
      final office = _extractOffice(allText);
      final title = _extractTitle(name);
      final cleanName = _removeTitleFromName(name, title);

      final imgEl = card.querySelector('img');
      final imageUrl = imgEl?.attributes['src'];

      return AcademicStaff(
        name: cleanName,
        title: title,
        email: email,
        office: office,
        imageUrl: imageUrl,
      );
    } catch (_) {
      return null;
    }
  }

  static AcademicStaff? _parseTableRow(Element row) {
    try {
      final cells = row.querySelectorAll('td');
      if (cells.length < 2) return null;

      final rawName = cells[0].text.trim();
      if (rawName.isEmpty || rawName.length < 3) return null;

      final title = _extractTitle(rawName);
      final cleanName = _removeTitleFromName(rawName, title);
      final office = cells.length > 2 ? cells[2].text.trim() : '';
      final emailEl = row.querySelector('a[href^="mailto:"]');
      final email =
          emailEl?.attributes['href']?.replaceFirst('mailto:', '').trim() ??
              (cells.length > 1 ? cells[1].text.trim() : '');

      return AcademicStaff(
        name: cleanName,
        title: title,
        email: email,
        office: office,
      );
    } catch (_) {
      return null;
    }
  }

  static AcademicStaff? _parseGenericItem(Element item) {
    try {
      final text = item.text.trim();
      if (text.length < 5) return null;

      // Must contain at least an email-like pattern to be a staff entry.
      final emailMatch = RegExp(r'[\w.]+@[\w.]+\.\w+').firstMatch(text);
      if (emailMatch == null) return null;

      final email = emailMatch.group(0) ?? '';
      final title = _extractTitle(text);
      final nameEnd = emailMatch.start;
      final rawName = text.substring(0, nameEnd).trim();
      final cleanName = _removeTitleFromName(rawName, title);

      return AcademicStaff(
        name: cleanName.isNotEmpty ? cleanName : text.substring(0, 30),
        title: title,
        email: email,
        office: _extractOffice(text),
      );
    } catch (_) {
      return null;
    }
  }

  /// Extract academic title from name string.
  static String _extractTitle(String text) {
    final patterns = [
      'Prof. Dr.',
      'Doç. Dr.',
      'Dr. Öğr. Üyesi',
      'Öğr. Gör. Dr.',
      'Öğr. Gör.',
      'Arş. Gör. Dr.',
      'Arş. Gör.',
      'Dr.',
    ];
    for (final p in patterns) {
      if (text.contains(p)) return p;
    }
    return '';
  }

  /// Remove the title prefix from a name string.
  static String _removeTitleFromName(String name, String title) {
    if (title.isEmpty) return name.trim();
    return name.replaceFirst(title, '').trim();
  }

  /// Try to extract office/room info from text.
  static String _extractOffice(String text) {
    final match = RegExp(
      r'(D\s*Blok[^,\n]*|Oda\s*:?\s*\S+|Ofis\s*:?\s*\S+|Kat\s*:?\s*\d+)',
      caseSensitive: false,
    ).firstMatch(text);
    return match?.group(0)?.trim() ?? '';
  }
}
