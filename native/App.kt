package com.example.mobdragtestr

import android.app.Application
import com.example.mobdragtestr.repository.DeviceRepositoryImpl
import com.example.mobdragtestr.service.DeviceService
import com.example.mobdragtestr.service.DeviceServiceImpl
import com.example.mobdragtestr.viewmodel.DeviceViewModelFactory

class MobDragApp : Application() {
    val sharedDeviceService: DeviceService by lazy {
        val repository = DeviceRepositoryImpl()
        DeviceServiceImpl(repository)
    }

    val deviceViewModelFactory: DeviceViewModelFactory by lazy {
        DeviceViewModelFactory(sharedDeviceService)
    }
}
