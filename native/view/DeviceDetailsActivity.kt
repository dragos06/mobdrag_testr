package com.example.mobdragtestr.view

import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.core.view.WindowCompat
import com.example.mobdragtestr.MobDragApp
import com.example.mobdragtestr.model.Device
import com.example.mobdragtestr.model.DeviceStatus
import com.example.mobdragtestr.viewmodel.DeviceViewModel

class DeviceDetailsActivity : ComponentActivity() {

    private val viewModel: DeviceViewModel by viewModels {
        (application as MobDragApp).deviceViewModelFactory
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, true)

        val deviceId = intent.getIntExtra("deviceId", -1)
        if (deviceId == -1) {
            finish(); return
        }

        setContent {
            Surface(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color(0xFFF0F0F0)),
                color = Color(0xFFF0F0F0)
            ) {
                DeviceDetailsScreen(
                    viewModel = viewModel,
                    deviceId = deviceId,
                    activity = this
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DeviceDetailsScreen(
    viewModel: DeviceViewModel,
    deviceId: Int,
    activity: ComponentActivity,
    modifier: Modifier = Modifier
) {
    val devices by viewModel.devices.observeAsState(emptyList())
    var device by remember { mutableStateOf<Device?>(null) }
    var showDeleteDialog by remember { mutableStateOf(false) }

    val scrollState = rememberScrollState()

    LaunchedEffect(devices) {
        device = devices.find { it.localId == deviceId }
    }

    device?.let { currentDevice ->
        Scaffold(
            containerColor = Color(0xFFF0F0F0),
            contentColor = Color.Black,
            topBar = {
                TopAppBar(
                    title = {
                        Box(
                            modifier = Modifier.fillMaxWidth(),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = "Device Details",
                                fontWeight = FontWeight.Bold,
                                color = Color.Black
                            )
                        }
                    },
                    colors = TopAppBarDefaults.topAppBarColors(
                        containerColor = Color(0xFFF0F0F0),
                        titleContentColor = Color.Black
                    )
                )
            },
            modifier = modifier
                .fillMaxSize()
                .background(Color(0xFFF0F0F0))
        ) { paddingValues ->

            Column(
                modifier = Modifier
                    .padding(paddingValues)
                    .padding(16.dp)
                    .fillMaxSize()
                    .background(Color(0xFFF0F0F0))
                    .verticalScroll(scrollState),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {

                @Composable
                fun FieldCard(label: String, value: String) {
                    Card(
                        modifier = Modifier.fillMaxWidth(),
                        colors = CardDefaults.cardColors(containerColor = Color.White),
                        elevation = CardDefaults.cardElevation(2.dp)
                    ) {
                        Column(modifier = Modifier.padding(16.dp)) {
                            Text(label, fontWeight = FontWeight.Medium, color = Color.Gray)
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(value)
                        }
                    }
                }

                FieldCard("Model", currentDevice.model)
                FieldCard("OS", currentDevice.os)
                FieldCard("Screen Resolution", currentDevice.screenResolution)
                FieldCard("Status", currentDevice.status.name)
                FieldCard("Used By", currentDevice.usedBy ?: "-")

                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .heightIn(min = 100.dp),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    elevation = CardDefaults.cardElevation(2.dp)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text("Notes", fontWeight = FontWeight.Medium, color = Color.Gray)
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(currentDevice.notes ?: "-", modifier = Modifier.fillMaxWidth())
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Button(
                        modifier = Modifier.weight(1f),
                        onClick = {
                            val intent = android.content.Intent(activity, UpdateDeviceActivity::class.java)
                            intent.putExtra("device", currentDevice)
                            activity.startActivity(intent)
                        },
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2196F3))
                    ) {
                        Text("Edit Device", color = Color.White)
                    }

                    Button(
                        modifier = Modifier.weight(1f),
                        onClick = {
                            if (currentDevice.status == DeviceStatus.Retired) {
                                showDeleteDialog = true
                            } else {
                                Toast.makeText(
                                    activity,
                                    "This device has not been retired yet. You cannot remove it.",
                                    Toast.LENGTH_LONG
                                ).show()
                            }
                        },
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFF44336))
                    ) {
                        Text("Remove Device", color = Color.White)
                    }
                }
            }
        }

        if (showDeleteDialog) {
            AlertDialog(
                onDismissRequest = { showDeleteDialog = false },
                containerColor = Color(0xFFF0F0F0),
                title = { Text("Delete Device") },
                text = { Text("Are you sure you want to delete this device?") },
                confirmButton = {
                    TextButton(
                        onClick = {
                        viewModel.deleteDevice(currentDevice.localId)
                        activity.finish()
                    }) { Text("Yes", color = Color.Red) }
                },
                dismissButton = {
                    TextButton(onClick = { showDeleteDialog = false }) { Text("No", color = Color.Black) }
                }
            )
        }
    } ?: run {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color(0xFFF0F0F0)),
            contentAlignment = Alignment.Center
        ) {
            Text("Device not found")
        }
    }
}
