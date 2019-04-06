connection: "thelook_events_redshift"

include: "main.lkml"

explore: test {
  hidden: yes
  from: users
#   extends: [main_explore]
}


view: age_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.age};;}}
view: latitude_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.latitude};;}}
view: item_sale_price_custom_tiers {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${order_items.sale_price};;}}

explore: test2 {
  hidden: yes
  join: age_widget_view {relationship: one_to_one sql:;;}
  join: latitude_widget_view {relationship: one_to_one sql:;;}
  join: item_sale_price_custom_tiers {relationship: one_to_one sql:;;}

  from: users_basic
  view_name: users
  join: order_items
  {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.user_id}=${users.id} ;;
  }
}

view: order_items {
  sql_table_name: public.order_items ;;
  dimension: id {primary_key:yes}
  dimension: user_id {}
  dimension: sale_price {type:number}
  measure: total_sale_price {type:sum sql:${sale_price};;}
  measure: count {type:count}
}

view: users {
  sql_table_name: public.users ;;

####### Primary_key_and_counts support.  Extends imported view in imported project
  extends: [primary_key_and_counts,compare_using_cutoff_parameter]
  dimension: primary_key {sql:${id};;}
  dimension: field_to_compare {sql:${age};;}
#######

  dimension: id {}
  dimension_group: created
  {
    type: time
    timeframes: [raw,date,month]
  }
  dimension: age {type:number}
  dimension: latitude {type: number}
  #measure count is imported
  measure: my_count {
    type: number
    sql: ${count} ;;
  }
}

view: users_basic {
  sql_table_name: public.users ;;


  dimension: id {primary_key:yes}
  dimension_group: created
  {
    type: time
    timeframes: [raw,date,month]
  }
  dimension: age {type:number}
  dimension: latitude {type: number}
  #measure count is imported
  measure: count {
    type: count
  }
}

explore: custom_tiers_by_min_max_and_number_of_tiers {}








#######
#######
include: "functions"

view: users_view {
  sql_table_name: public.users ;;
  dimension: id {primary_key:yes}
  dimension: age {}
  dimension_group: created
  {
    type:time
    timeframes: [raw,date,day_of_year,month_num,day_of_month,week_of_year,month]
    sql:${TABLE}.created_at;;
  }
  dimension_group: now {
    datatype: timestamp
    type: time
    timeframes: [raw,date,day_of_year,month_num,day_of_month,week_of_year,month]
    sql: getdate() ;;
  }
  dimension: days_since_joined {
    type: duration_day
    sql_start:  ${created_date};;
    sql_end: ${now_date} ;;
  }
  dimension: years_since_joined {
    type: duration_year
    sql_start:  ${created_date};;
    sql_end: ${now_date} ;;
  }
}

# view: age_times_3 {extends:[split_input_remote_multiply] dimension: input {sql:${uas2.age}^^3;;}}
# view: id_times_100{extends:[split_input_remote_multiply] dimension: input {sql:${users_view.id}^^100;;}}
# view: Age_Over_5{extends:[divide] dimension: input {sql:${users_view.age}^^5;;}}
view: id_over_age
{
  extends:[safe_divide]
  dimension: input {sql:${users_view.id}^^${users_view.age};;}#override with inputs, potentially with ^^ delimiter
  dimension: output #final override out output format and labels here
  {
    view_label:"Users View"
    # label: "[Override Default Label (this extending view's name)]"
    value_format_name: decimal_2
  }
}
view: acronymize1 {extends:[acronymize] dimension:input {sql:'Test'^^'another test'^^'Xavier';;}dimension:output{view_label:"Users View"}}
explore: users_view
{
  # join: age_times_3 {sql:;; relationship: one_to_one}
  # join: id_times_100 {view_label:"Users View" sql:;; relationship: one_to_one}
  # join: Age_Over_5 {view_label:"Users View" sql:;; relationship: one_to_one}
  join: id_over_age {sql:;; relationship: one_to_one}
join: acronymize1 {sql:;; relationship: one_to_one}
}
