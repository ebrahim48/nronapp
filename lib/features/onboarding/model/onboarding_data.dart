class OnboardingData {
  final String imagePath;
  final String title;
  final String subtitle;
  final int? subtitleMaxLines;
  final bool applyBlend;

  const OnboardingData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.subtitleMaxLines,
    this.applyBlend = false,
  });
}

const onboardingSlides = [
  OnboardingData(
    imagePath: 'assets/images/barcode.png',
    title: 'Scan Implants Instantly',
    subtitle:
        'Identify and record patient implants 2-second using your device camera.',
    applyBlend: true,
  ),
  OnboardingData(
    imagePath: 'assets/images/pos.png',
    title: 'Create POs in 30 Seconds',
    subtitle: 'Auto-fill forms and attach documents on the go.',
    subtitleMaxLines: 2,
  ),
  OnboardingData(
    imagePath: 'assets/images/getstarted.png',
    title: 'Your Field Office',
    subtitle:
        'Manage everything from surgery room to payment in one centralized, Professional suite.',
    subtitleMaxLines: 3,
  ),
];
