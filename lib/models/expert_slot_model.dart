class ExpertSlotModel {
  String? slotDate;
  bool? isBooked;
  List<SlotsModel>? slots;

  ExpertSlotModel({this.slotDate, this.isBooked, this.slots});

  ExpertSlotModel.fromJson(Map<String, dynamic> json) {
    slotDate = json['slot_date'];
    isBooked = json['is_booked'];
    if (json['slots'] != null) {
      slots = <SlotsModel>[];
      json['slots'].forEach((v) {
        slots!.add(new SlotsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_date'] = this.slotDate;
    data['is_booked'] = this.isBooked;
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotsModel {
  int? slotId;
  String? slotTime;
  bool? isBooked;

  SlotsModel({this.slotId, this.slotTime, this.isBooked});

  SlotsModel.fromJson(Map<String, dynamic> json) {
    slotId = json['slot_id'];
    slotTime = json['slot_time'];
    isBooked = json['is_booked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_id'] = this.slotId;
    data['slot_time'] = this.slotTime;
    data['is_booked'] = this.isBooked;
    return data;
  }
}
