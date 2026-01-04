package com.example.mobdragtestr.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import com.example.mobdragtestr.model.Device
import com.example.mobdragtestr.service.DeviceService

class DeviceViewModel(private val service: DeviceService) : ViewModel() {
    val devices: LiveData<List<Device>> = service.devices
    fun addDevice(device: Device) = service.addDevice(device)
    fun updateDevice(device: Device) = service.updateDevice(device)
    fun deleteDevice(localId: Int) = service.deleteDevice(localId)
}
