// Model laporan lingkungan
// Merepresentasikan satu baris data di tabel reports
class ReportModel {
  int? id;
  String title;
  String description;
  String imagePath; // path ke gambar yang disimpan secara lokal
  double? latitude;
  double? longitude;
  String status; // 'pending' or 'done'
  String createdAt;
  String? doneNote;
  String? doneImagePath;

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.latitude,
    this.longitude,
    this.status = 'pending',
    required this.createdAt,
    this.doneNote,
    this.doneImagePath,
  });

  // Konversi object ke Map (untuk SQLite)

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'createdAt': createdAt,
      'doneNote': doneNote,
      'doneImagePath': doneImagePath,
    };
  }
  // Konversi Map dari SQLite ke object

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      imagePath: map['imagePath'] as String,
      latitude: map['latitude'] != null
          ? (map['latitude'] as num).toDouble()
          : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
      doneNote: map['doneNote'] as String?,
      doneImagePath: map['doneImagePath'] as String?,
    );
  }
}
