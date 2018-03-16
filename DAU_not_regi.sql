
/*
既存のactive_hourly.sqlに、os情報を追加
registerログを除外 hogehoge
 */
with whole as (
  select distinct
    user_id,
    platform as os,
    timestamp_trunc(timestamp, hour) as logged_at
  from
    `warm-calculus-736.liverpool.action_*`
  where
    _table_suffix between  '20180310' and '20180315' and
    type != 'register' 
    -- registerログは、１ユーザーに対して複数発行される可能性があるため、ログインUUのカウントから除外する
  union all
  select distinct
    user_id,
    platform as os,
    timestamp_trunc(timestamp, hour) as logged_at
  from
    `warm-calculus-736.liverpool.audio_*`
  where
    _table_suffix between  '20180310' and '20180315'
    
  union all
  select distinct
    user_id,
    platform as os,
    timestamp_trunc(timestamp, hour) as logged_at
  from
    `warm-calculus-736.liverpool.search_*`
  where
   _table_suffix between  '20180310' and '20180315' 
)
select distinct
  count(distinct user_id) as count_user,
  os,
  date(logged_at,'Asia/Tokyo') as date_jst
 -- timestamp_add(timestamp_trunc(timestamp,hour), interval 9 hour) as timestamp_jst
from
  whole
where
logged_at >= '2018-03-10' 
group by 
 os,date_jst
