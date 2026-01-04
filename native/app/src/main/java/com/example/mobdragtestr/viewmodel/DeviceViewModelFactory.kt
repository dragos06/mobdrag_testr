package com.example.mobdragtestr.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.mobdragtestr.service.DeviceService

class DeviceViewModelFactory(private val service: DeviceService) : ViewModelProvider.Factory {

    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(DeviceViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return DeviceViewModel(service) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
