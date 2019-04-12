connection: "thelook_events_redshift"

include: "*.view"

###############
#4/4 Standard View! Starting point using extends
# Demo extending an explore to add 'standard' fields. in this case it includes the 'fixed' count calculation (don't count when the primary key is null. this is important woraround for some outer join scenarios)
# # In users file, we created a basic users view, and extended it and added 'standard' features (count, range of primary_key in the example)
include: "users__multiple_versions.view"
explore: users__standards_applied {} #see where this view was created via extensions (users view file)


# ##############
# 4/5 Complex Enhancements & Functions
# Demo: Quickly add advanced functionlity, on any number of fields.  One per field
# In this case, custom tiering functionality using parameters, AND with custom html parameters
# # Each 'view' listed below will be trivially 'joined' to the explore, and adds a View Label and set of fields
# # Below are 4 different 'view' features... 2 different custom cohort control mechanism, set on different fields.
include: "functions"
#override with inputs, potentially with ^^ delimiter.  #final override out output format and labels here
view: id_over_age{
  view_label: "Users"
  extends:[safe_divide,parse_input_unhidden]
  dimension: input {sql:${users.id}^^${users.age};;}
#   dimension: output {view_label:"{{_view._name}} {{users.age._field}}"}
#   dimension: output {view_label:"Users" value_format_name: decimal_2} # label: "[Override Default Label (this extending view's name)]"
}
explore: users__for_functions {
  from: users
  view_name: users
  join: id_over_age {sql:;; relationship: one_to_one}


}

include: "custom_tiers"
#vvvvvv EXPLORE 'USERS' support views and explore name {
view: age_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.age};;}}
view: latitude_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.latitude};;}}
view: item_sale_price_custom_tiers {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${order_items.sale_price};;}}
view: item_sale_price_custom_tiers_by_min_max_and_number_of_tiers {extends: [custom_tiers_by_min_max_and_number_of_tiers] dimension: field_to_compare {sql:${order_items.sale_price};;}}
# view: age_conditionally_formatted{extends:[conditionally_format__field_number__threshold_number] dimension:input{sql:${users.age}^^{% parameter users.pass_parameter_value_test %};;}}

include: "conditionally_format"
view: age_conditionally_formatted{extends:[conditionally_format__field_number__threshold_number] dimension:input{sql:${users.age}^^${latitude_widget_view.compare_tiers_groups};;}}
view: count_conditionally_formatted{extends:[conditionally_format__field_number__threshold_number] dimension:input{sql:'a'^^10000;;} measure:measure_input{sql:${users.count};;}}
view: acronymize2 {extends:[acronymize] measure:measure_input {sql:'Test'^^'another test'^^'Tax';;}dimension:output{view_label:"Users"}}
# view: min_maxify_dimension__age__25__58{extends:[min_maxify_dimension] measure:measure_input {sql:${users.age}^^25^^58;;}}
# view: min_maxify_dimension__age__25__43{extends:[min_maxify_dimension] measure:measure_input {sql:${min_maxify_dimension__age__25__58.output}^^25^^43;;}}
# view: min_maxify_3{extends:[min_maxify_dimension] measure:measure_input {sql:${min_maxify_dimension__age__25__58.output}^^30^^40;;}}
# view: min_maxify_4{extends:[min_maxify_dimension2] dimension: min{sql:35;;} dimension:max{sql:45;;} dimension:field{sql:${users.age};;}}

view: user_age_30_to_latitude{extends:[min_maxify_dimension]
  view_label: "Users"
  dimension:input_min{sql:30;;}
  dimension:input_max{sql:${users.latitude};;}
  dimension:input_field{sql:${users.age};;}
  dimension:output {label: "{{_view._name | replace: '_',' ' }}"}#override output field here, otherwise it will appear using the view name
}


#finding - can use dimension or measure for input.  But we cant directly reference measures in dimensions, so if we need measures we should probably use measure based input.  Parser can pull sql from either


#}^^^ END support views
explore: users {
#vvvvvv EXPLORE 'USERS' dummy joins{
  join: age_widget_view {relationship: one_to_one sql:;;}
  join: latitude_widget_view {relationship: one_to_one sql:;;}
  join: item_sale_price_custom_tiers {relationship: one_to_one sql:;;}
  join: item_sale_price_custom_tiers_by_min_max_and_number_of_tiers {sql:;; relationship: one_to_one}
  join: age_conditionally_formatted {sql:;; relationship: one_to_one}
  join: count_conditionally_formatted {sql:;; relationship: one_to_one}
  join: acronymize2 {sql:;; relationship: one_to_one}
#   join: min_maxify_dimension__age__25__58 {sql:;; relationship: one_to_one}
#   join: min_maxify_dimension__age__25__43 {sql:;; relationship: one_to_one}
#   join: min_maxify_3 {sql:;; relationship: one_to_one}
#   join: min_maxify_4 {sql:;; relationship: one_to_one}
  join: user_age_30_to_latitude {sql:;; relationship: one_to_one}
  join: user_age_30_to_40 {sql:;; relationship: one_to_one}
  join: user_age_30_to_param {sql:;; relationship: one_to_one}



#}
#^^^^^^ END EXPLORE 'USERS' support views
  #other joins may be included as normal
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.user_id}=${users.id} ;;
  }
}


view: smiley_emojis_avg_sale_price{extends:[smiley_emojis] measure:measure_input{sql:avg(${order_items.sale_price});;}}
view: smiley_percent_not_returned{extends:[smiley_emojis_percent] measure:measure_input{sql:${order_items.percent_returned};;}}
view: smiley_pile{extends:[smiley_emojis_pile] measure:measure_input{sql:avg(${order_items.sale_price});;}
  #   dimension:input_emoji {sql:💵;;}
  }
view: t{extends:[if_dimension_equals_value_then_emoji_else_other_emoji] dimension:input_dimension{sql:${order_items.sale_price};;}}


#starting a new explore for separate tests
explore: order_items {
  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id}=${users.id} ;;
  }
  join: smiley_emojis_avg_sale_price {sql:;; relationship: one_to_one}
  join: smiley_percent_not_returned {sql:;; relationship: one_to_one}
  join: smiley_pile {sql:;; relationship: one_to_one}
  join: t {sql:;; relationship: one_to_one}
}

include: "NPS"
view: my_nps {
  extends: [nps]
  dimension: promoters {sql:round(${example_numbers.random_number}*100,0);;}
  dimension: detractors {sql:round(${example_numbers_2.random_number}*100,0);;}
  dimension: neutrals{sql:${example_numbers.integers};;}
  measure: promoters_measure {sql:round(${example_numbers.random_number}*100,0);;}
  measure: detractors_measure {sql:round(${example_numbers_2.random_number}*100,0);;}
  measure: neutrals_measure{sql:${example_numbers.integers};;}

}
explore: example_numbers {
  join: example_numbers_2 {
    type: left_outer
    relationship: one_to_one
    sql_on: ${example_numbers.integers}=${example_numbers_2.integers} ;;
  }
  join:my_nps {sql:;; relationship:one_to_one}
}


include: "tooltipify"
view: count_sales_with_total_sales_as_tooltip{
#   extends:[tooltipify_with_on_off_toggle]
  extends: [tooltipify]
  measure: my_measure {sql:${order_items.count};;}
  measure: tooltip_for_my_measure {
    sql:${order_items.total_sale_price};;}
  dimension: view_label__sql_placeholder_input {sql: t ;;}
#   measure: output {
#     type: number
#     sql: ${my_measure} ;;
#     html: {{my_measure._rendered_value}}({{tooltip_for_my_measure._rendered_value}}) ;;
#   }
}
explore: users_for_tooltipify {
  join: count_sales_with_total_sales_as_tooltip {sql:;;relationship:one_to_one}
  from: users
  view_name: users
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.user_id}=${users.id} ;;
  }

}

# include: "test_passing_liquid_variables.view"
# explore: test_passing_liquid_variables {}

include: "profile_dimension"
view: age_dimension_profile{extends: [profile_dimension]
  dimension: input {sql:${users.age};;}
}
view: sale_price_dimension_profile{extends: [profile_dimension]
  dimension: input {sql:${order_items.sale_price};;}
}
view: user_created_date_dimension_profile{extends: [profile_dimension]
  dimension: input {sql:${users.created_date};;}
}
view: user_age_dimension_profile_extra {
  extends: [profile_dimension]
#   dimension: source_view {sql:${users.SQL_TABLE_NAME};;}
  dimension: input {sql:${users.age};;}
#   measure: count_of_view {sql:(select ${input} from ${users.SQL_TABLE_NAME} group by ${input} order by count(*) desc limit 1);;}
  dimension: is_number {sql:true;;}
  measure: output_measure {
    sql:
${EXTENDED}||' |'
||'sum:'||sum(${input})||' & '||'sum distinct:'||sum(distinct ${input})||' |'
||'avg:'||avg(${input})||' & '||'avg distinct:'||avg(distinct ${input})
    ;;
  }
}

explore: users_for_profile_dimension {
  join: age_dimension_profile {sql:;; relationship:one_to_one}
  join: sale_price_dimension_profile {sql:;; relationship:one_to_one}
  join: user_created_date_dimension_profile {sql:;; relationship:one_to_one}
  join: user_age_dimension_profile_extra {sql:;; relationship:one_to_one}
  from: users
  view_name: users
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.user_id}=${users.id} ;;
  }
}
