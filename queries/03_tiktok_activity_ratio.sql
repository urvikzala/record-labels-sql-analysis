-- Question 3: The TikTok to Spotify Pipeline
-- Compares each label's total Spotify streams against its total TikTok
-- views to see how much platform activity converts across. Rows with
-- no TikTok data are excluded, and CAST AS FLOAT keeps the division
-- from rounding down to zero before it's turned into a percentage.

SELECT
    r.record_label,
    SUM(CAST(REPLACE(s."TikTok Views", ',', '') AS INTEGER)) AS total_tiktok_views,
    SUM(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) AS total_spotify_streams,
    ROUND(
        CAST(SUM(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) AS FLOAT) /
        CAST(SUM(CAST(REPLACE(s."TikTok Views", ',', '') AS INTEGER)) AS FLOAT) * 100
    , 2) AS activity_ratio_pct
FROM spotify_streams s
JOIN record_labels r ON s.Artist = r.artist_name
WHERE s."TikTok Views" IS NOT NULL
GROUP BY r.record_label
ORDER BY activity_ratio_pct DESC;
