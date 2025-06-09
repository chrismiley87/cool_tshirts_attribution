--Determine the number of distinct campaigns
SELECT COUNT(DISTINCT utm_campaign) AS num_campaigns
FROM page_visits;

--Determine the number of distinct sources
SELECT COUNT(DISTINCT utm_source) AS num_sources
FROM page_visits;

--Look at the different pairings of sources and campaigns
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

--Look at the different pages on the website
SELECT DISTINCT page_name AS page
FROM page_visits;

--Calculate the number of first touches each campaign is responsible for
WITH first_touch AS (
    SELECT user_id,
           MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id
), 
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
		     pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_campaign,
       COUNT(*) AS num_first_touches
FROM ft_attr
GROUP BY 1
ORDER BY 2 DESC;

--Calculate the number of last touches each campaign is responsible for
WITH last_touch AS (
    SELECT user_id,
           MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id
), 
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
		     pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign,
       COUNT(*) AS num_last_touches
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;

--Count the number of visitors who made a purchase
SELECT COUNT(DISTINCT user_id) AS num_purchases
FROM page_visits 
WHERE page_name = '4 - purchase';

--Count the number of last touches on the purchase page each campaign is responsible for
WITH last_touch AS (
    SELECT user_id,
           MAX(timestamp) AS last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id
), 
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
		     pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
    WHERE pv.page_name = '4 - purchase'
)
SELECT lt_attr.utm_campaign,
       COUNT(*) AS num_last_touches
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;