class MoodIconModel {
  int? moodId;
  String? moodName;
  String? moodIcon;

  MoodIconModel({this.moodId, this.moodName, this.moodIcon});

  MoodIconModel.fromJson(Map<String, dynamic> json) {
    moodId = json['mood_id'];
    moodName = json['mood_name'];
    moodIcon = json['mood_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mood_id'] = this.moodId;
    data['mood_name'] = this.moodName;
    data['mood_icon'] = this.moodIcon;
    return data;
  }
}
