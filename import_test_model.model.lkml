connection: "thelook_events_redshift"

include: "users.view"
include: "order_items.view"
include: "example_numbers.view"

include: "functions"
include: "to_be_extended_direct_on_views"

# include: "dashboard_example.dashboard"

################
# 'Standards' for view files...
# IDEA: Every view should extend a 'standard' view.
# This example includes count calculation which doesn't count nulls (primary_key not null)
# See users view for example of the extends, and see 'to_be_extended_direct_on_views' file


persist_for: "99 hours"

############
# Basic Function Example
# Input some parameters, get something.
# Here we enter inputs by writing in the sql parameter of input fields
# Existing fields/logic in the extended view complete the calculation and return 'output' field
# Example URL showing results:   https://profservices.dev.looker.com/explore/import_test_model/function_example?fields=order_items_created_at__with_min_max.output,order_items.created_date,order_items.delivered_date,order_items.returned_date&f[order_items.returned_date]=NOT+NULL&sorts=order_items_created_at__with_min_max.output&limit=500&query_timezone=America%2FNew_York&vis=%7B%7D&filter_config=%7B%22order_items.returned_date%22%3A%5B%7B%22type%22%3A%22%21null%22%2C%22values%22%3A%5B%7B%22constant%22%3A%227%22%2C%22unit%22%3A%22day%22%7D%2C%7B%7D%5D%2C%22id%22%3A0%2C%22error%22%3Afalse%7D%5D%7D&origin=share-expanded
explore: function_example {
  from: order_items
  view_name: order_items
  join: order_items_created_at__with_min_max {sql:;;relationship:one_to_one}
}
view: order_items_created_at__with_min_max {
  extends:[min_maxify_dimension]
  dimension: input_field  {sql:${order_items.delivered_date};;}
  dimension: input_min    {sql:${order_items.created_date};;}
  dimension: input_max    {sql:${order_items.returned_date};;}
  #This 'output' is where the calcuation's result will land.
  #Could override settings like output format here. Otherwise defaults set in the extended view will be used
  dimension: output {label: "{{_view._name | replace: '_',' ' }}"}
}




###############
#Custom Tiering {
# Demo: Quickly add advanced functionlity, on any number of fields.  One per field
# In this case, custom tiering functionality using parameters, AND with custom html parameters
# # Each 'view' listed below will be trivially 'joined' to the explore, and adds a View Label and set of fields
# # Below are different 'view' features... 2 different custom cohort control mechanism, set on different fields.
include: "custom_tiers"
#override with inputs, potentially with ^^ delimiter.  #final override out output format and labels here
  view: age__with_custom_threshold  {extends:[custom_tiers__binary_threshold]         dimension: field_to_compare {sql:${users.age};;}}
  view: age_tiers__by_number_buckets{extends:[custom_tiers__min__max__points_between] dimension: field_to_compare {sql:${users.age};;}}
  view: age_tiers__by_bucket_size   {extends:[custom_tiers__by_bucket_size]           dimension: field_to_compare {sql:${users.age};;}}
  view: age_tiers__arbitrary_cutoffs{extends:[custom_tiers__arbitrary_cutoffs]        dimension: field_to_compare {sql:${users.age};;}}
  explore: users_for_custom_tiers_examples {
    from: users
    view_name: users
    join: age__with_custom_threshold    {relationship: one_to_one sql:;;}
    join: age_tiers__by_number_buckets  {relationship: one_to_one sql:;;}
    join: age_tiers__by_bucket_size     {relationship: one_to_one sql:;;}
    join: age_tiers__arbitrary_cutoffs  {relationship: one_to_one sql:;;}
  }
#} end fold




###############
# Conditional formatting demo {
#DEMO NOTE: 2nd example leverages the first, by referenceing the helper view name and the 'output_measure' field it produces
include: "conditionally_format"
  view: user_count_conditionally_formatted{extends:[conditionally_format__measure__threshold_measure]
    measure:measure_input{sql:${users.count};;}
    measure:threshold_measure{sql:1000;;}#may use measure reference or hardcoded value
  }
  #demo with age dimension selected to show both over and under threshold. I used *10 just to make the sale price threshold high enough that it sometimes exceeds count
  view: user_count_conditionally_formatted_against_avg_sale_price{extends:[conditionally_format__measure__threshold_measure]
    measure:measure_input{sql:${user_count_conditionally_formatted.output_measure};;}
    measure:threshold_measure{sql:${order_items.avg_sale_price}*10;;}#may use measure reference or hardcoded value.
  }
  view: meets_criteria_example{extends:[emoji_conditionally_format_by_threshold]
    dimension:input{sql:${order_items.sale_price};;}
    dimension:static_threshold_input {sql:12;;}
  }
  explore: users_for_conditionally_format {from: users view_name: users
    join: user_count_conditionally_formatted                        {sql:;; relationship: one_to_one}
    join: user_count_conditionally_formatted_against_avg_sale_price {sql:;; relationship: one_to_one}
    join: meets_criteria_example                                    {sql:;; relationship: one_to_one}
    #other joins may be included as normal
    join: order_items {
      type: left_outer
      relationship: one_to_many
      sql_on: ${order_items.user_id}=${users.id} ;;
    }
  }
#} end fold



###############
# Other custom html ideas demo {
include: "other_special_formatting"
#To DEMO percent not returned, used User ID, and filtered on % != 1
#Can switch emojis as seen in smiley pile example
  view: smiley_emojis_avg_sale_price{extends:[emojis]
    measure:  measure_input{sql:${order_items.avg_sale_price};;}
    ###parameters that the implementer can optionally override
    #     dimension: input_emojis_per_row {sql:10;;}
    #     dimension: input_break_every_x_rows {sql: 10 ;;}
    #     dimension: input_min_size_px {sql:6;;}
    #     dimension: input_max_size_px {sql:16;;}
    #     dimension:input_emoji {sql:x;;}
  }
#another version we can leverage '_percent' is set such that it fills a 100 emojis square
  view: smiley_percent_not_returned{extends:[emojis_percent] measure:measure_input{sql:${order_items.percent__not_returned};;}}
#'pile' is silly, but demoing that someone could come up with some random format... Added ability to change out the emoji
  view: smiley_pile{extends:[smiley_emojis_pile]
    measure:measure_input{sql:avg(${order_items.sale_price});;}
    dimension:input_emoji {sql:💵;;}
  }
#conditional formatting with emojis example
explore: emojis_custom_html_examples  {
  from: order_items
  view_name: order_items
  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id}=${users.id} ;;
  }
  join: smiley_emojis_avg_sale_price {sql:;; relationship: one_to_one}
  join: smiley_percent_not_returned {sql:;; relationship: one_to_one}
  join: smiley_pile {sql:;; relationship: one_to_one}
}
#}end fold



###############
# Specific 'Viz' - Example: NPS {
# Practice Dropping this on Meta
include: "NPS"
  view: my_nps {
    extends: [nps]
    measure: promoters_measure {sql:round(sum(${example_numbers.random_number}*100),0);;}
    measure: detractors_measure {sql:round(sum(${example_numbers_2.random_number}*100),0);;}
    measure: neutrals_measure{sql:sum(${example_numbers.integers});;}
  }
  explore: NPS_custom_html {
    from: example_numbers
    view_name: example_numbers
    join: example_numbers_2 {
      type: left_outer
      relationship: one_to_one
      sql_on: ${example_numbers.integers}=${example_numbers_2.integers} ;;
    }
    join:my_nps {sql:;; relationship:one_to_one}
  }
#} end fold



############
# Tooltips - Add one field as the tooltip of another. {
# This version has an on-off toggle for the tooltip
include: "tooltipify"
view: count_sales_with_total_sales_as_tooltip{
  extends:[tooltipify_with_on_off_toggle] #extends: [tooltipify]
  measure: my_measure {sql:${order_items.count};;}
  measure: tooltip_for_my_measure {sql:${order_items.total_sale_price};;}
}
explore: users_for_tooltipify {
  from: users
  view_name: users
  join: count_sales_with_total_sales_as_tooltip {sql:;;relationship:one_to_one}
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.user_id}=${users.id} ;;
  }
}
#} end fold



###########
# Profile a dimenension {
# Get min, max, count_distinct values, etc, shown for a given dimension
include: "profile_dimension"
view: age_dimension_profile               {extends: [profile_dimension]         dimension: input {sql:${users.age};;}}
view: sale_price_dimension_profile        {extends: [profile_dimension]         dimension: input {sql:${order_items.sale_price};;}}
view: user_created_date_dimension_profile {extends: [profile_dimension]         dimension: input {sql:${users.created_date};;}}
view: user_age_dimension_profile_extra    {extends: [profile_dimension__number] dimension: input {sql:${users.age};;}}
explore: users_for_profile_dimension {
  from: users
  view_name: users
  join: age_dimension_profile               {sql:;; relationship:one_to_one}
  join: sale_price_dimension_profile        {sql:;; relationship:one_to_one}
  join: user_created_date_dimension_profile {sql:;; relationship:one_to_one}
  join: user_age_dimension_profile_extra    {sql:;; relationship:one_to_one}
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.user_id}=${users.id} ;;
  }
}
#} end fold


##############
# apply lookml dashboard to modelled fields demo
# demo not really complete, would need to add more tiles, adress labelling, etc.
# but the core works: have a dahsboard refer to placeholder fields

include: "dashboard_support"
include:"dashboard_to_be_extended.dashboard"
include: "extends_dashboard.dashboard"
#attempting to create an additional version of the dashboard for a different field.
#challenging so far because the dashboard lookml explicitly names these fields, so we have to override every reference.
#i tried a find and replace all on the view name, but that's still an extra manual step, and im having trouble with 'key' property changed... I suspect having to do with dynamic fields
#it might be easier to simply create one extension of the model for each dashboard (still change the dashboard_select_fields view name, but with different inputs)
include: "dashboard_for_age_via_extension.dashboard"
# view: dashboard_select_fields_age {
#   extends: [dashboard_input]
#   dimension: for_dashboard_compare_dimension {sql: ${users.age} ;;}
#   dimension: for_dashboard_date_raw_field {sql:${users.created_raw};;}
# }
view: dashboard_select_fields {
  extends: [dashboard_input]
  dimension: compare_dimension_label {sql:'Gender';;}
  dimension: for_dashboard_compare_dimension {sql: ${users.gender} ;;}
  dimension: for_dashboard_date_raw_field {sql:${users.created_raw};;}

}
explore: users_for_dynamic_lookml_dashboard_block_demo {
  from: users
  view_name: users
  join: dashboard_select_fields {sql:;; relationship:one_to_one}
#   join: dashboard_select_fields_age {sql:;; relationship:one_to_one}
}
