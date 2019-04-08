connection: "thelook_events_redshift"

include: "main.lkml"
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
include: "custom_tiers"
include: "conditionally_format"
#vvvvvv EXPLORE 'USERS' support views and explore name {
view: age_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.age};;}}
view: latitude_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.latitude};;}}
view: item_sale_price_custom_tiers {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${order_items.sale_price};;}}
view: item_sale_price_custom_tiers_by_min_max_and_number_of_tiers {extends: [custom_tiers_by_min_max_and_number_of_tiers] dimension: field_to_compare {sql:${order_items.sale_price};;}}
#override with inputs, potentially with ^^ delimiter.  #final override out output format and labels here
view: id_over_age{extends:[safe_divide]
  dimension: input {sql:${users.id}^^${users.age};;}
  dimension: output {view_label:"Users" value_format_name: decimal_2} # label: "[Override Default Label (this extending view's name)]"
}
# view: age_conditionally_formatted{extends:[conditionally_format__field_number__threshold_number] dimension:input{sql:${users.age}^^{% parameter users.pass_parameter_value_test %};;}}
view: age_conditionally_formatted{extends:[conditionally_format__field_number__threshold_number] dimension:input{sql:${users.age}^^${latitude_widget_view.compare_tiers_groups};;}}
view: count_conditionally_formatted{extends:[conditionally_format__field_number__threshold_number] dimension:input{sql:'a'^^10000;;} measure:measure_input{sql:${users.count};;}}
view: acronymize2 {extends:[acronymize] measure:measure_input {sql:'Test'^^'another test'^^'Tax';;}dimension:output{view_label:"Users"}}
view: min_maxify_dimension__age__25__58{extends:[min_maxify_dimension] measure:measure_input {sql:${users.age}^^25^^58;;}}
view: min_maxify_dimension__age__25__43{extends:[min_maxify_dimension] measure:measure_input {sql:${min_maxify_dimension__age__25__58.output}^^25^^43;;}}
view: min_maxify_3{extends:[min_maxify_dimension] measure:measure_input {sql:${min_maxify_dimension__age__25__58.output}^^30^^40;;}}

#finding - can use dimension or measure for input.  But we cant directly reference measures in dimensions, so if we need measures we should probably use measure based input.  Parser can pull sql from either


#}^^^ END support views
explore: users {
#vvvvvv EXPLORE 'USERS' dummy joins{
  join: age_widget_view {relationship: one_to_one sql:;;}
  join: latitude_widget_view {relationship: one_to_one sql:;;}
  join: item_sale_price_custom_tiers {relationship: one_to_one sql:;;}
  join: item_sale_price_custom_tiers_by_min_max_and_number_of_tiers {sql:;; relationship: one_to_one}
  join: id_over_age {sql:;; relationship: one_to_one}
  join: age_conditionally_formatted {sql:;; relationship: one_to_one}
  join: count_conditionally_formatted {sql:;; relationship: one_to_one}
  join: acronymize2 {sql:;; relationship: one_to_one}
  join: min_maxify_dimension__age__25__58 {sql:;; relationship: one_to_one}
  join: min_maxify_dimension__age__25__43 {sql:;; relationship: one_to_one}
  join: min_maxify_3 {sql:;; relationship: one_to_one}


#}
#^^^^^^ END EXPLORE 'USERS' support views
  #other joins may be included as normal
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.user_id}=${users.id} ;;
  }
}
