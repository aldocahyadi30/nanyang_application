class AttendanceModel {
  int id;
  DateTime? checkIn;
  DateTime? checkOut;
  int inStatus;
  int outStatus;

  AttendanceModel({
    required this.id,
    this.checkIn,
    this.checkOut,
    this.inStatus = 0,
    this.outStatus = 0,
  });

  factory AttendanceModel.empty() {
    return AttendanceModel(
      id: 0,
      checkIn: null,
      checkOut: null,
      inStatus: 0,
      outStatus: 0,
    );
  }
}
