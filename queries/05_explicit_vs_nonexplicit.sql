-- Question 5: Does Explicit Pay Off?
-- Compares average streams for explicit vs. non-explicit tracks,
-- grouped by both label and explicit status, to see whether the
-- pattern holds consistently across all four labels.

SELECT
    r.record_label,
    "Explicit Track",
    COUNT(*) AS total_tracks,
    AVG(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) AS avg_streams
FROM spotify_streams s
JOIN record_labels r ON s.Artist = r.artist_name
GROUP BY r.record_label, "Explicit Track"
ORDER BY r.record_label, "Explicit Track";
