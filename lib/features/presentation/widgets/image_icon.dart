import 'package:flutter/widgets.dart';

class ImageIconContainer extends StatelessWidget {
  final double? size;
  final String image;
  const ImageIconContainer({super.key, required this.image, this.size});

  @override
  Widget build(BuildContext context) => Container(
    height: size ?? 25,
    width: size ?? 25,
    decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image))),
  );
}
