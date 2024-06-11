class PositionModel{
  final int id;
  final String name;
  final int type;

  PositionModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory PositionModel.fromSupabase(Map<String, dynamic> position){
    return PositionModel(
      id: position['id_posisi'],
      name: position['nama'],
      type: position['tipe'],
    );
  }

  static List<PositionModel> fromSupabaseList(List<Map<String, dynamic>> positions){
    return positions.map((position) => PositionModel.fromSupabase(position)).toList();
  }

  factory PositionModel.empty(){
    return PositionModel(
      id: 0,
      name: '',
      type: 0,
    );
  }
}