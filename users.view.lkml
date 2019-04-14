include: "to_be_extended_direct_on_views"
#Typical setup, but with minimal fields for clarity
view: users{
  extends: [standards]
  sql_table_name: public.users ;;
  dimension: id {}#primary_key:yes}
  dimension: primary_key {sql:${id};;}
  dimension: age {type:number}
  dimension: age_tier {
    type: tier
    sql: ${age} ;;
    tiers: [20,40,60]
    style: integer
  }
  dimension: gender {}
  dimension: latitude {type: number}
  dimension_group: created{
    type: time
    timeframes: [raw,date,month]
    sql: ${TABLE}.created_at ;;
  }
#   dimension_group: now {
#     datatype: timestamp
#     type: time
#     timeframes: [raw,date]
#     sql: getdate() ;;
#   }
  measure: count {type: count}
  dimension: days_since_joined {
    type: duration_day
    sql_start:  ${created_date};;
#     sql_end: ${now_date} ;;
    sql_end: '${current_date_unquoted}' ;;
  }
  dimension: years_since_joined {
    type: duration_year
    sql_start:  ${created_date};;
#     sql_end: ${now_date} ;;
    sql_end: '${current_date_unquoted}' ;;
  }


}
