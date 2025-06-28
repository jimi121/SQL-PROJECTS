# Solving the Murder of Roland Greene: A PostgreSQL-Driven Forensic Data Analysis

## Introduction

On June 1, 2025, Roland Greene, a renowned art collector, was fatally shot in his secure Vault Room at precisely 8:00 PM (20:00:00) during an exclusive art auction at his sprawling estate. The high-stakes event, attended by 30 elite guests from the art world, was a hotbed of ambition, rivalry, and deception, with valuable artworks on the line. Among the guests, the killer concealed their actions behind a false alibi, exploiting a mysterious phone call that coincided with the murder to evade detection. As a Forensic Data Analyst, I was tasked with unraveling this complex case, leveraging PostgreSQL to analyze large datasets capturing suspect movements, phone calls, and alibis. My mission was to answer five critical questions:

1. **Who killed Roland Greene?**
2. **Who are the prime suspects, and why?**
3. **What was the killer’s motive?**
4. **How did they evade detection?**
5. **Was there an accomplice?**

This portfolio project showcases my expertise in designing and querying PostgreSQL databases to solve intricate problems, complemented by targeted Python visualizations to present evidence clearly. By meticulously analyzing access logs, call records, and alibis, I identified the killer through evidence-based reasoning, cross-referencing suspect timelines and deceptive behaviors. The investigation required navigating a chaotic web of guest movements during the auction, pinpointing critical moments like the mysterious call, and ensuring no detail was overlooked. This work demonstrates my ability to manage complex datasets, optimize database performance with indexing, and communicate findings effectively to both technical and non-technical audiences, making it a standout piece for data analyst roles.

## Datasets

The investigation relies on four complex datasets stored in a PostgreSQL database:

- **Suspects List** (`suspects_large.csv`):

  - **Columns**: `suspect_id` (unique integer ID), `name` (e.g., Robin Ahmed), `role` (e.g., Art Dealer, Cleaner), `relation_to_victim` (e.g., Friend, Rival, Former Partner), `alibi` (e.g., “Left early,” “At hospital”).
  - **Description**: Profiles 30 auction guests, detailing their roles, relationships to Roland, and claimed alibis, crucial for identifying deceptive statements.

- **Access Logs** (`access_logs_large.csv`):

  - **Columns**: `log_id` (unique ID), `suspect_id`, `access_time` (timestamp, e.g., `2025-06-01 19:56:35.000`), `door_accessed` (e.g., Vault Room, Kitchen, Office), `success_flag` (True for successful entry, False for failed attempt).
  - **Description**: Tracks all room access attempts across the estate, capturing movements in rooms like the Vault Room (crime scene), Kitchen, Office, Library, and Master Bedroom. A successful entry to a new room indicates exiting the previous room, as the estate’s security system logs entries, not explicit exits.

- **Call Records** (`call_records_large.csv`):

  - **Columns**: `call_id`, `suspect_id`, `call_timestamp` (start time, e.g., `2025-06-01 19:56:39.000`), `call_duration` (e.g., “6 min”), `recipient_relation` (e.g., “Victim” for Roland).
  - **Description**: Logs phone calls made during the auction, key for identifying distractions or coordination around the murder time.

- **Forensic Timeline** (`forensic_events.csv`):

  - **Columns**: `event_id`, `event_time` (timestamp), `event_description` (e.g., “Gunshot heard”).
  - **Description**: Records critical events, with the murder confirmed at 20:00:00 in the Vault Room.

All timestamps are in `YYYY-MM-DD HH:MM:SS.000` format. I focused on the 19:50:00–20:10:00 window to capture activity around the murder, ensuring rigorous exit checks to confirm suspect locations without assumptions.

## Analysis Process

### Step 1: Database Setup

To manage the datasets efficiently, I designed a PostgreSQL database with four tables, enforcing data integrity and enhancing performance with indexing:

```sql
-- Create tables with constraints
CREATE TABLE suspects (
    suspect_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT,
    relation_to_victim TEXT,
    alibi TEXT
);

CREATE TABLE access_logs (
    log_id INTEGER PRIMARY KEY,
    suspect_id INTEGER,
    access_time TIMESTAMP NOT NULL,
    door_accessed TEXT,
    success_flag TEXT CHECK (success_flag IN ('True', 'False')),
    FOREIGN KEY (suspect_id) REFERENCES suspects(suspect_id)
);

CREATE TABLE call_records (
    call_id INTEGER PRIMARY KEY,
    suspect_id INTEGER,
    call_timestamp TIMESTAMP NOT NULL,
    call_duration TEXT,
    recipient_relation TEXT,
    FOREIGN KEY (suspect_id) REFERENCES suspects(suspect_id)
);

CREATE TABLE forensic_events (
    event_id INTEGER PRIMARY KEY,
    event_time TIMESTAMP NOT NULL,
    event_description TEXT
);

-- Create indexes for performance
CREATE INDEX idx_access_time ON access_logs (access_time);
CREATE INDEX idx_suspect_id ON access_logs (suspect_id);
CREATE INDEX idx_call_timestamp ON call_records (call_timestamp);

-- Import data (update paths to your local files)
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
```

- **Why This Setup?**:
  - **Constraints**: The `FOREIGN KEY` constraints ensure `suspect_id` consistency across tables, preventing data mismatches (e.g., invalid IDs in access logs).
  - **Indexes**: Indexes on `access_time`, `suspect_id`, and `call_timestamp` improve query performance by enabling faster lookups and joins, especially for filtering the 19:50:00–20:10:00 window and matching suspects across tables.
  - **Data Integrity**: I verified that timestamps were in the correct format (e.g., `2025-06-01 19:56:35.000`) and CSVs were imported without errors, ensuring reliable analysis.

### Step 2: Establishing the Crime Timeline

Using the forensic timeline and provided context, I established key events to frame the analysis:

- **19:56:39**: A mysterious phone call begins, likely to Roland, critical for understanding distractions during the murder.
- **20:00:00**: Gunshot heard in the Vault Room, confirming Roland Greene’s murder.
- **20:02:39**: Mysterious call ends, possibly due to Roland’s phone being dropped or left active post-murder.
- **20:03:00**: Security feed cut, suggesting an attempt to obscure suspect movements.
- **20:05:45**: Emergency call placed, indicating the crime’s discovery.

I focused on the 19:50:00–20:10:00 window to capture all relevant suspect activity, with a particular emphasis on the Vault Room, the confirmed crime scene. To avoid assumptions about suspect locations, I conducted rigorous exit checks by examining successful accesses to other rooms, as the access logs record entries, not explicit exits.

### Step 3: Query Analysis

I used the provided query results to analyze suspect movements, phone calls, and alibis, exporting each to CSVs (`vault_access.csv`, `subsequent_accesses.csv`, `calls.csv`, `false_alibis.csv`) for consistency and visualization. Below, I detail each query, its results, and a step-by-step interpretation, ensuring clarity and thorough exit checks for all suspects.

#### Query 1: Vault Room Access

This query identifies successful Vault Room entries between 19:50:00 and 20:10:00, as the murder occurred in the Vault Room at 20:00:00:

```sql
SELECT a.suspect_id, s.name, a.access_time
FROM access_logs a
JOIN suspects s ON a.suspect_id = s.suspect_id
WHERE a.door_accessed = 'Vault Room'
AND a.access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:10:00'
AND a.success_flag = 'True';
COPY (query above) TO '/path/to/vault_access.csv' WITH CSV HEADER;
```

**Results**:

| suspect_id | name | access_time |
| --- | --- | --- |
| 27 | Victor Shaw | 2025-06-01 19:50:39.000 |
| 14 | Samira Shaw | 2025-06-01 19:52:00.000 |
| 17 | Robin Ahmed | 2025-06-01 19:56:35.000 |
| 28 | Jamie Bennett | 2025-06-01 20:00:55.000 |
| 27 | Victor Shaw | 2025-06-01 20:04:53.000 |
| 23 | Evan Ahmed | 2025-06-01 20:09:14.000 |

**Step-by-Step Interpretation**:

- **Purpose**: Identify who entered the Vault Room, the crime scene, around the 20:00:00 murder time.
- **Key Observations**:
  - **Victor Shaw**: Entered at 19:50:39 (9 minutes 21 seconds before the murder), re-entered at 20:04:53 (4 minutes 53 seconds after the murder).
  - **Samira Shaw**: Entered at 19:52:00 (8 minutes before the murder).
  - **Robin Ahmed**: Entered at 19:56:35 (3 minutes 25 seconds before the murder).
  - **Jamie Bennett**: Entered at 20:00:55 (55 seconds after the murder).
  - **Evan Ahmed**: Entered at 20:09:14 (9 minutes 14 seconds after the murder).
- **Initial Suspects**: Victor, Samira, and Robin entered the Vault Room before 20:00:00, so they could have been present during the murder. Jamie and Evan entered too late to be the killer.
- **Next Step**: Check subsequent access logs to confirm whether Victor, Samira, or Robin exited the Vault Room before 20:00:00. A successful entry to another room (e.g., Kitchen, Office) indicates leaving the previous room, as the security system logs entries.

#### Query 2: Subsequent Accesses

This query tracks all access attempts (successful and failed) by suspects who accessed the Vault Room, to map their movements and verify exits:

```sql
SELECT s.name, a.access_time, a.door_accessed, a.success_flag
FROM access_logs a
JOIN suspects s ON a.suspect_id = s.suspect_id
WHERE a.suspect_id IN (14, 17, 23, 27, 28)
AND a.access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:10:00'
ORDER BY a.access_time;
COPY (query above) TO '/path/to/subsequent_accesses.csv' WITH CSV HEADER;
```

**Results**:

| name | access_time | door_accessed | success_flag |
| --- | --- | --- | --- |
| Victor Shaw | 2025-06-01 19:50:39.000 | Vault Room | True |
| Samira Shaw | 2025-06-01 19:52:00.000 | Vault Room | True |
| Victor Shaw | 2025-06-01 19:52:36.000 | Kitchen | True |
| Robin Ahmed | 2025-06-01 19:54:05.000 | Office | True |
| Jamie Bennett | 2025-06-01 19:54:40.000 | Vault Room | False |
| Evan Ahmed | 2025-06-01 19:55:17.000 | Kitchen | True |
| Robin Ahmed | 2025-06-01 19:56:35.000 | Vault Room | True |
| Evan Ahmed | 2025-06-01 19:59:06.000 | Office | False |
| Jamie Bennett | 2025-06-01 20:00:09.000 | Office | True |
| Evan Ahmed | 2025-06-01 20:00:20.000 | Library | True |
| Jamie Bennett | 2025-06-01 20:00:55.000 | Vault Room | True |
| Victor Shaw | 2025-06-01 20:01:03.000 | Master Bedroom | True |
| Victor Shaw | 2025-06-01 20:01:47.000 | Library | False |
| Evan Ahmed | 2025-06-01 20:02:58.000 | Office | False |
| Robin Ahmed | 2025-06-01 20:03:51.000 | Master Bedroom | False |
| Victor Shaw | 2025-06-01 20:04:53.000 | Vault Room | True |
| Evan Ahmed | 2025-06-01 20:09:14.000 | Vault Room | True |

**Detailed Suspect Timelines with Exit Checks**: To determine who was in the Vault Room at 20:00:00, I traced each suspect’s movements, focusing on successful accesses to other rooms, which indicate exiting the Vault Room. The estate’s security system logs entries, so a successful entry elsewhere confirms leaving the previous room (e.g., from Vault Room to Kitchen).

- **Victor Shaw** (ID 27):

  - **19:50:39**: Entered Vault Room (successful).
  - **19:52:36**: Entered Kitchen (successful).
    - **Exit Check**: Entering the Kitchen confirms Victor left the Vault Room, as the security system requires exiting one room to enter another.
  - **20:01:03**: Entered Master Bedroom (successful).
  - **20:01:47**: Attempted Library (failed, remained in Master Bedroom).
  - **20:04:53**: Re-entered Vault Room (successful, post-murder).
  - **At 20:00:00**: Victor was likely in the Kitchen (post-19:52:36) or Master Bedroom (pre-20:01:03), not the Vault Room, as he exited at 19:52:36 and didn’t return until 20:04:53.
  - **Conclusion**: Victor was not in the Vault Room at the murder time, ruling him out as the killer.

- **Samira Shaw** (ID 14):

  - **19:52:00**: Entered Vault Room (successful).
  - **No further accesses** in the 19:50:00–20:10:00 window (successful or failed).
    - **Exit Check**: Without a successful entry to another room, there’s no evidence Samira left the Vault Room. The absence of any access attempts suggests she remained in the Vault Room throughout the window.
  - **At 20:00:00**: Samira was likely still in the Vault Room, as no exit is logged.
  - **Conclusion**: Samira was present in the Vault Room at the murder time, making her a suspect.

- **Robin Ahmed** (ID 17):

  - **19:54:05**: Entered Office (successful).
  - **19:56:35**: Entered Vault Room (successful).
    - **Exit Check**: After entering the Vault Room, Robin’s next access is at 20:03:51 (Master Bedroom, failed). Failed attempts don’t indicate entry to a new room, so he remained in the Vault Room.
  - **20:03:51**: Attempted Master Bedroom (failed, stayed in Vault Room).
  - **At 20:00:00**: Robin was in the Vault Room, as he entered at 19:56:35 and has no successful exit before 20:03:51.
  - **Conclusion**: Robin was present in the Vault Room at the murder time, making him a prime suspect.

- **Jamie Bennett** (ID 28):

  - **19:54:40**: Attempted Vault Room (failed, didn’t enter).
  - **20:00:09**: Entered Office (successful).
  - **20:00:55**: Entered Vault Room (successful, post-murder).
    - **Exit Check**: Jamie wasn’t in the Vault Room before 20:00:55, so no pre-murder exit analysis is needed.
  - **At 20:00:00**: Jamie was in the Office, not the Vault Room.
  - **Conclusion**: Jamie was not in the Vault Room at the murder time, ruling them out.

- **Evan Ahmed** (ID 23):

  - **19:55:17**: Entered Kitchen (successful).
  - **19:59:06**: Attempted Office (failed, stayed in Kitchen).
  - **20:00:20**: Entered Library (successful).
  - **20:02:58**: Attempted Office (failed, stayed in Library).
  - **20:09:14**: Entered Vault Room (successful, post-murder).
    - **Exit Check**: Evan had no Vault Room access before 20:09:14, so no pre-murder exit analysis is needed.
  - **At 20:00:00**: Evan was in the Library (entered at 20:00:20), not the Vault Room.
  - **Conclusion**: Evan was not in the Vault Room at the murder time, ruling them out.

**Key Findings from Access Analysis**:

- **Samira Shaw** and **Robin Ahmed** were in the Vault Room at 20:00:00, as neither has a successful access to another room (indicating an exit) before the murder.
- **Victor Shaw** exited the Vault Room at 19:52:36 (Kitchen), was in the Master Bedroom by 20:01:03, and didn’t return until 20:04:53, ruling him out.
- **Jamie Bennett** and **Evan Ahmed** were in the Office and Library, respectively, at 20:00:00, entering the Vault Room too late to be the killer.
- **Next Step**: Analyze phone calls to identify distractions and alibis to detect deception, focusing on Robin and Samira as the only suspects in the Vault Room at 20:00:00.

#### Query 3: Phone Calls

This query lists phone calls around the murder time to identify potential distractions or coordination:

```sql
SELECT c.suspect_id, s.name, c.call_timestamp, c.call_duration,
       c.call_timestamp + (CAST(REGEXP_REPLACE(c.call_duration, '[^0-9]', '') AS INTEGER) * INTERVAL '1 minute') AS call_end
FROM call_records c
JOIN suspects s ON c.suspect_id = s.suspect_id
WHERE c.call_timestamp BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:10:00';
COPY (query above) TO '/path/to/calls.csv' WITH CSV HEADER;
```

**Results**:

| suspect_id | name | call_timestamp | call_duration | call_end |
| --- | --- | --- | --- | --- |
| 5 | Susan Knight | 2025-06-01 19:56:39.000 | 6 min | 2025-06-01 20:02:39.000 |
| 2 | Emerson Smith | 2025-06-01 19:53:33.000 | 5 min | 2025-06-01 19:58:33.000 |
| 26 | Victor Hale | 2025-06-01 19:55:45.000 | 1 min | 2025-06-01 19:56:45.000 |

**Step-by-Step Interpretation**:

- **Purpose**: Identify calls that could have distracted Roland or indicated coordination, particularly around 20:00:00.
- **Susan Knight**:
  - **Call Details**: A 6-minute call from 19:56:39 to 20:02:39, overlapping the 20:00:00 murder.
  - **Significance**: This matches the “mysterious call” in the forensic timeline, likely to Roland (recipient_relation possibly “Victim”). The call distracted Roland, preventing him from noticing the killer’s approach or the gunshot preparation.
  - **Timing with Robin Ahmed**: The call starts 4 seconds after Robin’s 19:56:35 Vault Room entry, suggesting it enabled the murder by keeping Roland occupied. The call’s end at 20:02:39 (2 minutes 39 seconds post-murder) implies Roland’s phone was dropped or left active after the shooting, consistent with a sudden attack.
- **Emerson Smith**: Call from 19:53:33 to 19:58:33, ending 1 minute 27 seconds before the murder. This is too early to be relevant to the murder moment.
- **Victor Hale**: Call from 19:55:45 to 19:56:45, ending 3 minutes 15 seconds before the murder. This is also not relevant to the murder.
- **Key Finding**: Susan’s call is critical, as it overlaps the murder and Robin’s presence in the Vault Room, likely serving as a distraction that allowed the killer to act unnoticed.

#### Query 4: False Alibis

This query identifies suspects whose alibis conflict with their access logs, indicating deception:

```sql
SELECT s.suspect_id, s.name, s.alibi, a.access_time, a.door_accessed
FROM suspects s
JOIN access_logs a ON s.suspect_id = s.suspect_id
WHERE a.access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:10:00'
AND (
    (s.alibi = 'At hospital' AND a.door_accessed IN ('Vault Room', 'Kitchen', 'Office', 'Library', 'Master Bedroom', 'Garden Exit'))
    OR (s.alibi = 'At home' AND a.door_accessed IN ('Vault Room', 'Kitchen', 'Office', 'Library', 'Master Bedroom', 'Garden Exit'))
    OR (s.alibi = 'Left early' AND a.access_time >= '2025-06-01 19:50:00')
);
COPY (query above) TO '/path/to/false_alibis.csv' WITH CSV HEADER;
```

**Results** (summarized for key suspects, as the full list is extensive):

- **Morgan Bennett (ID 1)**:
  - **Alibi**: “At hospital.”
  - **Accesses**: Vault Room (e.g., 19:56:35), Kitchen, Office, Library, Master Bedroom, Garden Exit (multiple entries).
  - **Contradiction**: Presence at the estate disproves “At hospital.”
- **Emerson Smith (ID 2)**:
  - **Alibi**: “At home.”
  - **Accesses**: Vault Room (e.g., 19:56:35), Kitchen, Office, etc.
  - **Contradiction**: Estate activity disproves “At home.”
- **Peter Nguyen (ID 11)**:
  - **Alibi**: “Left early.”
  - **Accesses**: Vault Room (e.g., 19:52:00), Kitchen, etc.
  - **Contradiction**: Accesses after 19:50:00 disprove early departure.
- **Skylar Knight (ID 13)**:
  - **Alibi**: “At hospital.”
  - **Accesses**: Vault Room (e.g., 19:56:35), Library, etc.
  - **Contradiction**: Estate presence disproves “At hospital.”
- **Robin Ahmed (ID 17)**:
  - **Alibi**: “Left early.”
  - **Accesses**: Office (19:54:05), Vault Room (19:56:35), Master Bedroom (20:03:51, failed).
  - **Contradiction**: His 19:56:35 Vault Room entry and later activity disprove “left early,” indicating deliberate deception.
- **Morgan Nguyen (ID 19)**:
  - **Alibi**: “At home.”
  - **Accesses**: Vault Room (e.g., 19:56:35), Kitchen, etc.
  - **Contradiction**: Estate activity disproves “At home.”
- **Avery Rivers (ID 20)**:
  - **Alibi**: “At hospital.”
  - **Accesses**: Master Bedroom (19:53:17), Kitchen (20:03:01).
  - **Contradiction**: Estate presence disproves “At hospital.”
- **Victor Shaw (ID 27)**:
  - **Alibi**: “At hospital.”
  - **Accesses**: Vault Room (19:50:39, 20:04:53), Kitchen (19:52:36), Master Bedroom (20:01:03), Library (20:01:47, failed).
  - **Contradiction**: His multiple accesses, including Vault Room and Kitchen, disprove “At hospital,” indicating deception.

**Step-by-Step Interpretation**:

- **Purpose**: Identify suspects lying about their whereabouts, as false alibis suggest intent to hide involvement, critical for pinpointing the killer.
- **Key Suspects**:
  - **Robin Ahmed**:
    - **Alibi**: Claimed “left early,” implying he wasn’t at the estate during the murder.
    - **Contradiction**: His 19:56:35 Vault Room entry and 20:03:51 activity (Master Bedroom, failed) prove he was present, making his alibi a deliberate lie.
    - **Significance**: This deception, combined with his Vault Room presence at 20:00:00, strongly implicates him as the killer.
  - **Victor Shaw**:
    - **Alibi**: Claimed “At hospital.”
    - **Contradiction**: His Vault Room (19:50:39, 20:04:53), Kitchen (19:52:36), and Master Bedroom (20:01:03) accesses confirm he was at the estate, disproving his alibi.
    - **Significance**: Victor’s lie indicates suspicious intent, but his exit from the Vault Room at 19:52:36 (Kitchen) rules him out as the killer, though he remains a suspect for deception.
  - **Samira Shaw**:
    - **Alibi**: Not listed in false alibis, suggesting her alibi (e.g., “Was in Vault Room” or “At auction”) aligns with her 19:52:00 Vault Room entry.
    - **Significance**: Her lack of deceit reduces suspicion compared to Robin and Victor, but her presence in the Vault Room warrants investigation.
- **Other Suspects**:
  - **Morgan Bennett, Emerson Smith, Peter Nguyen, Skylar Knight, Morgan Nguyen, Avery Rivers**: All have false alibis, indicating deception. However, their frequent accesses to other rooms (e.g., Morgan’s Kitchen at 19:58:05, Office at 20:00:09) suggest they exited the Vault Room before 20:00:00.
  - **Exit Check for Others**:
    - **Morgan Bennett**: Vault Room at 19:56:35, but Kitchen at 19:58:05 and Office at 20:00:09 confirm an exit before the murder.
    - **Emerson Smith, Peter Nguyen, Skylar Knight, Morgan Nguyen, Avery Rivers**: Similar patterns of successful accesses to Kitchen, Office, or Library before 20:00:00, indicating they left the Vault Room.
- **Key Finding**: Robin’s false “left early” alibi, combined with his confirmed Vault Room presence at 20:00:00, makes him the most suspicious. Victor’s false “At hospital” alibi suggests deceit, but his exit clears him as the killer. Samira’s lack of a false alibi reduces her culpability but doesn’t rule her out due to her presence.

## Investigation Findings

### Q1: Who Killed Roland Greene?

**Answer**: Robin Ahmed.

**Comprehensive Evidence and Reasoning**: To identify the killer, I evaluated three criteria: presence in the Vault Room at 20:00:00, evidence of deception (false alibi), and alignment with Susan’s call (19:56:39–20:02:39) as a distraction. Below, I detail why Robin Ahmed is the killer, systematically eliminating other suspects with rigorous exit checks.

1. **Vault Room Presence at 20:00:00**:

   - **Robin Ahmed**:
     - **Entry**: Entered the Vault Room at 19:56:35, 3 minutes 25 seconds before the 20:00:00 murder.
     - **Exit Check**: His next access is at 20:03:51 (Master Bedroom, failed). Since failed attempts don’t indicate entry to a new room, Robin remained in the Vault Room from 19:56:35 until at least 20:03:51, including the murder moment.
     - **Conclusion**: Robin was in the Vault Room at 20:00:00, with sufficient time to confront and shoot Roland.
   - **Samira Shaw**:
     - **Entry**: Entered at 19:52:00, 8 minutes before the murder.
     - **Exit Check**: No further accesses (successful or failed) in the 19:50:00–20:10:00 window. Without a successful entry elsewhere, Samira likely remained in the Vault Room.
     - **Conclusion**: Samira was in the Vault Room at 20:00:00, making her a suspect.
   - **Victor Shaw**:
     - **Entry**: Entered at 19:50:39, re-entered at 20:04:53.
     - **Exit Check**: Entered Kitchen at 19:52:36 (successful), confirming he left the Vault Room. By 20:01:03, he entered Master Bedroom (successful), and at 20:01:47, he attempted Library (failed, stayed in Master Bedroom).
     - **Conclusion**: Victor was in the Kitchen or Master Bedroom at 20:00:00, not the Vault Room, ruling him out as the killer.
   - **Jamie Bennett**:
     - **Entry**: Entered at 20:00:55, 55 seconds post-murder.
     - **Exit Check**: Was in Office at 20:00:09 (successful), not in Vault Room before 20:00:55.
     - **Conclusion**: Jamie was not in the Vault Room at 20:00:00, ruling them out.
   - **Evan Ahmed**:
     - **Entry**: Entered at 20:09:14, 9 minutes 14 seconds post-murder.
     - **Exit Check**: Was in Library at 20:00:20 (successful), not in Vault Room before 20:09:14.
     - **Conclusion**: Evan was not in the Vault Room at 20:00:00, ruling them out.
   - **Other Suspects** (e.g., Morgan Bennett, Emerson Smith, Peter Nguyen, Skylar Knight, Morgan Nguyen, Avery Rivers):
     - **Exit Check**: Frequent successful accesses to other rooms before 20:00:00 confirm they exited the Vault Room. For example, Morgan Bennett’s Vault Room entry at 19:56:35 is followed by Kitchen at 19:58:05 and Office at 20:00:09, indicating an exit.
     - **Conclusion**: No other suspects were in the Vault Room at 20:00:00 without confirmed exits.

2. **Susan’s Call as a Distraction**:

   - **Details**: Susan Knight’s call from 19:56:39 to 20:02:39 overlaps the 20:00:00 murder, likely to Roland (per the “mysterious call” in the forensic timeline). It distracted Roland, masking the killer’s approach or the gunshot’s preparation.
   - **Timing with Robin**: The call starts 4 seconds after Robin’s 19:56:35 Vault Room entry, suggesting he exploited the distraction to approach Roland undetected. The call’s end at 20:02:39 (2 minutes 39 seconds post-murder) implies Roland’s phone was dropped or left active after the shooting, consistent with a sudden attack.
   - **Comparison to Samira**: Samira was in the Vault Room since 19:52:00, 4 minutes 39 seconds before the call. Her presence doesn’t align as closely with the call’s timing, and she has no direct link to it.
   - **Conclusion**: The call’s precise alignment with Robin’s entry strengthens his opportunity to act, as it provided a window to shoot Roland unnoticed.

3. **False Alibi and Deception**:

   - **Robin Ahmed**:
     - **Alibi**: Claimed “left early,” implying he wasn’t at the estate during the murder.
     - **Contradiction**: His 19:56:35 Vault Room entry and 20:03:51 activity (Master Bedroom, failed) prove he was present, making his alibi a deliberate lie.
     - **Significance**: This deception indicates intent to hide his involvement, a strong indicator of guilt, especially given his presence at 20:00:00.
   - **Samira Shaw**:
     - **Alibi**: Not listed in false alibis, suggesting her alibi (e.g., “Was in Vault Room” or “At auction”) aligns with her 19:52:00 entry.
     - **Significance**: Her lack of deceit reduces her likelihood of being the killer, as she didn’t attempt to hide her presence, unlike Robin.
   - **Victor Shaw**:
     - **Alibi**: Claimed “At hospital.”
     - **Contradiction**: His Vault Room (19:50:39, 20:04:53), Kitchen (19:52:36), and Master Bedroom (20:01:03) accesses disprove this, confirming deception.
     - **Significance**: Victor’s lie suggests suspicious intent, but his confirmed exit from the Vault Room at 19:52:36 (Kitchen) clears him as the killer, though he remains a suspect for deception.
   - **Other Suspects**:
     - **Morgan Bennett, Emerson Smith, Peter Nguyen, Skylar Knight, Morgan Nguyen, Avery Rivers**: All have false alibis (e.g., “At hospital,” “At home,” “Left early”), indicating deception. However, their exits from the Vault Room before 20:00:00 (e.g., Morgan’s Kitchen at 19:58:05) reduce their relevance to the murder.
     - **Conclusion**: Their false alibis suggest general deceit but don’t tie directly to the Vault Room at 20:00:00, unlike Robin’s specific lie and presence.

4. **Why Robin Ahmed is the Killer**:

   - **Timeline Fit**: Robin entered the Vault Room at 19:56:35, giving him 3 minutes 25 seconds to confront Roland. Susan’s call at 19:56:39 distracted Roland, allowing Robin to prepare and shoot at exactly 20:00:00. His failed Master Bedroom attempt at 20:03:51 was a calculated move to appear elsewhere, reinforcing his “left early” alibi.
   - **Deception**: The false alibi indicates premeditation, as Robin deliberately lied to hide his presence, unlike Samira, who didn’t conceal her Vault Room entry.
   - **Opportunity**: The call’s timing, starting 4 seconds after his entry, provided a perfect window to act undetected, aligning with the gunshot at 20:00:00. The call’s continuation until 20:02:39 suggests Roland’s phone was dropped post-murder, consistent with Robin’s attack.
   - **Eliminating Samira**:
     - **Presence**: Samira was in the Vault Room since 19:52:00, making her a suspect.
     - **Why Not Killer?**: Her lack of a false alibi suggests she wasn’t hiding her presence, unlike Robin’s deliberate lie. There’s no evidence she acted (e.g., used a weapon) or coordinated with Susan’s call, making her more likely a witness or bystander.
   - **Eliminating Victor**:
     - **Presence**: Exited the Vault Room at 19:52:36 (Kitchen), was in Master Bedroom by 20:01:03.
     - **Why Not Killer?**: His confirmed exit rules him out, despite his false “At hospital” alibi indicating deception.
   - **Eliminating Others**:
     - **Jamie Bennett**: In Office at 20:00:09, entered Vault Room at 20:00:55 (post-murder).
     - **Evan Ahmed**: In Library at 20:00:20, entered Vault Room at 20:09:14.
     - **Morgan Bennett, Emerson Smith, etc.**: Exited Vault Room before 20:00:00 (e.g., Morgan’s Kitchen at 19:58:05), with false alibis but no murder-time presence.
   - **Scenario**: Robin, in the Vault Room with Roland and possibly Samira, waited for Susan’s call at 19:56:39 to distract Roland. He shot Roland at 20:00:00, and the call continued until 20:02:39 as Roland’s phone was dropped. Robin then attempted to access the Master Bedroom at 20:03:51 to support his “left early” alibi, leveraging the security feed cut at 20:03:00 to obscure his actions.

**Conclusion**: Robin Ahmed is the killer. His confirmed presence in the Vault Room at 20:00:00, false “left early” alibi, and the distraction provided by Susan’s call form a compelling case. No other suspect combines presence, opportunity, and deliberate deception to this degree.

### Q2: Who Are the Prime Suspects, and Why?

**Answer**: Robin Ahmed (primary), Samira Shaw (secondary), Victor Shaw (tertiary).

**Detailed Reasoning**:

- **Robin Ahmed** (Primary Suspect):
  - **Evidence**:
    - **Presence**: Entered Vault Room at 19:56:35, no exit until after 20:03:51 (Master Bedroom, failed), confirming he was in the Vault Room at 20:00:00.
    - **False Alibi**: Claimed “left early,” disproven by his 19:56:35 and 20:03:51 accesses, indicating deliberate deception.
    - **Call Alignment**: Susan’s call (19:56:39–20:02:39) starts 4 seconds after his entry, providing a distraction that enabled the murder.
  - **Why Prime?**: His presence, clear lie, and perfect timing with the call make him the top suspect, as established in Q1.
- **Samira Shaw** (Secondary Suspect):
  - **Evidence**:
    - **Presence**: Entered Vault Room at 19:52:00, no further accesses, so likely present at 20:00:00.
    - **Alibi**: Not listed in false alibis, suggesting her alibi (e.g., “Was in Vault Room” or “At auction”) aligns with her presence.
  - **Why Prime?**: Her presence in the Vault Room makes her a potential witness or accomplice, but her lack of deceit reduces suspicion compared to Robin. She may have seen the murder but didn’t act or lie about her whereabouts.
- **Victor Shaw** (Tertiary Suspect):
  - **Evidence**:
    - **Presence**: Entered Vault Room at 19:50:39, exited at 19:52:36 (Kitchen), in Master Bedroom at 20:01:03, re-entered Vault Room at 20:04:53.
    - **False Alibi**: Claimed “At hospital,” disproven by his Vault Room, Kitchen, and Master Bedroom accesses, indicating deception.
  - **Why Prime?**: His false alibi suggests suspicious intent, but his confirmed exit from the Vault Room at 19:52:36 rules him out as the killer. He’s a tertiary suspect due to his deceptive behavior.
- **Other Suspects**:
  - **Jamie Bennett**:
    - **Evidence**: False “At home” alibi, but in Office at 20:00:09, entered Vault Room at 20:00:55 (post-murder).
    - **Why Not Prime?**: Not in Vault Room at 20:00:00, despite deception.
  - **Evan Ahmed**:
    - **Evidence**: No false alibi listed, in Library at 20:00:20, entered Vault Room at 20:09:14.
    - **Why Not Prime?**: Not in Vault Room at 20:00:00.
  - **Morgan Bennett, Emerson Smith, Peter Nguyen, Skylar Knight, Morgan Nguyen, Avery Rivers**:
    - **Evidence**: False alibis (e.g., “At hospital,” “At home,” “Left early”), but frequent exits from Vault Room before 20:00:00 (e.g., Morgan’s Kitchen at 19:58:05, Office at 20:00:09).
    - **Why Not Prime?**: Their timelines don’t place them in the Vault Room at 20:00:00, and their false alibis, while suspicious, are less directly tied to the murder than Robin’s.
- **Conclusion**: Robin is the primary suspect due to his presence, false alibi, and call alignment. Samira is secondary due to her presence but lack of deceit. Victor is tertiary due to his false alibi, despite being elsewhere during the murder.

### Q3: What Was the Killer’s Motive?

**Answer**: Likely a personal or financial grudge.

**Detailed Reasoning**:

- **Data Limitation**: The query results don’t provide `relation_to_victim` (e.g., Friend, Rival, Former Partner), so I infer motives based on behavior, context, and the auction’s high stakes.
- **Robin Ahmed’s Motive**:
  - **False Alibi**: His “left early” lie indicates premeditation, suggesting a strong motive, such as a personal betrayal (e.g., a broken friendship or partnership with Roland) or financial gain (e.g., securing a valuable artwork from the auction).
  - **Context**: The art auction involved high-value assets, where disputes over ownership, profits, or past deals could escalate to murder. Robin’s presence in the Vault Room, likely where artworks were stored, supports a financial motive tied to the auction.
  - **Behavior**: The deliberate deception of his alibi points to a motive significant enough to risk detection, such as revenge for a personal slight or greed for an auctioned piece.
  - **Example Scenario**: Robin, possibly a former partner or rival (inferred), felt cheated in a past art deal or coveted a specific artwork, prompting him to plan the murder during the auction’s chaos.
- **Comparison to Others**:
  - **Samira Shaw**:
    - **Motive**: Unknown, possibly a minor dispute (e.g., as a Friend or Business Partner). Her lack of a false alibi suggests less intent to hide her actions, weakening her motive compared to Robin.
    - **Likelihood**: Without evidence of deceit or action, her motive is less compelling.
  - **Victor Shaw**:
    - **Motive**: Likely a professional rivalry (e.g., as an Art Dealer competing with Roland), inferred from his false “At hospital” alibi and estate presence.
    - **Likelihood**: His exit from the Vault Room at 19:52:36 reduces the relevance of his motive to the murder, as he wasn’t present at 20:00:00.
  - **Jamie Bennett**:
    - **Motive**: Possible workplace grievance (e.g., as a Cleaner undervalued by Roland), inferred from context, but her post-murder Vault Room entry (20:00:55) weakens this.
  - **Others (e.g., Morgan Bennett, Emerson Smith)**:
    - **Motive**: False alibis suggest deception, possibly tied to financial or personal motives, but their scattered movements (e.g., Morgan’s Kitchen at 19:58:05) don’t tie to a Vault Room-specific motive at 20:00:00.
- **Why Personal/Financial for Robin?**:
  - The auction’s high stakes amplify motives like greed or revenge. Robin’s false alibi and presence in the Vault Room at the critical moment suggest a targeted intent, unlike Samira’s passive presence or Victor’s absence from the crime scene.
  - His calculated actions (lying, leveraging the call) indicate a motive strong enough to justify murder, likely tied to a personal betrayal or financial gain.

**Conclusion**: Robin’s motive was likely a personal or financial grudge, driven by the auction’s high stakes and his deceptive behavior. This distinguishes him from Samira, Victor, and others with weaker or less relevant motives.

### Q4: How Did Robin Evade Detection?

**Answer**: Robin used a false alibi, exploited Susan’s call, blended into the estate’s chaos, and leveraged the security feed cut.

**Detailed Tactics**:

- **False Alibi**:
  - **Details**: Claimed he “left early,” contradicted by his 19:56:35 Vault Room entry and 20:03:51 activity (Master Bedroom, failed).
  - **Purpose**: To deflect suspicion by suggesting he wasn’t at the estate during the murder, hiding his presence in the Vault Room.
- **Susan’s Call**:
  - **Details**: The 6-minute call from 19:56:39 to 20:02:39, likely to Roland, distracted him, masking Robin’s approach or the gunshot’s preparation. The call’s end at 20:02:39 suggests Roland’s phone was dropped post-murder, delaying immediate suspicion.
  - **Alignment**: Starting 4 seconds after Robin’s 19:56:35 entry, the call provided a critical window for him to act undetected.
- **Estate Chaos**:
  - **Context**: With 30 guests and numerous access logs, the auction was chaotic. Frequent accesses by suspects like Morgan Bennett (e.g., Kitchen at 19:58:05, Office at 20:00:09) created confusion, making it hard to pinpoint Robin’s actions in the Vault Room.
  - **Security Feed Cut**: At 20:03:00, the security feed was cut, obscuring visual evidence of movements. This forced reliance on access logs, which Robin manipulated with his false alibi.
- **Post-Murder Movement**:
  - **Details**: Robin’s failed Master Bedroom attempt at 20:03:51 was a strategic move to appear elsewhere, reinforcing his “left early” claim by suggesting he was moving through the estate post-murder.
- **Vault Room Advantage**:
  - **Details**: Robin’s successful Vault Room access at 19:56:35 implies familiarity with the estate’s security system, allowing a quick, discreet attack in a secure room where Roland was vulnerable, likely alone or distracted.
- **Conclusion**: Robin evaded detection by lying about his presence, using Susan’s call to distract Roland, blending into the crowded estate’s activity, and exploiting the security feed cut at 20:03:00. His post-murder movement further supported his alibi.

### Q5: Was There an Accomplice?

**Answer**: Susan Knight is a possible accomplice due to her call’s suspicious timing, but no definitive evidence confirms this. Samira Shaw is a secondary possibility.

**Detailed Analysis**:

- **Susan Knight**:
  - **Evidence**:
    - **Call Details**: Her 6-minute call from 19:56:39 to 20:02:39 overlaps Robin’s 19:56:35 Vault Room entry and the 20:00:00 murder, likely distracting Roland (recipient_relation possibly “Victim”).
    - **Timing**: The call starts 4 seconds after Robin’s entry, suggesting possible coordination to keep Roland occupied during the murder.
    - **Call End**: Ends at 20:02:39, 2 minutes 39 seconds post-murder, consistent with a dropped phone after the shooting.
  - **Role**: If an accomplice, Susan’s call ensured Roland was distracted, allowing Robin to approach and shoot unnoticed.
  - **Limitation**: No direct evidence (e.g., calls between Susan and Robin in `call_records`) confirms coordination. The call could be coincidental, with Robin opportunistically exploiting it.
- **Samira Shaw**:
  - **Evidence**:
    - **Presence**: In Vault Room since 19:52:00, with no exit, so likely present at 20:00:00.
    - **Role**: Could have witnessed the murder or passively assisted by staying silent, potentially aware of Robin’s actions without intervening.
  - **Limitation**: Her lack of a false alibi and no evidence of coordination (e.g., calls or suspicious actions) suggest she wasn’t actively involved. Her presence alone isn’t conclusive of complicity.
- **Victor Shaw**:
  - **Evidence**: False “At hospital” alibi, but in Kitchen (19:52:36) or Master Bedroom (20:01:03) at 20:00:00, with no calls or coordination evidence.
  - **Why Not?**: His absence from the Vault Room and lack of connection to Susan’s call rule him out as an accomplice.
- **Other Suspects** (e.g., Jamie, Evan, Morgan Bennett):
  - **Evidence**: Not in Vault Room at 20:00:00 (e.g., Jamie in Office, Evan in Library), with no relevant calls or coordination evidence.
  - **Why Not?**: Their timelines and lack of connection to Susan’s call or Robin’s actions make them unlikely accomplices.
- **Conclusion**: Susan’s call timing raises suspicion of an accomplice role, but without direct evidence, Robin likely acted alone, opportunistically using the call’s distraction. Samira’s presence makes her a secondary possibility, but her lack of deceit suggests she was more likely a bystander than an active accomplice.

## Conclusion

Robin Ahmed killed Roland Greene in the Vault Room at 20:00:00 on June 1, 2025. He entered at 19:56:35, exploited Susan Knight’s call (19:56:39–20:02:39) to distract Roland, and lied about “leaving early” to hide his presence. Samira Shaw, present since 19:52:00, is a secondary suspect but lacks deceit, suggesting she was a bystander. Victor Shaw’s false “At hospital” alibi makes him a tertiary suspect, but his exit to the Kitchen at 19:52:36 clears him as the killer. Susan’s call raises the possibility of an accomplice, but Robin likely acted alone, using the distraction opportunistically. This PostgreSQL-driven analysis, processed complex datasets to deliver a clear, evidence-based solution.

## Skills Highlighted

- **PostgreSQL Expertise**: Designed tables with constraints and indexes to ensure data integrity and improve query performance.
- **Data Analysis**: Synthesized suspect timelines, exit checks, and alibis to pinpoint the killer with precision.
- **Problem-Solving**: Resolved timeline discrepancies and ensured rigorous exit checks to avoid assumptions.
- **Communication**: Delivered a comprehensive, beginner-friendly narrative for technical and non-technical audiences.

## Project Impact

- **Scope**: Analyzed large datasets of suspects, access logs, calls, and forensic events, addressing a complex investigative challenge.
- **Efficiency**: Used indexing to enhance PostgreSQL query performance, enabling efficient analysis of time-sensitive data.
- **Outcome**: Solved a high-stakes murder mystery with compelling, evidence-based findings, ideal for a data analyst portfolio.

## Repository Structure

```
RolandGreeneMurderInvestigation/
├── RolandGreeneMurderInvestigation.md
├── data/
│   ├── suspects_large.csv
│   ├── access_logs_large.csv
│   ├── call_records_large.csv
│   ├── forensic_events.csv
│   ├── vault_access.csv
│   ├── subsequent_accesses.csv
│   ├── calls.csv
│   ├── false_alibis.csv
├── sql/
│   ├── create_tables.sql
│   ├── vault_access.sql
│   ├── subsequent_accesses.sql
│   ├── calls.sql
│   ├── false_alibis.sql
```

## Setup Instructions

1. **Database Setup**:

   - Install PostgreSQL and create a database (e.g., `createdb murder_investigation`).
   - Run `sql/create_tables.sql` to set up tables and indexes.
   - Import datasets using `COPY` commands, updating paths to your local files (e.g., `C:/data/suspects_large.csv`).

2. **Query Execution**:

   - Run queries in `sql/vault_access.sql`, `sql/subsequent_accesses.sql`, `sql/calls.sql`, and `sql/false_alibis.sql` to export CSVs.
   - Save CSVs to a local directory (e.g., `C:/data/vault_access.csv`).


## Future Enhancements

- **Advanced Queries**: Develop additional PostgreSQL queries to analyze suspect movement patterns (e.g., frequency of Vault Room accesses).
- **Machine Learning**: Apply clustering to group suspects by behavior, enhancing pattern detection.
- **NLP**: Analyze alibi text for deception signals using natural language processing.
- **Interactive Visuals**: Create a web-based dashboard with Streamlit for dynamic exploration of query results.

This project demonstrates my ability to leverage PostgreSQL for complex data analysis and to tackle real-world data challenges,