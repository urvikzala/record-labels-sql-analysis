-- Question 1: Who Built the Streaming Empire?
-- Splits each label's total Spotify streams into pre-2020 (legacy)
-- and 2020-onward (new) releases, using SUM with a CASE expression
-- on the year extracted from the text-formatted Release Date column.

SELECT 
    r.record_label,
    SUM(CASE WHEN SUBSTR(s."Release Date", -4) >= '2020' 
        THEN CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER) 
        ELSE 0 END) AS new_streams,
    SUM(CASE WHEN SUBSTR(s."Release Date", -4) < '2020' 
        THEN CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER) 
        ELSE 0 END) AS legacy_streams
FROM spotify_streams s
JOIN record_labels r ON s.Artist = r.artist_name
GROUP BY r.record_label
ORDER BY new_streams DESC;
