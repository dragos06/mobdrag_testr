package com.example.mobdragtestr.repository

import com.example.mobdragtestr.model.Device

interface DeviceRepository {
    fun getAllDevices(): List<Device>
    fun addDevice(device: Device): Device
    fun updateDevice(device: Device): Device
    fun deleteDevice(localId: Int)
}
