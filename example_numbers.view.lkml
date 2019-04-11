view: example_numbers_2 {
  derived_table: {
    sql:with digits as (
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
,data as
      (
      select
      row_number() over()-500 as integers,
      random() as random_number
      from digits
      cross join digits as digits2
      cross join digits as digits3
      -- cross join digits as digits4
      )

--select data.integers, data.random_number, data2.random_number as random_number2 from data join data2 on data.integers=data2.integers
-- select row_number() over(),* from a cross join a as b
select * from data  ;;
    persist_for: "99999 hours"
    distribution_style: all
  }
  dimension: integers {
    type:number
  }
  dimension: random_number {
    type: number
  }
}

view: example_numbers {
  derived_table: {
    sql:
with digits as (
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
,data as
      (
      select
      row_number() over()-500 as integers,
      random() as random_number
      from digits
      cross join digits as digits2
      cross join digits as digits3
      -- cross join digits as digits4
      )

--select data.integers, data.random_number, data2.random_number as random_number2 from data join data2 on data.integers=data2.integers
-- select row_number() over(),* from a cross join a as b
select * from data

    ;;
    persist_for: "99999 hours"
    distribution_style: all
  }

  dimension: integers {
    type:number
    }
  dimension: random_number {
    type: number
  }
}
