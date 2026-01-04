package com.example.mobdragtestr.repository

import com.example.mobdragtestr.model.Device
import com.example.mobdragtestr.model.DeviceStatus

class DeviceRepositoryImpl : DeviceRepository {
    private val devices = mutableListOf<Device>()
    private var nextId = 1

    init {
        seedDevices()
    }

    private fun seedDevices() {
        if (devices.isEmpty()) {
            val initialDevices = listOf(
                Device(localId = 0, model = "Pixel 7", os = "Android 14", screenResolution = "2400x1080", status = DeviceStatus.Available),
                Device(localId = 0, model = "iPhone 15", os = "iOS 17", screenResolution = "2796x1290", status = DeviceStatus.InUse, usedBy = "John Doe"),
                Device(localId = 0, model = "Galaxy S23", os = "Android 14", screenResolution = "2340x1080", status = DeviceStatus.Retired)
            )

            initialDevices.forEach { addDevice(it) }
        }
    }

    override fun getAllDevices(): List<Device> = devices.toList()

    override fun addDevice(device: Device): Device {
        val deviceWithId = device.copy(localId = nextId++)
        devices.add(deviceWithId)
        return deviceWithId
    }

    override fun updateDevice(device: Device): Device {
        val index = devices.indexOfFirst { it.localId == device.localId }
        if (index != -1) devices[index] = device
        return device
    }

    override fun deleteDevice(localId: Int) {
        devices.removeAll { it.localId == localId }
    }
}
