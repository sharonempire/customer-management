import 'dart:html' as html;

class VoxbayClickLauncher {
  const VoxbayClickLauncher();

  bool launch(Uri uri) {
    try {
      final img = html.ImageElement();
      img.src = uri.toString();
      img.style
        ..width = '0'
        ..height = '0'
        ..position = 'absolute'
        ..top = '-9999px'
        ..left = '-9999px';
      html.document.body?.append(img);

      void cleanup(_) {
        img.remove();
      }

      img.onError.first.then(cleanup, onError: (_) => cleanup(null));
      img.onLoad.first.then(cleanup, onError: (_) => cleanup(null));
      return true;
    } catch (_) {
      return false;
    }
  }
}
