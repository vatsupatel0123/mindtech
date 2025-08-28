class MoodModel {
  int? moodId;
  String? moodNote;
  String? moodName;
  String? moodIcon;
  String? moodDesc;
  String? moodButtonText;
  String? moodButtonColor;
  String? addedDatetime;

  MoodModel(
      {this.moodId,
        this.moodNote,
        this.moodName,
        this.moodIcon,
        this.moodDesc,
        this.moodButtonText,
        this.moodButtonColor,
        this.addedDatetime});

  MoodModel.fromJson(Map<String, dynamic> json) {
    moodId = json['mood_id'];
    moodNote = json['mood_note'];
    moodName = json['mood_name'];
    moodIcon = json['mood_icon'];
    moodDesc = json['mood_desc'];
    moodButtonText = json['mood_button_text'];
    moodButtonColor = json['mood_button_color'];
    addedDatetime = json['added_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mood_id'] = this.moodId;
    data['mood_note'] = this.moodNote;
    data['mood_name'] = this.moodName;
    data['mood_icon'] = this.moodIcon;
    data['mood_desc'] = this.moodDesc;
    data['mood_button_text'] = this.moodButtonText;
    data['mood_button_color'] = this.moodButtonColor;
    data['added_datetime'] = this.addedDatetime;
    return data;
  }
}
