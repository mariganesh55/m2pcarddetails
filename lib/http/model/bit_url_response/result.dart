class Result {
  String? publicKey;
  String? url;

  Result({this.publicKey, this.url});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        publicKey: json['publicKey'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'publicKey': publicKey,
        'url': url,
      };
}
