package com.example.mobdragtestr.view

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.LocalActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.core.view.WindowCompat
import com.example.mobdragtestr.MobDragApp
import com.example.mobdragtestr.model.Device
import com.example.mobdragtestr.model.DeviceStatus
import com.example.mobdragtestr.viewmodel.DeviceViewModel

class AddDeviceActivity : ComponentActivity() {

    private val viewModel: DeviceViewModel by viewModels {
        (application as MobDragApp).deviceViewModelFactory
    }

    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, true)

        setContent {
            Scaffold(
                topBar = {
                    TopAppBar(
                        title = {
                            Box(
                                modifier = Modifier.fillMaxWidth(),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(
                                    text = "Add Device",
                                    fontWeight = androidx.compose.ui.text.font.FontWeight.Bold,
                                    color = Color.Black
                                )
                            }
                        },
                        colors = TopAppBarDefaults.topAppBarColors(
                            containerColor = Color(0xFFF0F0F0),
                            titleContentColor = Color.White
                        )
                    )
                },
                containerColor = Color(0xFFF0F0F0)
            ) { paddingValues ->
                AddDeviceScreen(
                    viewModel = viewModel,
                    modifier = Modifier
                        .padding(paddingValues)
                        .fillMaxSize()
                        .background(Color(0xFFF0F0F0))
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddDeviceScreen(
    viewModel: DeviceViewModel,
    modifier: Modifier = Modifier
) {
    val activity = LocalActivity.current
    val scrollState = rememberScrollState()

    val MAX_MODEL = 50
    val MAX_OS = 30
    val MAX_SCREEN = 20
    val MAX_USED_BY = 50
    val MAX_NOTES = 200

    var model by remember { mutableStateOf("") }
    var os by remember { mutableStateOf("") }
    var screen by remember { mutableStateOf("") }
    var usedBy by remember { mutableStateOf("") }
    var notes by remember { mutableStateOf("") }
    var status by remember { mutableStateOf(DeviceStatus.Available) }
    var error by remember { mutableStateOf<String?>(null) }
    var expanded by remember { mutableStateOf(false) }

    Column(
        modifier = modifier
            .padding(16.dp)
            .verticalScroll(scrollState),
        verticalArrangement = Arrangement.Top,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        @Composable
        fun textFieldColors() = TextFieldDefaults.colors(
            focusedContainerColor = Color.White,
            unfocusedContainerColor = Color.White,
            focusedTextColor = Color.Black,
            unfocusedTextColor = Color.Black,
            focusedIndicatorColor = Color.Transparent,
            unfocusedIndicatorColor = Color.Transparent,
            cursorColor = Color.Black
        )

        val roundedShape = RoundedCornerShape(12.dp)

        TextField(
            value = model,
            onValueChange = { input ->
                model = input.take(MAX_MODEL)
            },
            label = { Text("Model") },
            colors = textFieldColors(),
            shape = roundedShape,
            modifier = Modifier.fillMaxWidth(),
            isError = model.length > MAX_MODEL
        )
        if (model.length >= MAX_MODEL) {
            Text(
                "Max $MAX_MODEL characters",
                color = MaterialTheme.colorScheme.error,
                style = MaterialTheme.typography.labelSmall,
                modifier = Modifier.align(Alignment.End)
            )
        }
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = os,
            onValueChange = { input ->
                os = input.take(MAX_OS)
            },
            label = { Text("OS") },
            colors = textFieldColors(),
            shape = roundedShape,
            modifier = Modifier.fillMaxWidth(),
            isError = os.length > MAX_OS
        )
        if (os.length >= MAX_OS) {
            Text(
                "Max $MAX_OS characters",
                color = MaterialTheme.colorScheme.error,
                style = MaterialTheme.typography.labelSmall,
                modifier = Modifier.align(Alignment.End)
            )
        }
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = screen,
            onValueChange = { input ->
                screen = input.take(MAX_SCREEN)
            },
            label = { Text("Screen Resolution") },
            colors = textFieldColors(),
            shape = roundedShape,
            modifier = Modifier.fillMaxWidth(),
            isError = screen.length > MAX_SCREEN
        )
        if (screen.length >= MAX_SCREEN) {
            Text(
                "Max $MAX_SCREEN characters",
                color = MaterialTheme.colorScheme.error,
                style = MaterialTheme.typography.labelSmall,
                modifier = Modifier.align(Alignment.End)
            )
        }
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = usedBy,
            onValueChange = { input ->
                usedBy = input.take(MAX_USED_BY)
            },
            label = { Text("Used By") },
            colors = textFieldColors(),
            shape = roundedShape,
            modifier = Modifier.fillMaxWidth(),
            isError = usedBy.length > MAX_USED_BY
        )
        if (usedBy.length >= MAX_USED_BY) {
            Text(
                "Max $MAX_USED_BY characters",
                color = MaterialTheme.colorScheme.error,
                style = MaterialTheme.typography.labelSmall,
                modifier = Modifier.align(Alignment.End)
            )
        }
        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = notes,
            onValueChange = { input ->
                notes = input.take(MAX_NOTES)
            },
            label = { Text("Notes") },
            colors = textFieldColors(),
            shape = roundedShape,
            modifier = Modifier
                .fillMaxWidth()
                .heightIn(min = 100.dp),
            isError = notes.length > MAX_NOTES,
            maxLines = 10
        )
        if (notes.length >= MAX_NOTES) {
            Text(
                "Max $MAX_NOTES characters",
                color = MaterialTheme.colorScheme.error,
                style = MaterialTheme.typography.labelSmall,
                modifier = Modifier.align(Alignment.End)
            )
        }
        Spacer(modifier = Modifier.height(16.dp))

        ExposedDropdownMenuBox(
            expanded = expanded,
            onExpandedChange = { expanded = !expanded },
            modifier = Modifier.fillMaxWidth()
        ) {
            TextField(
                value = status.name,
                onValueChange = {},
                readOnly = true,
                label = { Text("Status") },
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                colors = textFieldColors(),
                shape = roundedShape,
                modifier = Modifier.fillMaxWidth()
            )

            ExposedDropdownMenu(
                expanded = expanded,
                onDismissRequest = { expanded = false }
            ) {
                DeviceStatus.entries.forEach { s ->
                    DropdownMenuItem(
                        text = { Text(s.name) },
                        onClick = {
                            status = s
                            expanded = false
                        },
                        modifier = Modifier.background(Color(0xFFF0F0F0))
                    )
                }
            }
        }
        Spacer(modifier = Modifier.height(16.dp))

        error?.let {
            Text(
                text = it,
                color = MaterialTheme.colorScheme.error,
                modifier = Modifier.padding(bottom = 8.dp)
            )
        }

        Button(
            onClick = {
                when {
                    model.isBlank() || os.isBlank() || screen.isBlank() ->
                        error = "Model, OS, and Screen Resolution are required"
                    model.length > MAX_MODEL ->
                        error = "Model cannot exceed $MAX_MODEL characters"
                    os.length > MAX_OS ->
                        error = "OS cannot exceed $MAX_OS characters"
                    screen.length > MAX_SCREEN ->
                        error = "Screen Resolution cannot exceed $MAX_SCREEN characters"
                    usedBy.length > MAX_USED_BY ->
                        error = "Used By cannot exceed $MAX_USED_BY characters"
                    notes.length > MAX_NOTES ->
                        error = "Notes cannot exceed $MAX_NOTES characters"
                    else -> {
                        viewModel.addDevice(
                            Device(
                                localId = 0,
                                model = model,
                                os = os,
                                screenResolution = screen,
                                status = status,
                                usedBy = usedBy.ifBlank { null },
                                notes = notes.ifBlank { null }
                            )
                        )
                        activity?.finish()
                    }
                }
            },
            colors = ButtonDefaults.buttonColors(
                containerColor = Color(0xFF2196F3),
                contentColor = Color.White
            ),
            shape = roundedShape,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Add Device")
        }
    }
}
