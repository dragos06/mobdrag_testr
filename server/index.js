const express = require('express');
const http = require('http');
const { Server } = require("socket.io");
const { PrismaClient } = require('@prisma/client');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const server = http.createServer(app);
const io = new Server(server);
const prisma = new PrismaClient();

app.use(cors());
app.use(bodyParser.json());

const PORT = 3000;


app.use((req, res, next) => {
    console.log(`[SERVER] ${req.method} ${req.url}`);
    next();
});


const validateDevice = (data) => {
    const errors = [];
    if (!data.model || data.model.length < 1 || data.model.length > 50) errors.push("Model must be 1-50 chars.");
    if (!data.os || data.os.length < 1 || data.os.length > 30) errors.push("OS must be 1-30 chars.");
    if (!data.screenResolution || data.screenResolution.length < 1 || data.screenResolution.length > 20) errors.push("Screen Resolution must be 1-20 chars.");
    if (data.usedBy && data.usedBy.length > 50) errors.push("Used By max 50 chars.");
    if (data.notes && data.notes.length > 200) errors.push("Notes max 200 chars.");
    return errors;
};




app.get('/devices', async (req, res) => {
    try {
        const devices = await prisma.device.findMany();
        console.log(`[SERVER] Fetched ${devices.length} devices`);
        res.json(devices);
    } catch (e) {
        console.error("[SERVER] Error fetching devices", e);
        res.status(500).json({ error: "Internal Server Error" });
    }
});


app.post('/devices', async (req, res) => {
    try {
        const data = req.body;
        
        const validationErrors = validateDevice(data);
        if (validationErrors.length > 0) {
            console.log(`[SERVER] Validation failed: ${validationErrors.join(', ')}`);
            return res.status(400).json({ error: validationErrors.join(' ') });
        }

        const device = await prisma.device.create({
            data: {
                model: data.model,
                os: data.os,
                screenResolution: data.screenResolution,
                status: data.status,
                usedBy: data.usedBy || null,
                notes: data.notes || null,
                lastModified: new Date()
            }
        });
        console.log(`[SERVER] Created device: ${device.id}`);
        io.emit('device_added', device); 
        res.json(device);
    } catch (e) {
        console.error("[SERVER] Error creating device", e);
        res.status(500).json({ error: "Could not create device" });
    }
});


app.put('/devices/:id', async (req, res) => {
    const id = parseInt(req.params.id);
    try {
        const data = req.body;

        const validationErrors = validateDevice(data);
        if (validationErrors.length > 0) {
            return res.status(400).json({ error: validationErrors.join(' ') });
        }

        
        const currentDevice = await prisma.device.findUnique({ where: { id: id } });

        if (!currentDevice) {
            return res.status(404).json({ error: "Device not found on server" });
        }

        
        if (data.lastModified) {
            const clientTime = new Date(data.lastModified).getTime();
            const serverTime = new Date(currentDevice.lastModified).getTime();

            
            if (serverTime > clientTime) {
                console.log(`[SERVER] Conflict ID ${id}. Server: ${serverTime} > Client: ${clientTime}`);
                return res.status(409).json({ 
                    error: "Conflict: Server has a newer version",
                    serverData: currentDevice 
                });
            }
        }

        const device = await prisma.device.update({
            where: { id: id },
            data: {
                model: data.model,
                os: data.os,
                screenResolution: data.screenResolution,
                status: data.status,
                usedBy: data.usedBy || null,
                notes: data.notes || null,
                lastModified: new Date() 
            }
        });
        console.log(`[SERVER] Updated device: ${id}`);
        io.emit('device_updated', device);
        res.json(device);
    } catch (e) {
        console.error(`[SERVER] Error updating device ${id}`, e);
        res.status(500).json({ error: "Could not update device" });
    }
});


app.delete('/devices/:id', async (req, res) => {
    const id = parseInt(req.params.id);
    try {
        await prisma.device.delete({ where: { id: id } });
        console.log(`[SERVER] Deleted device: ${id}`);
        io.emit('device_deleted', id);
        res.json({ success: true, id: id });
    } catch (e) {
        
        if (e.code === 'P2025') {
            console.log(`[SERVER] Device ${id} already deleted. Ignoring.`);
            return res.json({ success: true, id: id, message: "Already deleted" });
        }
        console.error(`[SERVER] Error deleting device ${id}`, e);
        res.status(500).json({ error: "Could not delete device" });
    }
});


io.on('connection', (socket) => {
    console.log('[SERVER] New WebSocket client connected');
    socket.on('disconnect', () => {
        console.log('[SERVER] Client disconnected');
    });
});

server.listen(PORT, () => {
    console.log(`[SERVER] Running on http://localhost:${PORT}`);
});