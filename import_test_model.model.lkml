connection: "thelook_events_redshift"

include: "main.lkml"

explore: test {
  from: users
#   extends: [main_explore]
}


view: age_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.age};;}}
view: latitude_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.latitude};;}}
view: item_sale_price_custom_tiers {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${order_items.sale_price};;}}

explore: test2 {
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
