view: example_numbers {
  derived_table: {
    sql:
with
digits as
(
select 1 as digit union all
select 2 as digit union all
select 3 as digit union all
select 4 as digit union all
select 5 as digit union all
select 6 as digit union all
select 7 as digit union all
select 8 as digit union all
select 9 as digit union all
select 0 as digit
)
,
data as
(
select
row_number() over()-20 as integers,
random() as random_number
from digits
cross join digits as digits2
--cross join digits as digits3
-- cross join digits as digits4
)
select * from data;;
    persist_for: "99999 hours"
    distribution_style: all
  }
  dimension: integers {type:number}
  dimension: random_number {type: number}
}
#for join to get different random numbers
view: example_numbers_2 {extends: [example_numbers]}
