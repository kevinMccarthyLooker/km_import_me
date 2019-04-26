# AFFINITY ANALYSIS BLOCK
############################################################
## DEVELOPER WILL READ AND MAKE UPDATES IN THIS SECTION
# Paste this code in your model file.
# Follow steps to add extenal dependency #*link or steps#
# REQUIRED UPDATES:
# 1) explore_soure: MY_EXPLORE_NAME
# 2) field: MY_VIEW_NAME.MY_FIELD_NAME - for both parent and child fields (Note: must be valid for the explore_source)
view: affinity_analysis_input_placeholder {
  extends: [affinity_analysis_base]
  derived_table: {
    explore_source: order_items {
      column: parent_field {field: order_items.order_id}
      column: child_field {field: products.name}
    }
  }
}
# explore: affinity_analysis {from:affinity_analysis_input extends:[affinity_analysis_base_explore]}
## END OF CODE DEVELOPER NEEDS TO SEE
############################################################



#####################################
#######################
# Helper view to be extended
##### 1) 'PARENT CHILD COMBOS': Get unique child_values on each parent, and create an explore for use in subseqent pdts
# Note: End developer's implementation will override the derived table field references
# High Level Business Concept: Frequency of specific combinations of two 'child_values' (e.g. order_items.brand Levi's and item brand Calvin Klein), (on 'parent_values', like an order)
view: affinity_analysis_base {
  dimension: parent_field {label: "Parent Field Value" description:"Not used in Affinity Analysis Output.  For Reference & Testing"}
  dimension: child_field {label:"Child Value ({% if _view._name == 'self_join' %}B{% else %}A{% endif %})"}
  measure: unique_parent_and_child_combinations {type: count} #NOTE: two of the same item not counted twice
#   measure: grand_total2 {type:number sql:(select count(*) as grand_total from {{_view._name}});;}
}


explore: affinity_analysis_base_explore {
#   extension: required
hidden: yes
from: affinity_analysis_input_placeholder
view_name: affinity_analysis
#   from: unique_product_names_per_order
#   view_name:unique_product_names_per_order #explicit because we plan to extend(?)
persist_for:"99 hours"
join: self_join {
  view_label: "Affinity Analysis"
  fields: [self_join.child_field] #only need to see the name
  from: affinity_analysis_input_placeholder
  relationship: one_to_one #don't care/want fanout
  sql_on: ${self_join.parent_field} = ${affinity_analysis.parent_field} and ${self_join.child_field}<>${affinity_analysis.child_field};;#?use greater than so we don't get repeats of the same combintion in reverse order? #discourse just shows <>
}
join: child_a_subtotals {#subtotal of distinct Parent Event/Values having Child Value A
  from: total_order_product_ndt
  relationship: one_to_one #has no measures
  sql_on: ${affinity_analysis.child_field}=${child_a_subtotals.child_field} ;;
}
join: child_b_subtotals {#subtotal of distinct Parent Event/Values having Child Value B
  from: total_order_product_ndt
  relationship: one_to_one #has no measures
  sql_on: ${self_join.child_field}=${child_b_subtotals.child_field} ;;
}
join: total_orders_ndt {
  view_label: "Affinity Analysis"
  type: cross
  relationship: one_to_one
}
join: final_calculations {view_label: "Affinity Analysis" sql:;; relationship:one_to_one}#calculations that cross multiple views
}

#######################
###### 2) 'CREATE SUBTOTAL LOOKUP VIEWS': Use unique combinations table/explore from previous steps to get and store count of distinct Parents having each Child_Value, and also grand total of Parent_and_Child combinations, for use in final frequency calculations
view: total_order_product_ndt {
  derived_table: {
    explore_source: affinity_analysis_base_explore {
      column: child_field {field:affinity_analysis.child_field}
      column: total_combinations_for_product {field:affinity_analysis.unique_parent_and_child_combinations}
    }
  }
  dimension: child_field {hidden:yes}
  measure: total_combinations_for_product {type:max hidden:yes}
}
view: total_orders_ndt {
  derived_table: {explore_source: affinity_analysis_base_explore {column: grand_total {field:affinity_analysis.unique_parent_and_child_combinations}}}
  measure: grand_total {type: max}
}

########################
#calculations that cross views defined here
view: final_calculations {
  measure: child_value_a_frequency {
    description: "How frequently orders include product A as a percent of total orders"
    type: number
    sql: 1.0*${child_a_subtotals.total_combinations_for_product}/${total_orders_ndt.grand_total} ;;
    value_format: "#.00%"
  }
  measure: child_value_b_frequency {
    description: "How frequently orders include product B as a percent of total orders"
    type: number
    sql: 1.0*${child_b_subtotals.total_combinations_for_product}/${total_orders_ndt.grand_total} ;;
    value_format: "#.00%"
  }
  measure: combination_frequency {
    description: "How frequently orders include both product A and B as a percent of total orders"
    type: number
    sql: 1.0*${affinity_analysis.unique_parent_and_child_combinations}/${total_orders_ndt.grand_total} ;;
    value_format: "#.00%"
  }
  # Affinity Metrics
  measure: add_on_frequency {
    description: "How many times both Products are purchased when Product A is purchased"
    type: number
    sql: 1.0*${affinity_analysis.unique_parent_and_child_combinations}/${child_a_subtotals.total_combinations_for_product} ;;
    value_format: "#.00%"
  }
  measure: lift {
    description: "The likelihood that buying product A drove the purchase of product B"
    type: number
    sql: ${combination_frequency}/(${child_value_a_frequency} * ${child_value_b_frequency}) ;;
    value_format: "#,##0.#0"
  }
  ## Do not display unless users have a solid understanding of  statistics and probability models
  measure: jaccard_similarity {
    description: "The probability both items would be purchased together, should be considered in relation to total order count, the highest score being 1"
    type: number
    sql: 1.0*${affinity_analysis.unique_parent_and_child_combinations}/(${child_a_subtotals.total_combinations_for_product} + ${child_b_subtotals.total_combinations_for_product} - ${affinity_analysis.unique_parent_and_child_combinations}) ;;
    value_format: "0.00"
  }
}
