enum DeviceStatus { available, inUse, retired }

class Device {
  final int localId;
  final int? serverId;
  final String model;
  final String os;
  final String screenResolution;
  final DeviceStatus status;
  final String? usedBy;
  final String? notes;
  final DateTime lastModified;
  final bool pendingSync;
  final bool toDelete;

  Device({
    required this.localId,
    this.serverId,
    required this.model,
    required this.os,
    required this.screenResolution,
    required this.status,
    this.usedBy,
    this.notes,
    DateTime? lastModified,
    this.pendingSync = true,
    this.toDelete = false,
  }) : lastModified = lastModified ?? DateTime.now();

  Device copyWith({
    int? localId,
    int? serverId,
    String? model,
    String? os,
    String? screenResolution,
    DeviceStatus? status,
    String? usedBy,
    String? notes,
    DateTime? lastModified,
    bool? pendingSync,
    bool? toDelete,
  }) {
    return Device(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      model: model ?? this.model,
      os: os ?? this.os,
      screenResolution: screenResolution ?? this.screenResolution,
      status: status ?? this.status,
      usedBy: usedBy ?? this.usedBy,
      notes: notes ?? this.notes,
      lastModified: lastModified ?? DateTime.now(),
      pendingSync: pendingSync ?? this.pendingSync,
      toDelete: toDelete ?? this.toDelete,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (serverId != null) 'id': serverId,
      'model': model,
      'os': os,
      'screenResolution': screenResolution,
      'status': status.index,
      'usedBy': usedBy,
      'notes': notes,

      'lastModified': lastModified.toIso8601String(),
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      localId: 0,
      serverId: json['id'],
      model: json['model'],
      os: json['os'],
      screenResolution: json['screenResolution'],
      status: DeviceStatus.values[json['status'] ?? 0],
      usedBy: json['usedBy'],
      notes: json['notes'],
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'])
          : null,
      pendingSync: false,
      toDelete: false,
    );
  }
}