###############
# 5/3 Sequencing Block source file. include in your model file. instructions documented separately

#template to hide user input fields
view: sequence_input {
    #Update with fields that are valid together in an explore:
    dimension: input_parent_unique_id__dimension  {hidden:yes}
    dimension: input_child_unique_id__dimension   {hidden:yes}
    dimension: order_by_dimension                 {hidden:yes}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
    dimension: order_by_descending_toggle         {sql:false;; hidden:yes}
    dimension: order_by_descending_text_for_sql {hidden: yes
# sql:
# {% assign user_input_text = order_by_descending_toggle._sql %}
# {% assign output_sql = '' %}
# {% if user_input_text == 'true' %}{% assign output_sql = 'DESC' %}{% endif %}
# {{output_sql}}
# ;;
      sql:{% if order_by_descending_toggle._sql == 'true' %}DESC{% endif %};;
    }
    #(Customization): bind dimension references can be added here if necessary. Will have to list each explicitly here and in corresponding bind_filters parameter of the ranking view
    #dimension: age_and_gender_combo {sql:${users.age_and_gender_combo};;}
}


#placeholder explore that pre-defines joins that will be used to join back to the original explore
explore: sequence_input_explore_placeholder {
  extension: required
  join: sequence_input {sql:;;relationship:one_to_one}#will be overridden
#   join: sequencing_ndt {
#     sql_on:
#         ${sequencing_ndt.child_unique_id}=${sequence_input.input_child_unique_id__dimension} and
#         ${sequencing_ndt.parent_unique_id}=${sequence_input.input_parent_unique_id__dimension} and
#         ${sequencing_ndt.order_by_dimension}=${sequence_input.order_by_dimension};;
#     relationship: one_to_one
#   }
}

#placeholder explore for NDT to reference
# explore: sequence_input_explore {
#   extension: required
#   extends:[sequence_input_explore_placeholder]
# }

# view: sequence_input {
#   # dimension: input_parent_unique_id__dimension {sql:${order_items.order_id};;}
#   # dimension: input_child_unique_id__dimension {sql:${order_items.id};;}
#   # dimension: order_by_dimension {sql:${order_items.id};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
#   dimension: input_parent_unique_id__dimension {
#     hidden:yes
#     sql:;;
#   }
#   dimension: input_child_unique_id__dimension {
#     hidden:yes
#     sql:;;
#   }
#   dimension: order_by_dimension {
#     hidden:yes
#     sql:;;
#   }#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
# }
# #########




view: sequencing_ndt {
  extension: required
#   extends: [sequence_input]
  derived_table: {
    explore_source: sequence_input_explore {
      timezone: "query_timezone"
      column: parent_unique_id  {field:sequence_input.input_parent_unique_id__dimension}
      column: child_unique_id   {field:sequence_input.input_child_unique_id__dimension}#
      column: order_by_dimension {field:sequence_input.order_by_dimension}
#       column: order_by_descending_toggle {field:sequence_input.order_by_descending_toggle}

      derived_column: sequence_number {sql:ROW_NUMBER() OVER(PARTITION BY parent_unique_id ORDER BY order_by_dimension;;}#Right paren will be added in extending explore
    }
  }

  dimension: parent_unique_id   {hidden: yes}
  dimension: child_unique_id    {hidden:yes}
  dimension: order_by_dimension {hidden:yes}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)

  dimension: sequence_number    {
    type:number
  }

  dimension: input_parent_unique_id__dimension {
    hidden:yes
    sql:;;
  }
  dimension: input_child_unique_id__dimension {
    hidden:yes
    sql:;;
  }
#   dimension: order_by_dimension {
#     hidden:yes
#     sql:;;
#   }



}




# view: sequencing_ndt {
#   derived_table: {
#     explore_source: sequence_base_placeholder {
#       column: parent_unique_id  {field:order_items.order_id}
#       column: child_unique_id   {field:order_items.id}

#       derived_column: sequence_number {sql:ROW_NUMBER() OVER(PARTITION BY parent_unique_id ORDER BY child_unique_id);;}
#     }
#   }

#   dimension: parent_unique_id {type:number}
#   dimension: child_unique_id {type:number}
#   dimension: sequence_number {type:number}
# }


######
# ### trying without helper views... went back to the fully extending with helpers approach.  cleaner main explore.
# view: rank__order_item__for__gender2 {
#   extends:[sequencing_ndt]
#   derived_table: {
#     #update with the name of the input explore
#     explore_source: my_explore {
#       timezone: "query_timezone"
#       #update the base view name of each field to the input view you defined
#       column: parent_unique_id    {field:users.gender}
#       column: child_unique_id     {field:order_items.id}
#       column: order_by_dimension  {field:order_items.created_raw}# seem to sometimes get errors (field disappears) when order_by_diension's field is the same as child_unique_id
#       bind_filters: {from_field: users.age to_field: users.age} #bind filters where necessary... no way to pre-emptively bind all filters
#     }
#   }
# }
# # explore: sequence_input__order_item_for_gender2__explore {#?name by the parent/child combination?
# #   extends:[my_explore] #update 'my_explore' to your explore name
# #   #may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base)
# # #   join: sequence_input__order_item_for_gender__view {sql:;;relationship:one_to_one}
# #   join: rank__order_item__for__gender2 {
# #     sql_on:
# #           rank__order_item__for__gender2.parent_unique_id  =${users.gender} and
# #           rank__order_item__for__gender2.child_unique_id   =${order_items.id} and
# #           rank__order_item__for__gender2.order_by_dimension=${order_items.created_raw}
# #           ;;
# #     relationship: many_to_one #in case the unique_id field isn't really unique, this is more accurate. don't plan to measure things on the sequencing, so symmetric aggregates wont be invoked
# #   }
# # }
##... and in the explore was this join
# join: rank__order_item__for__gender2 {
#   sql_on:
#           ${rank__order_item__for__gender2.parent_unique_id}  =${users.gender} and
#           ${rank__order_item__for__gender2.child_unique_id}   =${order_items.id} and
#           ${rank__order_item__for__gender2.order_by_dimension}=${order_items.created_raw}
#           ;;
#   relationship: many_to_one #in case the unique_id field isn't really unique, this is more accurate. don't plan to measure things on the sequencing, so symmetric aggregates wont be invoked
# }
#######


# #######
# older versions/iterations
# # Extended version.  Allows multiple different transactions sequences at once
# # view: sequence_input2 {#?name by the parent/child combination?
# #   #Update with fields that are valid together in an explore:
# #   dimension: input_parent_unique_id__dimension {sql:${order_items.order_id};;}
# #   dimension: input_child_unique_id__dimension {sql:${order_items.id};;}
# #   dimension: order_by_dimension {sql:${order_items.id};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
# # }
# # explore: sequence_input_explore2 {#?name by the parent/child combination?
# #   #update 'my_explore' to your explore name
# #   extends:[my_explore,sequence_input_explore_placeholder]
# #   join: sequence_input {from:sequence_input2}#update with the view name given above
# #   join: sequencing_ndt {from:sequencing_ndt_extended}#update with the name of the NDT you created via extension
# # }
# #
# # #need to be able to create multiple NDTs...
# # view: sequencing_ndt_extended {
# #   extends:[sequencing_ndt]
# #   derived_table: {explore_source: sequence_input_explore2 } #update with the name of the input explore you defined
# # }
#
# #########
# # Extended version.  Allows multiple different transactions sequences at once
# view: sequence_input__order_item_for_user__view {#?name by the parent/child combination?
#   #Update with fields that are valid together in an explore:
#   dimension: input_parent_unique_id__dimension  {sql:${order_items.user_id};;}
#   dimension: input_child_unique_id__dimension   {sql:${order_items.id};;}
#   dimension: order_by_dimension                 {sql:${order_items.id};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
# }
# explore: sequence_input__order_item_for_user__explore {#?name by the parent/child combination?
#   extends:[my_explore] #update 'my_explore' to your explore name
#   #may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base)
#   join: sequence_input__order_item_for_user__view {sql:;;relationship:one_to_one}
# join: sequence__order_item_for_user__ndt {
#   sql_on:
#     sequence__order_item_for_user__ndt.child_unique_id   =${sequence_input__order_item_for_user__view.input_child_unique_id__dimension} and
#     sequence__order_item_for_user__ndt.parent_unique_id  =${sequence_input__order_item_for_user__view.input_parent_unique_id__dimension} and
#     sequence__order_item_for_user__ndt.order_by_dimension=${sequence_input__order_item_for_user__view.order_by_dimension}
#     ;;
#   relationship: one_to_one
# }
# }
# view: sequence__order_item_for_user__ndt {
#   extends:[sequencing_ndt]
#   derived_table: {
#     #update with the name of the input explore you defined
#     explore_source: sequence_input__order_item_for_user__explore {
#       #update the base view name of each field to the input view you defined
#       column: parent_unique_id    {field:sequence_input__order_item_for_user__view.input_parent_unique_id__dimension}
#       column: child_unique_id     {field:sequence_input__order_item_for_user__view.input_child_unique_id__dimension}
#       column: order_by_dimension  {field:sequence_input__order_item_for_user__view.order_by_dimension}
#     }
#   }
# }
#
# # Another Extended version.  Shows multiple different transactions sequences at once
# view: sequence_input__order_item_for_order__view {#?name by the parent/child combination?
#   #Update with fields that are valid together in an explore:
#   dimension: input_parent_unique_id__dimension  {sql:${order_items.order_id};;}
#   dimension: input_child_unique_id__dimension   {sql:${order_items.id};;}
#   dimension: order_by_dimension                 {sql:${order_items.id};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
# }
# explore: sequence_input__order_item_for_order__explore {#?name by the parent/child combination?
#   extends:[my_explore] #update 'my_explore' to your explore name
#   #may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base)
#   join: sequence_input__order_item_for_order__view {sql:;;relationship:one_to_one}
# join: sequence_input__order_item_for_order__ndt {
#   sql_on:
#       sequence_input__order_item_for_order__ndt.child_unique_id   =${sequence_input__order_item_for_order__view.input_child_unique_id__dimension} and
#       sequence_input__order_item_for_order__ndt.parent_unique_id  =${sequence_input__order_item_for_order__view.input_parent_unique_id__dimension} and
#       sequence_input__order_item_for_order__ndt.order_by_dimension=${sequence_input__order_item_for_order__view.order_by_dimension}
#       ;;
#   relationship: one_to_one
# }
# }
# view: sequence_input__order_item_for_order__ndt {
#   extends:[sequencing_ndt]
#   derived_table: {
#     #update with the name of the input explore you defined
#     explore_source: sequence_input__order_item_for_order__explore {
#       #update the base view name of each field to the input view you defined
#       column: parent_unique_id    {field:sequence_input__order_item_for_order__view.input_parent_unique_id__dimension}
#       column: child_unique_id     {field:sequence_input__order_item_for_order__view.input_child_unique_id__dimension}
#       column: order_by_dimension  {field:sequence_input__order_item_for_order__view.order_by_dimension}
#     }
#   }
# }
#
#
# # # A third Extended version.  Shows multiple different transactions sequences at once
# # # process to create a new version (after manifest and paste template
# # # (BB Step 1): Update the dimnensions named below, for the sequencing you want
# # # (BB Step 2): Update the view name just above, replacing [the templated name] (the text up to '__view') with the [name you want for this anaylysis]
# # # (BB Step 3): Find and replace occurrences of [the templated name] with your updated name. (varios references to ...__view, ...__ndt, and ...__explore
# # # (BB Step 4): Update 'my_explore' in __explore to match the explore you want to use this with
# # # (BB Step 5): Update your main explore by extending with [name you want for this anaylysis]__explore
# # view: sequence_input__order_item_for_gender__view {#?name by the parent/child combination?
# #   #Update with fields that are valid together in an explore:
# #   dimension: input_parent_unique_id__dimension  {sql:${users.gender};;}
# #   dimension: input_child_unique_id__dimension   {sql:${order_items.id};;}
# #   dimension: order_by_dimension                 {sql:${order_items.id};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
# #
# #   #bind dimension references can be added here if necessary. Will have to list each explicitly here and in corresponding bind_filters parameter of the ranking view
# #   #dimension: age_and_gender_combo {sql:${users.age_and_gender_combo};;}
# # }
# # view: rank__order_item__for__gender {
# #   extends:[sequencing_ndt]
# #   derived_table: {
# #     #update with the name of the input explore you defined
# #     explore_source: rank__order_item__for__gender__explore {
# #       #update the base view name of each field to the input view you defined
# #       column: parent_unique_id    {field:sequence_input__order_item_for_gender__view.input_parent_unique_id__dimension}
# #       column: child_unique_id     {field:sequence_input__order_item_for_gender__view.input_child_unique_id__dimension}
# #       column: order_by_dimension  {field:sequence_input__order_item_for_gender__view.order_by_dimension}
# #
# #       #bind filters can be added here if necessary. List
# #       #bind_filters: {from_field: users.age_and_gender_combo to_field: sequence_input__order_item_for_gender__view.age_and_gender_combo} #bind filters where necessary... no way to pre-emptively bind all filters
# #     }
# #   }
# # }
# # explore: rank__order_item__for__gender__explore {#?name by the parent/child combination?
# #   extends:[my_explore] #update 'my_explore' to your explore name
# #   #may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base)
# #   join: sequence_input__order_item_for_gender__view {sql:;;relationship:one_to_one}
# #   join: rank__order_item__for__gender {
# #     sql_on:
# #         rank__order_item__for__gender.child_unique_id   =${sequence_input__order_item_for_gender__view.input_child_unique_id__dimension} and
# #         rank__order_item__for__gender.parent_unique_id  =${sequence_input__order_item_for_gender__view.input_parent_unique_id__dimension} and
# #         rank__order_item__for__gender.order_by_dimension=${sequence_input__order_item_for_gender__view.order_by_dimension}
# #         ;;
# #     relationship: many_to_one #in case the unique_id field isn't really unique, this is more accurate. don't plan to measure things on the sequencing, so symmetric aggregates wont be invoked
# #   }
# # }
