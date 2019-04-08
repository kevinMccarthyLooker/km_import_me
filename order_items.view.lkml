view: order_items {
  sql_table_name: public.order_items ;;
  dimension: id {primary_key:yes}
  dimension: user_id {}
  dimension: sale_price {type:number}
  measure: total_sale_price {type:sum sql:${sale_price};;}
  measure: count {type:count}
}
