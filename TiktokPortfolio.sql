-- Tiktok Portfolio

  SELECT
  user_name,
  n_likes,
  n_shares,
  n_comments,
  n_plays,
  country
  FROM
  tiktok_raw_top5_per_country
  WHERE country like '%us%'
  order by n_likes desc
  
-- No of video posted
  SELECT
  [user_name],
  COUNT(video_link) AS 'No of video Posted'
  FROM
  tiktok_raw_top5_per_country
  group by [user_name]
  ORDER BY COUNT(video_link) desc;

--   SELECT
--   user_name,
--   COUNT([video_id]) as Count_video
--   FROM
--   tiktok_raw_top5_per_country
--   WHERE country like '%us%'
--   group by [user_name];


-- User with the longest video

SELECT TOP (100) [user_name]
      ,Concat(max([video_length]), ' s') AS 'Longest Video'
      ,COUNT(video_id) AS 'No Of Videos Posted'
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  GROUP BY user_name
  ORDER BY MAX(video_length) DESC

--   SELECT TOP (1000) [user_name]
--       ,[user_id]
--       ,[video_id]
--       ,[video_desc]
--       ,[video_time]
--       ,[video_length]
--       ,[video_link]
--       ,[n_likes]
--       ,[n_shares]
--       ,[n_comments]
--       ,[n_plays]
--       ,[video_timestamp]
--       ,[country]
--       ,[year]
--       ,[YEAR_2]
--       ,[video_id_shortened]
--   FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
--   order by video_length DESC


-- User with Highest number of likes

SELECT TOP (100) [user_name]
      ,max([n_likes]) AS 'Highest Likes'
      ,COUNT(video_id) AS 'No Of Videos Posted'
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  GROUP BY user_name
  ORDER BY max([n_likes]) DESC

-- User with Highest number of Plays

  SELECT TOP (100) [user_name]
      ,max([n_plays]) AS 'Highest Plays'
      ,COUNT(video_id) AS 'No Of Videos Posted'
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  GROUP BY user_name
  ORDER BY max([n_plays]) DESC

-- user with the most engaged video (comments)

   SELECT TOP (1) [user_name],
   [n_comments],
   [video_link]
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  ORDER BY [n_comments] DESC

-- user with the most engaged video (likes)

   SELECT TOP (1) [user_name],
   [n_likes],
   [video_link]
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  ORDER BY [n_likes] DESC

-- Top 10 user with the most engagement based On Likes and Comments
   SELECT TOP (10) [user_name],
   [n_likes],
   [video_link],
   [n_comments],
   [n_likes] + [n_comments] AS 'Comment+likes'
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  ORDER BY [n_likes] DESC

-- user with the most engagement based On Likes and Comments

  SELECT TOP (1) [user_name],
   [n_likes],
   [n_comments],
   [n_likes] + [n_comments] AS 'Comment+likes'
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  ORDER BY [n_likes] DESC

-- Most shared videos

 SELECT TOP (10) [user_name],
   [n_shares],
   [video_link]
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  ORDER BY [n_shares] DESC

-- Earlist User to Make a Post

   SELECT TOP (1000) [user_name],
   [video_timestamp],
   [video_link]
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  ORDER BY [video_timestamp]

--   Country with the most engagement
  SELECT TOP (5000)
   max(n_likes) AS MAX_likes,
   [country]
  FROM [olamide].[dbo].[tiktok_raw_top5_per_country]
  GROUP BY [country]
  ORDER BY MAX_likes DESC
