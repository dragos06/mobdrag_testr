package com.example.mobdragtestr.service

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.example.mobdragtestr.model.Device
import com.example.mobdragtestr.repository.DeviceRepository

class DeviceServiceImpl(private val repository: DeviceRepository) : DeviceService {
    private val _devices = MutableLiveData(repository.getAllDevices())
    override val devices: LiveData<List<Device>> = _devices

    override fun addDevice(device: Device) {
        val added = repository.addDevice(device)
        _devices.value = _devices.value.orEmpty() + added
    }

    override fun updateDevice(device: Device) {
        val updated = repository.updateDevice(device)
        _devices.value = _devices.value.orEmpty().map {
            if (it.localId == updated.localId) updated else it
        }
    }

    override fun deleteDevice(localId: Int) {
        repository.deleteDevice(localId)
        _devices.value = _devices.value.orEmpty().filter { it.localId != localId }
    }
}
