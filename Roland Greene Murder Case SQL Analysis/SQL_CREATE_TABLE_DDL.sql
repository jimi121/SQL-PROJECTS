CREATE SCHEMA "Forensic Analysis";
SET search_path = "Forensic Analysis";

DROP TABLE IF EXISTS suspects;
CREATE TABLE suspects (
    suspect_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT,
    relation_to_victim TEXT,
    alibi TEXT
);

DROP TABLE IF EXISTS access_logs;
CREATE TABLE access_logs (
    log_id INTEGER PRIMARY KEY,
    suspect_id INTEGER,
    access_time TIMESTAMP NOT NULL,
    door_accessed TEXT,
    success_flag TEXT CHECK (success_flag IN ('True', 'False')),
    FOREIGN KEY (suspect_id) REFERENCES suspects(suspect_id)
);

DROP TABLE IF EXISTS call_records;
CREATE TABLE call_records (
    call_id INTEGER PRIMARY KEY,
    suspect_id INTEGER,
    call_timestamp TIMESTAMP NOT NULL,
    call_duration TEXT,
    recipient_relation TEXT,
    FOREIGN KEY (suspect_id) REFERENCES suspects(suspect_id)
);

DROP TABLE IF EXISTS forensic_events;
CREATE TABLE forensic_events (
    event_time TIMESTAMP NOT NULL,
    event_description TEXT
);

-- Import suspects data
COPY suspects 
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Forensic Analysis\datasets\suspects_large.csv'
WITH CSV HEADER;
-- Import access_logs data
COPY access_logs 
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Forensic Analysis\datasets\access_logs_large.csv'
WITH CSV HEADER;
-- Import call_records data
COPY call_records FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Forensic Analysis\datasets\call_records_large.csv'
WITH CSV HEADER;
-- Import forensic_events data
COPY forensic_events 
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Forensic Analysis\datasets\forensic_events_large.csv'
WITH CSV HEADER;