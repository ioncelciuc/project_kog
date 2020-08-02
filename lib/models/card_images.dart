class CardImages {
  String _imageUrl;
  String _imageUrlSmall;

  CardImages.initialize(this._imageUrl, this._imageUrlSmall);

  CardImages();

  get imageUrl => _imageUrl;

  get imageUrlSmall => _imageUrlSmall;

  set imageUrl(String imageUrl) {
    this._imageUrl = imageUrl;
  }

  set imageUrlSmall(String imageUrlSmall) {
    this._imageUrlSmall = imageUrlSmall;
  }
}
