package com.example.mobdragtestr.service

import androidx.lifecycle.LiveData
import com.example.mobdragtestr.model.Device

interface DeviceService {
    val devices: LiveData<List<Device>>
    fun addDevice(device: Device)
    fun updateDevice(device: Device)
    fun deleteDevice(localId: Int)
}
