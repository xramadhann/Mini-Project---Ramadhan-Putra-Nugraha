// shared_data.dart
class ImageData {
  final String imagePath;
  final String title;
  final String description;
  final String content;

  ImageData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.content,
  });
}

final List<ImageData> imagesData = [
  ImageData(
    imagePath: 'assets/images/banner3.jpeg',
    title: 'Gratis 1 liter',
    description: '10 Poin',
    content:
        "Selamat datang di acara istimewa kami! Bergabunglah dalam perayaan promo yang mengagumkan: isi 4 liter Bensin Pertamax Seriers dan Anda akan diberikan 1 Liter Bensin Gratis. Nikmati penawaran eksklusif ini dengan menukarkan poin Anda di event kami. Jangan lewatkan kesempatan untuk mengisi bahan bakar mobil Anda sambil menghemat lebih banyak!",
  ),
  ImageData(
    imagePath: 'assets/images/banner4.jpeg',
    title: 'Gratis isi oli',
    description: '10 Poin',
    content:
        "Selamat datang di acara istimewa kami! Bergabunglah dalam perayaan promo yang mengagumkan: isi 4 liter Bensin Pertamax Seriers dan Anda akan diberikan 1 Liter Bensin Gratis. Nikmati penawaran eksklusif ini dengan menukarkan poin Anda di event kami. Jangan lewatkan kesempatan untuk mengisi bahan bakar mobil Anda sambil menghemat lebih banyak!",
  ),
];
