-- Question 4: Who's Carrying the Label?
-- Compares each artist's average streams per song against their own
-- label's baseline average (calculated separately beforehand and
-- plugged in here via CASE), keeping only artists who beat it.

SELECT
    s.Artist,
    r.record_label,
    AVG(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) AS artist_avg_streams,
    CASE r.record_label
        WHEN 'Universal' THEN 780642447
        WHEN 'Sony' THEN 793964463
        WHEN 'Warner' THEN 928115647
        WHEN 'Independent' THEN 735873667
    END AS label_avg_streams,
    ROUND(AVG(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) /
    CASE r.record_label
        WHEN 'Universal' THEN 780642447
        WHEN 'Sony' THEN 793964463
        WHEN 'Warner' THEN 928115647
        WHEN 'Independent' THEN 735873667
    END * 100, 2) AS pct_of_label_avg
FROM spotify_streams s
JOIN record_labels r ON s.Artist = r.artist_name
GROUP BY s.Artist, r.record_label
HAVING artist_avg_streams > label_avg_streams
ORDER BY pct_of_label_avg DESC
LIMIT 15;
