--
-- File generated with SQLiteStudio v3.4.3 on Sun Jan 22 10:28:03 2023
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: RootFolders
CREATE TABLE "RootFolders" ("Id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "Path" TEXT NOT NULL, "Name" TEXT, "DefaultMetadataProfileId" INTEGER NOT NULL DEFAULT 0, "DefaultQualityProfileId" INTEGER NOT NULL DEFAULT 0, "DefaultMonitorOption" INTEGER NOT NULL DEFAULT 0, "DefaultTags" TEXT, "DefaultNewItemMonitorOption" INTEGER NOT NULL DEFAULT 0);
INSERT INTO RootFolders (Id, Path, Name, DefaultMetadataProfileId, DefaultQualityProfileId, DefaultMonitorOption, DefaultTags, DefaultNewItemMonitorOption) VALUES (1, '/home/media/music/', 'Books', 1, 1, 0, '[]', 0);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
