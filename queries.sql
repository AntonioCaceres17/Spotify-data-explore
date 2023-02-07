use group20;

-- What 5 songs are most frequently found in the playlits 
select track_name, count(playlist_tracks.track_id) as num_playlists
from track 
join playlist_tracks using(track_id)
group by track_id
order by num_playlists desc
limit 5;

-- What genre of songs are usually the longest?
select genre_name, avg(duration) as avg_length
from track 
join track_artist using (track_id) 
join artist using (artist_id) 
join artist_genre using(artist_id) 
join genre using (genre_id)
group by genre_name
order by avg_length desc
limit 5;

-- Which artists have the most popular songs?
select artist_name, avg(popularity)
from track
join track_artist using (track_id)
join artist using (artist_id)
group by artist_name
having count(distinct track_id) > 5
order by avg(popularity) desc
limit 5;


-- What is the average popularity of songs of different genres?
select genre_name, avg(popularity) as `avg_popularity`, count(track_id) as `track_count`
from track
join track_artist using (track_id)
join artist using (artist_id)
join artist_genre using(artist_id)
join genre using (genre_id)
group by genre_name
having track_count > 1000
order by avg_popularity desc
limit 10;



-- Which genres have the most popular songs?
select genre_name, popularity
from track
join track_artist using (track_id)
join artist using (artist_id)
join artist_genre using(artist_id)
join genre using (genre_id)
order by popularity desc
limit 5;

-- Which tracks are the most popular?
select track_name, artist_name, popularity
from track
join track_artist using(track_id)
join artist using(artist_id)
order by popularity desc
limit 5;



-- What albums have the highest average popularity for their songs?
select album_name, artist_name, avg(popularity) AS avg_popularity
from album
join album_artist using(album_id)
join artist using(artist_id)
join track using(album_id)
where num_tracks > 1
group by album_name, artist_name
order by avg_popularity desc
limit 5;


-- what are the audio features of the most popular songs? are they more danceable, lively, etc
-- next 3 kinda the same w diff audio features

	-- Avg dancibility of top 50 popular songs 

with popular_songs as (select track_name, artist_name, popularity, track_id
	from track
	join track_artist using(track_id)
	join artist using(artist_id)
	order by popularity desc
	limit 50)
select avg(danceability) as avg_dancibility_of_popular_songs
from popular_songs join audio_features using (track_id);

	-- Avg energy of top 50 popular songs 

with popular_songs as (select track_name, artist_name, popularity, track_id
	from track
	join track_artist using(track_id)
	join artist using(artist_id)
	order by popularity desc
	limit 50)
select avg(energy) as avg_energy_of_popular_songs
from popular_songs join audio_features using (track_id);

	-- Avg liveness of top 50 popular songs 

with popular_songs as (select track_name, artist_name, popularity, track_id
	from track
	join track_artist using(track_id)
	join artist using(artist_id)
	order by popularity desc
	limit 50)
select avg(liveness) as avg_liveness_of_popular_songs
from popular_songs join audio_features using (track_id);

-- how loud do the popular songs tend to be? 
-- Avg loudness of top 50 popular songs 

with popular_songs as (select track_name, artist_name, popularity, track_id
	from track
	join track_artist using(track_id)
	join artist using(artist_id)
	order by popularity desc
	limit 50)
select avg(loudness) as avg_loudness_of_popular_songs
from popular_songs join audio_features using (track_id);

-- which genre tend to have songs with the most energy?
-- Notes: genre is linked to an artist, so which artists tend to have the most popular songs, then what genre are those songs in.

with pop_artists as (select artist_name, popularity, artist_id
	from track
	join track_artist using (track_id)
	join artist using (artist_id)
	group by artist_name, popularity, artist_id
	order by popularity desc
	limit 50)
select genre_name, avg(popularity) as avg_popularity
from pop_artists
join artist_genre using (artist_id) 
join genre using (genre_id)
group by genre_name
order by avg_popularity;

-- how many playlists do the most popular tracks appear on?
select track_name, popularity, count(pid)
from playlist_tracks join track using (track_id)
where pid in (select track_id
from track
join audio_features using(track_id)
where popularity > 10)
group by track_name
order by popularity desc;



-- how many of the most popular tracks include more than one artist?
select track_name, popularity, count(artist_id) as `artists`
from track
join track_artist using (track_id)
group by track_name, popularity
having artists > 1
order by popularity desc;



-- what is the average number of tracks on a playlist?
select avg(tracks)
from (select pid, count(track_id) as `tracks`
from playlist_tracks
join playlist using(pid)
group by pid) tmp;




-- how many artists are categorized under more than one genre?
select artist_name, count(genre_id) as `genres`
from artist
join artist_genre using(artist_id)
join genre using (genre_id)
group by artist_id
having genres > 1;

-- duration and popularity of tracks on Spotify-generated playlists
select
    duration,
    popularity
from track join playlist_tracks using (track_id)
	join playlist using (pid)
	join user_playlist using (pid)
where user_id = 1;

-- duration and popularity of tracks on user-generated playlists
select
    duration,
    popularity
from track join playlist_tracks using (track_id)
	join playlist using (pid)
    left join user_playlist using (pid)
where user_id is null;


-- average audio metrics from Spotify playlists
select
	avg(danceability),
    avg(acousticness),
    avg(energy),
    avg(liveness)
from audio_features join track using (track_id)
	join playlist_tracks using (track_id)
    join playlist using (pid)
	join user_playlist using (pid)
where user_id = 1;

-- average audio metrics from user playlists
select
	avg(danceability),
    avg(acousticness),
    avg(energy),
    avg(liveness)
from audio_features join track using (track_id)
	join playlist_tracks using (track_id)
    join playlist using (pid)
	left join user_playlist using (pid)
where user_id is null;

-- percent of genres on Spotify playlists
with spotify_genres as (select
    genre_name, count(genre_id) as 'genre_count'
from genre join artist_genre using (genre_id)
	join artist using (artist_id)
    join track_artist using (artist_id)
    join track using (track_id)
where track_id in
(select track_id
from playlist_tracks join playlist using (pid)
join user_playlist using (pid))
group by genre_name
order by genre_count desc)
select
	genre_name,
    genre_count * 100 / (select count(track_id) from track join playlist_tracks using (track_id)
						join playlist using (pid)
						join user_playlist using (pid)) as 'pct'
from spotify_genres
limit 10;


-- percent of genres on user playlists
with user_genres as (select
    genre_name, count(genre_id) as 'genre_count'
from genre join artist_genre using (genre_id)
	join artist using (artist_id)
    join track_artist using (artist_id)
    join track using (track_id)
where track_id in
(select track_id
from playlist_tracks join playlist using (pid)
left join user_playlist using (pid)
where user_id is null)
group by genre_name
order by genre_count desc)
select
	genre_name,
    genre_count * 100 / (select count(track_id) from track join playlist_tracks using (track_id)
						join playlist using (pid)
						left join user_playlist using (pid) where user_id is null) as 'pct'
from user_genres
limit 10;


-- percent of unique vs. duplicate artists in Spotify playlists
select
    count(distinct artist_id) / count(artist_id) * 100 as 'pct_unique',
    (count(artist_id) - count(distinct artist_id)) / count(artist_id) * 100 as 'pct_duplicate'
from artist join track_artist using (artist_id)
	join track using (track_id)
where track_id in
(select track_id
from playlist_tracks join playlist using (pid)
join user_playlist using (pid))
order by count(artist_id) desc;

-- percent of unique vs. duplicate artists in user playlists
select
    count(distinct artist_id) / count(artist_id) * 100 as 'pct_unique',
    (count(artist_id) - count(distinct artist_id)) / count(artist_id) * 100 as 'pct_duplicate'
from artist join track_artist using (artist_id)
	join track using (track_id)
where track_id in
(select track_id
from playlist_tracks join playlist using (pid)
left join user_playlist using (pid)
where user_id is null)
order by count(artist_id) desc;
