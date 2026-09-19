import 'package:flutter/material.dart';

import '../../domain/entities/surah.dart';
import '../widgets/surah_index_pane.dart';
import '../screens/quran_screen.dart';

class QuranListPage extends StatelessWidget {
  const QuranListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الفهرس')),
      body: SurahIndexPane(
        onSelect: (Surah surah) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => QuranScreen(initialSurah: surah),
            ),
          );
        },
      ),
    );
  }
}
