/// أحاديث الكنز النبوي المخزّنة أوفلاين للمكافأة بعد إتمام الورد.
class PropheticRewardModel {
  PropheticRewardModel._();

  static final List<Map<String, String>> rewards = [
    {
      'title': 'هنيئاً لك يا أهل الله',
      'hadith':
          'قال رسول الله صلى الله عليه وسلم: (إن لله أهلين من الناس). قالوا: يا رسول الله، من هم؟ قال: (هم أهل القرآن، أهل الله وخاصته).',
      'reference': 'رواه النسائي وابن ماجه',
    },
    {
      'title': 'اقرأ وارتقِ',
      'hadith':
          'قال رسول الله صلى الله عليه وسلم: (يقال لصاحب القرآن: اقرأ وارتل كما كنت ترتل في الدنيا، فإن منزلك عند آخر آية تقرؤها).',
      'reference': 'رواه أبو داود والترمذي',
    },
    {
      'title': 'التجارة الرابحة',
      'hadith':
          'قال رسول الله صلى الله عليه وسلم: (من قرأ حرفاً من كتاب الله فله به حسنة، والحسنة بعشر أمثالها).',
      'reference': 'رواه الترمذي',
    },
  ];

  static Map<String, String> getRandomReward() {
    final copy = List<Map<String, String>>.from(rewards)..shuffle();
    return copy.first;
  }
}
