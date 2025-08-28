class ProfileQuestionModel {
  bool? allAnswered;
  int? currentStep;
  int? totalSteps;
  QuestionModel? question;

  ProfileQuestionModel({this.allAnswered, this.currentStep, this.totalSteps, this.question});

  ProfileQuestionModel.fromJson(Map<String, dynamic> json) {
    allAnswered = json['all_answered'];
    currentStep = json['current_step'];
    totalSteps = json['total_steps'];
    question = json['question'] != null
        ? new QuestionModel.fromJson(json['question'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all_answered'] = this.allAnswered;
    data['current_step'] = this.currentStep;
    data['total_steps'] = this.totalSteps;
    if (this.question != null) {
      data['question'] = this.question!.toJson();
    }
    return data;
  }
}

class QuestionModel {
  int? queId;
  String? question;
  List<OptionsModel>? options;

  QuestionModel({this.queId, this.question, this.options});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    queId = json['que_id'];
    question = json['question'];
    if (json['options'] != null) {
      options = <OptionsModel>[];
      json['options'].forEach((v) {
        options!.add(new OptionsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['que_id'] = this.queId;
    data['question'] = this.question;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionsModel {
  int? optionId;
  String? optionText;

  OptionsModel({this.optionId, this.optionText});

  OptionsModel.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'];
    optionText = json['option_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_id'] = this.optionId;
    data['option_text'] = this.optionText;
    return data;
  }
}
