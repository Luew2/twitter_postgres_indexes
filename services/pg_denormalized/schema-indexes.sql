\set ON_ERROR_STOP ON

-- Create indexes to speed up FTS for coronavirus
CREATE INDEX ON tweets_jsonb USING gin((data->'entities'->'hashtags'));
CREATE INDEX ON tweets_jsonb USING gin((data->'extended_tweet'->'entities'->'hashtags'));

-- Create indexes to speed up bitmap scan
CREATE INDEX ON tweets_jsonb USING btree((data->>'lang'));
CREATE INDEX ON tweets_jsonb USING btree((data->>'id'));
CREATE INDEX ON tweets_jsonb USING btree((data->>'lang'), (data->>'id'));

-- Create indexes to speed up FTS in tweets (not tags)
CREATE INDEX ON tweets_jsonb USING gin(to_tsvector('english', COALESCE(data->'extended_tweet'->>'full_text', data->>'text')));
