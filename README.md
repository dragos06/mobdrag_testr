# 📱 MobDrag Testr

## 🧩 Overview

**MobDrag Testr** is a mobile app designed to help testers and developers keep track of the physical devices used in software testing. It allows users to view and manage a shared list of test devices, each showing important details like the model, operating system, screen resolution, and current usage status. 

Users can also note any known defects, such as a broken camera or slow performance, to keep the team informed. Even when there’s no internet connection, the app continues to work normally — all changes are safely stored on the phone and automatically synchronized with the server once the device reconnects. This makes it easy for testing teams to stay organized, ensure accurate tracking of devices, and maintain a smooth workflow both online and offline.

---

## 🧠 Domain Details

### Entity: **Device**
| Field | Description |
|-------|--------------|
| **id** | Unique identifier for the device (auto-generated). |
| **model** | The name or model of the device (e.g., “Samsung Galaxy S22”). |
| **os** | The operating system and version (e.g., Android 14, iOS 17). |
| **screen_resolution** | Screen size or resolution for UI/UX testing reference. |
| **status** | Current availability of the device (`Available`, `In Use`, `Retired`). |
| **used_by** | The user currently using the device (null if available or retired). |
| **notes** | Notes about defects or relevant details (e.g., “camera not working”). |
| **last_modified** | Timestamp for when the device was last modified. |

---

## ⚙️ CRUD Operations

- **Create:** Add a new device entry to the catalog.
- **Read:** View the complete list of devices and their details.
- **Update:** Modify details such as status, assigned user, or notes.
- **Delete:** Remove a device permanently from the catalog.

---

## 💾 Persistence & Synchronization

### Local Database
- Stores device list and all locally queued CRUD operations made while offline.
- Data persists across app restarts.
- Automatically synchronizes once the app reconnects to the internet.

### Remote Server (REST API)
- The server maintains the shared catalog.

**Endpoints:**
| Method | Endpoint | Description |
|---------|-----------|-------------|
| `GET` | `/devices` | Retrieve all devices. |
| `POST` | `/devices` | Add a new device. |
| `PUT` | `/devices/{id}` | Update a device’s details. |
| `DELETE` | `/devices/{id}` | Delete a device. |

---

## 🌐 Offline Behavior

The app is fully functional offline, with all CRUD operations stored locally and automatically synchronized when online again.

Below are detailed scenarios for each operation when the device is offline:

### 🔹 **Create (Add Device)**
- When the user adds a new device while offline:
    - The device is created with a temporary local ID and marked as **“pending sync”** in the **local database**.
    - Once online, the app sends the new device to the server, receives a server-generated ID, and updates the local record.

### 🔹 **Read (View Devices)**
- When offline, the app:
    - Displays the **locally cached list** of devices.
    - Shows a banner message:
        > “Offline – displaying last synced device data.”
    - No live updates are available until the connection is restored.

### 🔹 **Update (Edit Device)**
- When a user edits a device (e.g., changes status or notes) offline:
    - The change is stored locally and marked as **“pending sync”** in the **local database**.
    - Once reconnected, the app pushes the update to the server.
    - If multiple users edit the same device while offline, the server resolves conflicts using the **most recent timestamp**.

### 🔹 **Delete (Remove Device)**
- When a user deletes a device offline:
    - The device is marked as **“pending sync”** and **“deleted locally”** and hidden from the UI.
    - Once online, the server permanently removes the device, and the app confirms the deletion.

---

**Author:** Dragos Serban  
**Course:** Mobile Applications  
**Project:** MobDrag Testr
