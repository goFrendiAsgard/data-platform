-- {{ config(materialized='table') }}

with global_views as (
    select 
        count(distinct session_id) global_view_count
        , content_id
    from {{ source('raw', 'raw_views') }}
    group by content_id
)

select 
    contents.*
    , global_views.global_view_count
from {{ source('raw', 'raw_contents') }} as contents
left join global_views
    on global_views.content_id = contents.id