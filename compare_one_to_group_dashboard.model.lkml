connection: "thelook_events_redshift"

include: "users.view"
include: "order_items.view"

include: "function_support"

#need to remember to add includes for each dashboard
include: "dashboard_compare_for_extension.dashboard"
include: "dashboard_compare_via_extension.dashboard"
include: "dashboard_compare_via_extension2.dashboard"

### Example explores the implementer has in place
explore: users_base {
  from: users
  view_name: users
  label: "my original explore"
  #...
}

explore: order_items_base {
  from: order_items
  view_name: order_items

}




#####


# explore: compare_dashboard_extending_explore {
#   extends: [users_base]
#   join: compare_input {sql:;; relationship:one_to_one}
# }
view: compare_input_extended {
  extends: [dashboard_prep]
  dimension: dimension_input {sql:${order_items.status};;}
  dimension: compare_value {sql:'Complete';;}
  measure: input_measure {type:number sql:${order_items.count};;}
}

explore: compare_dashboard_extending_explore {
  extends: [order_items_base] #implementer updates to actual base explore
  #use compare_input with from in order such that you could create multiple dashboards (1 explore per)
  join: compare_input {from:compare_input_extended sql:;; relationship:one_to_one}
}

####
#another extension for multiple versions of the dashboard
view: compare_input_sale_price {
  extends: [dashboard_prep]
  #works on string inputs only right now
  dimension: dimension_input {sql:${order_items.sale_price}::varchar;;}
  dimension: compare_value {sql:'1';;}
  measure: input_measure {type:number sql:${order_items.count};;}
  measure: input_measure_choice_1 {type:number sql:${order_items.total_sale_price};;}
  measure: input_measure_choice_2 {type:number sql:${order_items.avg_sale_price};;}

  parameter: measure_selector {
    type: string
    allowed_value: {label:"Sale Price" value:"1"}
    allowed_value: {label:"Avg Sale Price" value:"2"}
  }

}

explore: compare_dashboard_for_saleprice {
  extends: [order_items_base] #implementer updates to actual base explore
  #use compare_input with from in order such that you could create multiple dashboards (1 explore per)
  join: compare_input {from:compare_input_sale_price sql:;; relationship:one_to_one}
}




######
# Baseline off which dashboard can be built off
#explore that the original dashboard was built off of, but this isn't used, instead we use an extended
#dashboard that overrides this explore name with the implementer's special explore name
explore: compare_dashboard {
  extends: [users_base]
  join: compare_input {sql:;; relationship:one_to_one}
}

view: compare_input {
  extends: [dashboard_prep]
  dimension: dimension_input {sql:${users.age};;}
  dimension: compare_value {sql:'20';;}
  measure: input_measure {type:number sql:${users.count};;}
}

#####

view: dashboard_prep {
  dimension: dimension_input {}
  dimension: compare_value {}
  dimension: dimension_with_value_vs_other {
    sql: case when ${dimension_input}=${compare_value} then ${compare_value} else 'other' end ;;
  }
  measure: input_measure {}

  measure: input_measure_choice_1 {type:number}
  measure: input_measure_choice_2 {type:number}


  parameter: measure_selector {
    type: string
#     allowed_value: {label:"1" value:"1"}
#     allowed_value: {label:"2" value:"2"}
  }
  measure: selected_measure {
    label_from_parameter: measure_selector
    type: number
    sql:
    {% if measure_selector._parameter_value == "'1'" %}
      ${input_measure_choice_1}
    {% elsif measure_selector._parameter_value == "'2'" %}
      ${input_measure_choice_2}
    {% else %}
      --else - parameter_value not matched
    {%endif%}
    ;;
    value_format_name: decimal_1
  }

}
