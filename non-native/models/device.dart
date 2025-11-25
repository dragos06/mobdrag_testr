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
    this.pendingSync = false,
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
    );
  }
}