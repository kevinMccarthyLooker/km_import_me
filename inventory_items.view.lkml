view: inventory_items {
  sql_table_name:public.inventory_items;;
  dimension: id {primary_key:yes}
  dimension: inventory_item_id {}
  dimension: product_id {}
  dimension: cost {type:number}
}
