class SkillModel {
  int? expertId;
  int? skillId;
  String? skillName;

  SkillModel({this.expertId, this.skillId, this.skillName});

  SkillModel.fromJson(Map<String, dynamic> json) {
    expertId = json['expert_id'];
    skillId = json['skill_id'];
    skillName = json['skill_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expert_id'] = this.expertId;
    data['skill_id'] = this.skillId;
    data['skill_name'] = this.skillName;
    return data;
  }
}
