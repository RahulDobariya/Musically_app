class Songs {
  String? songName;
  String? authorName;
  String? songUrl;
  String? albumImage;

  Songs({this.songName, this.authorName, this.songUrl, this.albumImage});

  Songs.fromJson(Map<String, dynamic> json) {
    songName = json['songName'];
    authorName = json['authorName'];
    songUrl = json['songUrl'];
    albumImage = json['albumImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['songName'] = this.songName;
    data['authorName'] = this.authorName;
    data['songUrl'] = this.songUrl;
    data['albumImage'] = this.albumImage;
    return data;
  }
}
