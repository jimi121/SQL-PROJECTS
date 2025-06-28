SET search_path = "Forensic Analysis";

-- Vault Room Access Analysis
-- I identified successful Vault Room entries from 7:50 PM to 8:10 PM:
SELECT 
	a.suspect_id, 
	s.name, 
	a.access_time::time
FROM access_logs a
JOIN suspects s ON a.suspect_id = s.suspect_id
WHERE a.door_accessed = 'Vault Room'
AND a.access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:10:00'
AND a.success_flag = 'True'
ORDER BY a.access_time;


-- Subsequent Access Results:
-- To verify exits, I checked subsequent access logs for these suspects:
SELECT s.name, a.access_time, a.door_accessed, a.success_flag
FROM access_logs a
JOIN suspects s ON a.suspect_id = s.suspect_id
WHERE a.access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:10:00'
AND a.suspect_id IN (
    SELECT suspect_id FROM access_logs 
    WHERE door_accessed = 'Vault Room' 
    AND access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:10:00' 
    AND success_flag = 'True'
)
ORDER BY a.access_time;

-- Phone Call Analysis
-- I examined calls to Roland from 7:50 PM to 8:10 PM:
SELECT c.suspect_id, s.name, c.call_timestamp, c.call_duration,
       (c.call_timestamp + (CAST(REPLACE(c.call_duration, 'min', '') AS INTEGER) * INTERVAL '1 minute')) AS call_end
FROM call_records c
JOIN suspects s ON c.suspect_id = s.suspect_id
WHERE c.recipient_relation = 'Victim'
AND c.call_timestamp BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:10:00';

-- False Alibi Detection
-- I identified suspects with false alibis:
SELECT s.suspect_id, s.name, s.alibi, a.access_time, a.door_accessed
FROM suspects s
JOIN access_logs a ON s.suspect_id = s.suspect_id
WHERE a.access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:10:00'
AND a.success_flag = 'True'
AND (s.alibi ILIKE '%home%' OR s.alibi ILIKE '%hospital%' OR s.alibi ILIKE '%left%')
ORDER BY s.suspect_id;
