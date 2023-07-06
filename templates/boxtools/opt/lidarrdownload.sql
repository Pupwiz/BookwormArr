--
-- File generated with SQLiteStudio v3.4.3 on Sun Jan 22 10:28:24 2023
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: DownloadClients
CREATE TABLE "DownloadClients" ("Id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "Enable" INTEGER NOT NULL, "Name" TEXT NOT NULL, "Implementation" TEXT NOT NULL, "Settings" TEXT NOT NULL, "ConfigContract" TEXT NOT NULL, "Priority" INTEGER NOT NULL DEFAULT 1, "RemoveCompletedDownloads" INTEGER NOT NULL DEFAULT 1, "RemoveFailedDownloads" INTEGER NOT NULL DEFAULT 1);
INSERT INTO DownloadClients (Id, Enable, Name, Implementation, Settings, ConfigContract, Priority, RemoveCompletedDownloads, RemoveFailedDownloads) VALUES (1, 1, 'Transmisson', 'Transmission', '{
  "host": "localhost",
  "port": 9091,
  "useSsl": false,
  "urlBase": "/transmission/",
  "username": "media",
  "password": "password",
  "musicCategory": "lidarr",
  "recentTvPriority": 0,
  "olderTvPriority": 0,
  "addPaused": false
}', 'TransmissionSettings', 1, 1, 1);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
