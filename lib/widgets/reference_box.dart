import 'package:flutter/material.dart';

import '../models/aqeedah_question.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';

class ReferenceBox extends StatelessWidget {
  final AqeedahQuestion question;
  final bool answeredCorrectly;

  const ReferenceBox({
    super.key,
    required this.question,
    required this.answeredCorrectly,
  });

  @override
  Widget build(BuildContext context) {
    final accent = answeredCorrectly ? AppTheme.correct : AppTheme.softGold;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xDD081B15),
            AppTheme.emeraldDark.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: answeredCorrectly
              ? AppTheme.correct.withOpacity(0.55)
              : AppTheme.gold.withOpacity(0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.12),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: accent.withOpacity(0.35)),
                ),
                child: Icon(
                  answeredCorrectly
                      ? Icons.verified_rounded
                      : Icons.lightbulb_rounded,
                  color: accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answeredCorrectly
                          ? context.t('Correct answer')
                          : context.t('Correction and evidence'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.t(
                          'Read the proof and simple explanation before moving on.'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
              label: context.t('Correct Answer'),
              text: context.t(question.correctAnswer)),
          _EvidenceSection(text: question.reference),
          _Section(
              label: context.t('Simple explanation'),
              text: context.t(question.explanation)),
          _Section(
              label: context.t('Common mistake'),
              text: context.t(question.commonMistake)),
          _WarningSection(text: context.t(question.relatedBeliefGroup)),
        ],
      ),
    );
  }
}

enum _EvidenceKind { quran, hadith, scholar, general }

class _EvidenceItem {
  final _EvidenceKind kind;
  final String source;
  final String? narratorOrNote;
  final String quote;

  const _EvidenceItem({
    required this.kind,
    required this.source,
    required this.quote,
    this.narratorOrNote,
  });
}

class _EvidenceSection extends StatelessWidget {
  final String text;

  const _EvidenceSection({required this.text});

  @override
  Widget build(BuildContext context) {
    final items = _parseEvidence(text);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.gold.withOpacity(0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.gold.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t('Exact evidence').toUpperCase(),
            style: TextStyle(
              color: AppTheme.softGold,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.t(
                'Hadith cards separate collection, number, lookup, narrator/topic, Arabic text, and quoted translation where available.'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.mutedText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            SelectableText(
              context.referenceText(text),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.58,
                  ),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _EvidenceCard(item: item),
              ),
            ),
        ],
      ),
    );
  }

  List<_EvidenceItem> _parseEvidence(String raw) {
    final lines = raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    final items = <_EvidenceItem>[];

    var i = 0;
    while (i < lines.length) {
      final line = lines[i];
      if (line.startsWith('Qur’an ')) {
        items.add(_parseOneLine(line, _EvidenceKind.quran));
        i++;
        continue;
      }
      if (line.startsWith('Hadith source:')) {
        final source = line.replaceFirst('Hadith source:', '').trim();
        String? narrator;
        var quote = '';
        i++;
        while (i < lines.length &&
            !lines[i].startsWith('Qur’an ') &&
            !lines[i].startsWith('Hadith source:') &&
            !lines[i].startsWith('Scholar statement:') &&
            !lines[i].startsWith('Source:')) {
          if (lines[i].startsWith('Narrator/topic:')) {
            narrator = lines[i].replaceFirst('Narrator/topic:', '').trim();
          } else if (lines[i].startsWith('Quoted translation:') ||
              lines[i]
                  .startsWith('Quoted English rendering used in IslamQUIZ:')) {
            final extracted =
                lines[i].substring(lines[i].indexOf(':') + 1).trim();
            quote = quote.isEmpty ? extracted : '$quote\n$extracted';
          } else if (lines[i].startsWith('Arabic wording:')) {
            quote = quote.isEmpty ? lines[i] : '$quote\n${lines[i]}';
          } else {
            quote = quote.isEmpty ? lines[i] : '$quote\n${lines[i]}';
          }
          i++;
        }
        items.add(_EvidenceItem(
          kind: _EvidenceKind.hadith,
          source: source,
          narratorOrNote: narrator,
          quote: quote,
        ));
        continue;
      }
      if (line.startsWith('Scholar statement:') || line.startsWith('Source:')) {
        items.add(_parseStructuredSource(line, lines, i));
        i = _nextStructuredIndex(lines, i);
        continue;
      }
      items.add(_parseOneLine(line, _EvidenceKind.general));
      i++;
    }
    return items;
  }

  _EvidenceItem _parseOneLine(String line, _EvidenceKind kind) {
    final colonIndex = line.indexOf(':');
    if (colonIndex == -1) {
      return _EvidenceItem(kind: kind, source: 'Evidence', quote: line);
    }
    return _EvidenceItem(
      kind: kind,
      source: line.substring(0, colonIndex).trim(),
      quote: line.substring(colonIndex + 1).trim(),
    );
  }

  _EvidenceItem _parseStructuredSource(
      String line, List<String> lines, int startIndex) {
    final isScholar = line.startsWith('Scholar statement:');
    final source = line.substring(line.indexOf(':') + 1).trim();
    String? note;
    var quote = '';
    var i = startIndex + 1;
    while (i < lines.length &&
        !lines[i].startsWith('Qur’an ') &&
        !lines[i].startsWith('Hadith source:') &&
        !lines[i].startsWith('Scholar statement:') &&
        !lines[i].startsWith('Source:')) {
      if (lines[i].startsWith('Note:')) {
        note = lines[i].replaceFirst('Note:', '').trim();
      } else if (lines[i].startsWith('Quoted text:') ||
          lines[i].startsWith('Quoted translation:') ||
          lines[i].startsWith('Quoted English rendering used in IslamQUIZ:')) {
        final extracted = lines[i].substring(lines[i].indexOf(':') + 1).trim();
        quote = quote.isEmpty ? extracted : '$quote\n$extracted';
      } else {
        quote = quote.isEmpty ? lines[i] : '$quote\n${lines[i]}';
      }
      i++;
    }
    return _EvidenceItem(
      kind: isScholar ? _EvidenceKind.scholar : _EvidenceKind.general,
      source: source,
      narratorOrNote: note,
      quote: quote,
    );
  }

  int _nextStructuredIndex(List<String> lines, int startIndex) {
    var i = startIndex + 1;
    while (i < lines.length &&
        !lines[i].startsWith('Qur’an ') &&
        !lines[i].startsWith('Hadith source:') &&
        !lines[i].startsWith('Scholar statement:') &&
        !lines[i].startsWith('Source:')) {
      i++;
    }
    return i;
  }
}

class _EvidenceCard extends StatelessWidget {
  final _EvidenceItem item;

  const _EvidenceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final label = switch (item.kind) {
      _EvidenceKind.quran => context.t('Qur’an translation'),
      _EvidenceKind.hadith => context.t('Hadith source'),
      _EvidenceKind.scholar => context.t('Scholar statement'),
      _EvidenceKind.general => context.t('Evidence source'),
    };

    final sourceParts = _splitSource(item.source);
    final sourceMain = sourceParts.main;
    final sourceLookup = sourceParts.lookup;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.gold.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppTheme.gold.withOpacity(0.24)),
                ),
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.softGold,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.05,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _EvidenceLine(
            label: item.kind == _EvidenceKind.hadith
                ? context.t('Collection / number')
                : context.t('Verse / reference'),
            value: context.referenceText(sourceMain),
          ),
          if (sourceLookup != null && sourceLookup.isNotEmpty)
            _EvidenceLine(
                label: context.t('Sunnah.com lookup'),
                value: context.referenceText(sourceLookup)),
          if (item.narratorOrNote != null && item.narratorOrNote!.isNotEmpty)
            _EvidenceLine(
                label: context.t('Narrator / topic'),
                value: context.referenceText(item.narratorOrNote!)),
          if (item.quote.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              context.t('Quoted text / excerpt').toUpperCase(),
              style: const TextStyle(
                color: AppTheme.softGold,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              context.referenceText(item.quote),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.52,
                  ),
            ),
          ],
          if (item.kind == _EvidenceKind.hadith) ...[
            const SizedBox(height: 8),
            Text(
              context.t(
                  'Reference text is translated in Bangla mode; source names and numbers stay visible.'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mutedText,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  _EvidenceSourceParts _splitSource(String source) {
    const marker = '— Sunnah.com lookup:';
    if (source.contains(marker)) {
      final parts = source.split(marker);
      return _EvidenceSourceParts(
          parts.first.trim(), parts.skip(1).join(marker).trim());
    }
    const lookupMarker = '— lookup:';
    if (source.contains(lookupMarker)) {
      final parts = source.split(lookupMarker);
      return _EvidenceSourceParts(
          parts.first.trim(), parts.skip(1).join(lookupMarker).trim());
    }
    return _EvidenceSourceParts(source.trim(), null);
  }
}

class _EvidenceSourceParts {
  final String main;
  final String? lookup;

  const _EvidenceSourceParts(this.main, this.lookup);
}

class _EvidenceLine extends StatelessWidget {
  final String label;
  final String value;

  const _EvidenceLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 2),
          SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.softGold,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _WarningSection extends StatelessWidget {
  final String text;

  const _WarningSection({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.wrong.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.wrong.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t('Wrong belief / related groups').toUpperCase(),
            style: TextStyle(
              color: AppTheme.softGold,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.t(
                'This is NOT the correct answer. It lists the wrong belief or related group connected to the wrong choices.'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String label;
  final String text;

  const _Section({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.softGold,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
