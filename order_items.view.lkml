include: "to_be_extended_direct_on_views"
view: order_items {
  extends: [standards]
  sql_table_name: public.order_items ;;
  dimension: id {}#primary_key:yes}
  dimension: primary_key {sql:${id};;}
  dimension: user_id {}
  dimension: order_id {}
  dimension: inventory_item_id {}
  dimension: sale_price {type:number sql:floor(sale_price);;}
  dimension: sale_price_tier {type:tier tiers:[10,20,40,80,160,800] sql:${sale_price};;}
  dimension: status {}
  dimension_group: created {
    type: time
    timeframes: [raw,date]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: delivered {
    type: time
    timeframes: [raw,date]
    sql: ${TABLE}.delivered_at ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw,date]
    sql: ${TABLE}.returned_at ;;
  }
  measure: total_sale_price {type:sum sql:${sale_price};;}
  measure: count {type:count}
  measure: count_not_returned  {
    type: count
    filters:{field: returned_date value: "NULL"}
  }
  measure: percent__not_returned {
    type: number
    sql: ${count_not_returned}*1.0/nullif(${count},0) ;;
    value_format_name: percent_2
  }
  measure: avg_sale_price {
    type: average
    sql: ${sale_price} ;;
  }
}
