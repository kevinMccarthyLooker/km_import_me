view: order_items {
  sql_table_name: public.order_items ;;
  dimension: id {primary_key:yes}
  dimension: user_id {}
  dimension: sale_price {type:number sql:floor(sale_price);;}
  dimension: sale_price_tier {type:tier tiers:[10,20,40,80,160] sql:${sale_price};;}
  measure: total_sale_price {type:sum sql:${sale_price};;}

  measure: count {type:count}
  dimension_group: returned {
    type: time
    timeframes: [raw,date]
    sql: ${TABLE}.returned_at ;;
  }
  measure: count_not_returned  {
    type: count
    filters:{
      field: returned_date
      value: "NULL"
    }
  }
  measure: percent_returned {
    type: number
    sql: ${count_not_returned}*1.0/nullif(${count},0) ;;
    value_format_name: percent_2
  }
}
