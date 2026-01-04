package com.example.mobdragtestr.view

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.core.view.WindowCompat
import com.example.mobdragtestr.MobDragApp
import com.example.mobdragtestr.composables.Phone_android
import com.example.mobdragtestr.model.Device
import com.example.mobdragtestr.model.DeviceStatus
import com.example.mobdragtestr.viewmodel.DeviceViewModel

class MainActivity : ComponentActivity() {

    private val viewModel: DeviceViewModel by viewModels {
        (application as MobDragApp).deviceViewModelFactory
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, true)

        setContent {
            DeviceListScreen(viewModel = viewModel, activity = this)
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DeviceListScreen(viewModel: DeviceViewModel, activity: ComponentActivity) {
    val devices by viewModel.devices.observeAsState(emptyList())

    val activeColor = MaterialTheme.colorScheme.primary
    val inactiveColor = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFF0F0F0))
    ) {
        Scaffold(
            containerColor = Color.Transparent,
            topBar = {
                TopAppBar(
                    title = {
                        Box(
                            modifier = Modifier.fillMaxWidth(),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = "Devices",
                                fontWeight = FontWeight.Bold
                            )
                        }
                    },
                    colors = TopAppBarDefaults.topAppBarColors(
                        containerColor = Color(0xFFF0F0F0)
                    )
                )
            },
            bottomBar = {
                Column (modifier = Modifier.background(Color(0xFFF0F0F0))) {
                    HorizontalDivider(
                        color = Color.Black.copy(alpha = 0.05f),
                        thickness = 1.dp
                    )
                    BottomAppBar (containerColor = Color(0xFFF0F0F0)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceEvenly
                        ) {
                            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                IconButton(onClick = { }) {
                                    Icon(Phone_android, contentDescription = "Devices", tint = activeColor)
                                }
                                Text("Devices", color = activeColor)
                            }
                            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                IconButton(onClick = {
                                    activity.startActivity(Intent(activity, AddDeviceActivity::class.java))
                                }) {
                                    Icon(Icons.Default.Add, contentDescription = "Add Device", tint = inactiveColor)
                                }
                                Text("Add Device", color = inactiveColor)
                            }
                        }
                    }
                }
            }
        ) { paddingValues ->
            LazyColumn(
                contentPadding = paddingValues,
                modifier = Modifier.fillMaxSize()
            ) {
                items(devices, key = { it.localId }) { device ->
                    DeviceRow(device = device, onClick = {
                        val intent = Intent(activity, DeviceDetailsActivity::class.java)
                        intent.putExtra("deviceId", device.localId)
                        activity.startActivity(intent)
                    })
                }
            }
        }
    }
}

@Composable
fun DeviceRow(device: Device, onClick: () -> Unit) {
    val statusColor = when (device.status) {
        DeviceStatus.Available -> Color(0xFF4CAF50)
        DeviceStatus.InUse -> Color(0xFFFFC107)
        DeviceStatus.Retired -> Color(0xFFF44336)
    }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp, vertical = 4.dp)
            .clickable { onClick() },
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(4.dp)
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Card(
                modifier = Modifier.size(40.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFFF0F0F0)),
                elevation = CardDefaults.cardElevation(2.dp)
            ) {
                Box(contentAlignment = Alignment.Center, modifier = Modifier.fillMaxSize()) {
                    Icon(
                        imageVector = Phone_android,
                        contentDescription = "Device Icon",
                        modifier = Modifier.size(24.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.width(16.dp))

            Column(
                modifier = Modifier.weight(1f)
            ) {
                Text("Model: ${device.model}")
                Text("OS: ${device.os}")
            }

            Box(
                modifier = Modifier
                    .size(16.dp)
                    .clip(CircleShape)
                    .background(statusColor)
            )
        }
    }
}

