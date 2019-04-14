include: "to_be_extended_direct_on_views"

view: dashboard_input {
  extends: [date_helpers]
#   dimension: for_dashboard_users_email {sql: ${users.user_email} ;;}
#   dimension: for_dashboard_compare_dimension {sql: ${users.gender} ;;}
#   dimension: for_dashboard_date_raw_field {sql:${users.created_raw};;}
  dimension: for_dashboard_users_email {sql:;;}
  dimension: for_dashboard_compare_dimension {sql:;;}
  dimension: for_dashboard_date_raw_field {sql:;;}
  dimension: compare_dimension_label {
    type: string
    sql: 'Group' ;;
  }

  dimension: dashboard_days {
    type: date
    sql: ${for_dashboard_date_raw_field} ;;
  }
  dimension: dashboard_weeks {
    type: date_week
    sql: ${for_dashboard_date_raw_field} ;;
  }
  dimension: row_placeholder {
    type: string
    sql: 'placeholder' ;;
  }
  dimension: converted_date {type:date sql:${for_dashboard_date_raw_field};;}
  dimension: weeks_ago {
    type: number
    sql: datediff(week,${converted_date},${now_converted_as_date_field}) ;;
  }
  measure: min_date {
    type:date
    sql: min(${for_dashboard_date_raw_field}) ;;
  }
  measure: max_date {
    type:date
    sql: max(${for_dashboard_date_raw_field}) ;;
  }
  dimension: weeks_ago_special_for_pivot_calculation {
    type: number
    sql:
    case ${weeks_ago}
      when 53 then 53
      when 1 then 1
      else 2
    end
        ;;
  }
  dimension: weeks_ago_special_for_pivot_label {
    type: string
    sql:
    case ${weeks_ago}
      when 53 then '53 weeks prior'
      when 1 then 'last week'
      else 'Avg of weeks between'
    end
        ;;
    order_by_field: weeks_ago_special_for_pivot_calculation
  }
  measure: count_per_week {
    type: number
    sql:
    ${for_dashboard_count}*1.0
    /
    nullif(
    case ${weeks_ago_special_for_pivot_calculation}
      when 2 then 51
      else 1
    end
    ,0)
    ;;
    value_format_name: decimal_1
  }
  dimension: day_of_week {
    type: date_day_of_week
    sql: ${for_dashboard_date_raw_field} ;;
  }
  measure: for_dashboard_count {
    type:number
    sql: ${users.count} ;;
    drill_fields: [users.gender,users.count]
  }
}
