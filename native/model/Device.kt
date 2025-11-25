package com.example.mobdragtestr.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import java.time.Instant

@Parcelize
data class Device(
    val localId: Int,
    val serverId: Int? = null,
    val model: String,
    val os: String,
    val screenResolution: String,
    val status: DeviceStatus,
    val usedBy: String? = null,
    val notes: String? = null,
    val dateAdded: Long = Instant.now().toEpochMilli(),
    val lastModified: Long = Instant.now().toEpochMilli()
) : Parcelable

enum class DeviceStatus { Available, InUse, Retired }
