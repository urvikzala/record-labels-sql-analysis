-- Question 2: Streams per Mapped Artist
-- Divides each label's total streams by its number of mapped artists
-- to get a streams-per-artist figure, so raw totals don't just favor
-- whichever label happens to have more artists in the sample. This
-- is a streams metric only -- there's no cost or revenue data here,
-- so it isn't a measure of financial efficiency.

SELECT 
    r.record_label,
    COUNT(DISTINCT s.Artist) AS total_artists,
    SUM(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) AS total_streams,
    SUM(CAST(REPLACE(s."Spotify Streams", ',', '') AS INTEGER)) / 
    COUNT(DISTINCT s.Artist) AS streams_per_artist
FROM spotify_streams s
JOIN record_labels r ON s.Artist = r.artist_name
GROUP BY r.record_label
ORDER BY streams_per_artist DESC;
