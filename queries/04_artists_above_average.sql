-- Question 4: Who's Carrying the Label?
-- Compares each artist's average streams per song against their own
-- label's baseline average. The CTE below calculates each label's
-- average directly from the data, so this updates automatically if
-- the underlying data changes -- no hardcoded numbers to go stale.

WITH label_averages AS (
    SELECT
        r.record_label,
        AVG(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) AS label_avg_streams
    FROM spotify_streams s
    JOIN record_labels r ON s.Artist = r.artist_name
    GROUP BY r.record_label
)
SELECT
    s.Artist,
    r.record_label,
    AVG(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) AS artist_avg_streams,
    la.label_avg_streams,
    ROUND(AVG(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) / la.label_avg_streams * 100, 2) AS pct_of_label_avg
FROM spotify_streams s
JOIN record_labels r ON s.Artist = r.artist_name
JOIN label_averages la ON r.record_label = la.record_label
GROUP BY s.Artist, r.record_label, la.label_avg_streams
HAVING artist_avg_streams > la.label_avg_streams
ORDER BY pct_of_label_avg DESC
LIMIT 15;
