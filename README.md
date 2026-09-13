# Record Label Performance in Spotify's Most-Streamed Songs of 2024

*A SQL analysis of catalogue mix, artist reach, and cross-platform activity*

**Urviksinh Zala | SQL Portfolio Case Study**

| 4,600 | 1,999 | 58 | 5 |
|---|---|---|---|
| tracks | unique artists | artists mapped to record labels | business questions |

## Project Overview

I've always been into music, but the part that actually pulls me in is the business behind it: the decisions labels make about who to sign and how to develop them. So instead of just ranking who had the most streams, I wanted to answer the kind of questions a label would actually sit down and ask: how much of their performance is coming from older catalogue versus new releases, and is a viral TikTok moment actually turning into people listening on Spotify. Along the way I also wanted to see which labels were getting the most value out of the artists they already signed.

I used SQLite to explore and clean the data, then built my own artist-to-label mapping since the original dataset didn't come with one, and worked through five business questions from there. I wasn't trying to crown one label the winner so much as figure out what the numbers could actually support: where the picture was solid, and where it started to get thin.

## Data and Scope

**Spotify data.** The main dataset contains 4,600 tracks and 1,999 unique artists, along with Spotify streams and activity on platforms such as TikTok, YouTube, and Apple Music. Source: [Most Streamed Spotify Songs 2024](https://www.kaggle.com/datasets/nelgiriyewithana/most-streamed-spotify-songs-2024) (Kaggle).

**Record-label mapping.** The original dataset didn't come with record labels, so I mapped 58 of the highest-streaming artists to Universal, Sony, Warner, or Independent myself. Every label-level number in this project is really about those 58 artists, not the full 1,999, so keep that in mind as you read further.

## SQL Work

**Tools.** SQLite and DB Browser for SQLite.

**Techniques.** JOINs, GROUP BY, and the standard aggregate functions, plus COUNT(DISTINCT) for unique counts, CASE for splitting data into groups, REPLACE and CAST for cleaning up messy number columns, SUBSTR for pulling the year out of a text date, and UPDATE for fixing inconsistent label names.

**Data preparation.** I started by checking row counts and platform coverage. When MIN and MAX returned a release range that didn't look right, I traced it back to the date being stored as text and worked around it by extracting the last four characters as the year. I also stripped commas out of the stream and view columns before converting them to numbers, and standardized "Columbia (Sony)" to "Sony" so it didn't split into its own label in the results.

> **Important scope note.** The label mapping reflects each artist's current label, not necessarily who released any specific song. Older tracks might have come out under a different label at the time, so the legacy-catalogue comparison is more of a directional read than a precise accounting of who owned what back then.

## Analysis

### 1. Total Streams and Catalogue Mix

I started by comparing total Spotify streams by label, then split each label's total between releases before 2020 and releases from 2020 onward. That meant using SUM with a CASE expression on the extracted release year, joined across both tables.

| Label | Total Streams | 2020+ Releases | Pre-2020 Releases |
|---|---|---|---|
| Universal | 493,366,026,804 | 188,481,986,857 | 304,884,039,947 |
| Sony | 172,290,288,574 | 85,875,690,731 | 86,414,597,843 |
| Warner | 118,798,602,892 | 35,082,608,318 | 83,716,194,574 |
| Independent | 17,660,968,023 | 3,547,628,358 | 14,113,339,665 |

**Takeaway:** Universal leads the mapped sample by a wide margin, but **61.8% of that total comes from pre-2020 releases**. So a big chunk of their lead is really legacy catalogue doing the work. Sony was the most evenly split between old and new. That doesn't automatically mean they're better at developing new artists, but out of the four labels, their mix is the most balanced.

### 2. Streams per Mapped Artist

Total streams naturally favor labels with more artists in the sample, so I divided each label's total by its number of mapped artists to get a per-artist average. It's just a streams average, not a measure of cost or profitability. I don't have any financial data to work with here.

| Label | Mapped Artists | Total Streams | Streams per Artist |
|---|---|---|---|
| Universal | 31 | 493,366,026,804 | 15,915,033,122 |
| Warner | 10 | 118,798,602,892 | 11,879,860,289 |
| Sony | 15 | 172,290,288,574 | 11,486,019,238 |
| Independent | 2 | 17,660,968,023 | 8,830,484,011 |

**Takeaway:** Universal comes out on top here too, with the highest average streams per mapped artist. What stood out to me was that **Warner's average edges out Sony's** despite having a much smaller total. These are label-level averages across a 58-artist sample, though, so it doesn't mean every individual Warner artist is beating every individual Sony artist, just that Warner's average sits a bit higher.

### 3. Spotify-to-TikTok Activity Ratio

To compare activity across platforms, I divided Spotify streams by TikTok views and multiplied by 100, filtering out rows with missing TikTok data and casting to float before dividing. I'm calling this an activity ratio and not a conversion rate on purpose. The dataset doesn't actually link individual TikTok viewers to Spotify listeners, it's only comparing totals.

| Label | TikTok Views | Spotify Streams | Activity Ratio |
|---|---|---|---|
| Independent | 5,334,014,620 | 15,252,232,875 | 285.94% |
| Warner | 72,480,926,242 | 106,471,592,168 | 146.52% |
| Universal | 373,423,864,810 | 464,283,289,193 | 124.33% |
| Sony | 279,127,006,869 | 149,341,709,207 | 53.50% |

**Takeaway:** this was probably the most surprising result in the whole project. Independent artists have the highest ratio by a wide margin. The catch is that the independent group only has **two artists** in it, so I'm treating this as an interesting signal worth digging into later, not something I'd hang a firm conclusion about fan loyalty on yet.

### 4. Artists Above Their Label Average

I calculated the average streams per song for each label, then compared every artist's individual average against their own label's baseline. Below are the top five by percentage of label average.

| Artist | Label | Artist Avg. Streams | % of Label Avg. |
|---|---|---|---|
| The Chainsmokers | Sony | 1,705,383,853 | 214.79% |
| Arctic Monkeys | Warner | 1,982,151,858 | 213.57% |
| Harry Styles | Sony | 1,446,115,695 | 182.14% |
| Avicii | Universal | 1,391,535,248 | 178.26% |
| Ed Sheeran | Warner | 1,600,993,359 | 172.50% |

**Takeaway:** The Chainsmokers and Arctic Monkeys are the clear standouts, both landing over double their label's average. The one that actually caught my eye was **Avicii**. He passed away in 2018 and is still sitting at 178% of Universal's average. That's a pretty striking reminder of how long a strong catalogue keeps earning after an artist is gone.

### 5. Explicit vs. Non-Explicit Tracks

The dataset has 2,949 non-explicit tracks and 1,651 explicit ones. I compared the overall averages first, then joined in the label table and grouped by both label and explicit status to see if the pattern held across labels.

| Label | Non-Explicit Avg. Streams | Explicit Avg. Streams |
|---|---|---|
| Warner | 1,085,051,602 | 569,979,752 |
| Sony | 988,482,203 | 582,613,458 |
| Universal | 838,531,188 | 720,892,333 |
| Independent | 736,389,616 | 735,263,910 |

**Takeaway:** across the whole dataset, explicit and non-explicit tracks land almost exactly the same, around 448M vs. 445M average streams. Break it out by label though, and **Warner and Sony both show a real gap favoring non-explicit songs**. I'd call this an association more than anything else. There could easily be other factors this dataset just isn't capturing that are actually driving the difference.

## Business Takeaways

**Universal's scale is real, but a lot of it is legacy.** They lead on both total streams and streams per artist, but 61.8% of their total comes from pre-2020 releases.

**Sony has the most balanced release mix of any label.** Their streams are close to evenly split between old and new, though that balance doesn't carry over to their TikTok activity ratio, which is the lowest of the four.

**Warner is stronger per-artist than its totals suggest.** Its average streams per mapped artist edges out Sony's despite a much smaller catalogue overall.

**Independent needs a bigger sample before I'd trust it.** The activity ratio is the highest by far, but with only two artists mapped, I wouldn't lean on this too hard yet.

## Limitations

**Coverage.** Only 58 of the 1,999 artists here are mapped to a label, and I picked the highest-streaming ones on purpose. So the per-artist averages in this analysis are really about each label's proven top tier, not its entire roster. A label could easily have hundreds of artists who never chart at all, and this data has nothing to say about them. I also mapped everyone to their current label, which might not match who actually released their older material.

**Interpretation.** Platform totals can show that two things move together, but that's different from proving one caused the other. And streams are a measure of reach, not money. This project can't speak to revenue, cost, or what any of it means for actual profitability.

## Conclusion and Next Steps

Universal comes out ahead in this mapped sample, but total streams alone don't really tell the full story here. Catalogue age, how many artists actually got mapped, and cross-platform activity all shift that picture quite a bit. Anyone turning this into an actual business recommendation would need to take the limitations above seriously first.

### If I Expanded the Project

If I had more time, there's a few things I'd do differently. I'd map a lot more of the 1,999 artists rather than sticking to the top 58, and actually write down a consistent rule for how artists get chosen instead of picking them somewhat manually like I did here. I'd also try matching each track to whichever label released it at the time, since that would make the legacy-catalogue comparison a lot more accurate than using an artist's current label. On the TikTok side, lining up the actual measurement windows for both platforms would need to happen before I called anything close to a real conversion rate. And a small dashboard pulling together the catalogue split, the per-artist averages, and the label concentration would honestly be a lot easier to look at side by side than five separate tables.

## Repository

- `/queries`: the full .sql files for all five questions, in the order they're discussed above
- `/results`: exported CSV results for each of the five questions
- `/data`: the record_labels.csv reference table
