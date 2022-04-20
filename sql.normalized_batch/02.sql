SELECT 
    tag,
    count(*) AS count
FROM (
    SELECT DISTINCT
        data->>'id' AS id_tweets,
        '#' || (jsonb_array_elements(data->'entities'->'hashtags'
            || COALESCE(data->'extended_tweet'->'entities'->'hashtags', '[]'))->>'text') AS tag -- Self join
    FROM tweets_jsonb
    WHERE data->'entities'->'hashtags' @@ '$[*].text == "coronavirus"' 
       OR data->'extended_tweet'->'entities'->'hashtags' @@ '$[*].text == "coronavirus"' -- Get tags that mention coronavirus
) t1
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
