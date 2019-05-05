include: "sequence_transaction" #remove reference
include: "import_test_model.model" #the model your explore is in
# A third Extended version.  Shows multiple different transactions sequences at once
# process to create a new version (after manifest and paste template
# (BB Step 1): Update the dimensions named below, for the sequencing you want
# (BB Step 2): Update the view name just above, replacing [the templated name] (the text up to '__view') with the [name you want for this anaylysis]
# (BB Step 3): Find and replace occurrences of [the templated name] with your updated name. (varios references to ...__view, ...__ndt, and ...__explore
# (BB Step 4): Update 'my_explore' in __explore to match the explore you want to use this with
# (BB Step 5): Update your main explore by extending with [name you want for this anaylysis]__explore
view: sequence_input__order_item_for_gender__view {#?name by the parent/child combination?
  extends: [sequence_input]
  #Update with fields that are valid together in an explore:
  dimension: input_parent_unique_id__dimension  {sql:${users.gender};;}
  dimension: input_child_unique_id__dimension   {sql:${order_items.id};;}
  dimension: order_by_dimension                 {sql:${order_items.created_raw};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
  #bind dimension references can be added here if necessary. Will have to list each explicitly here and in corresponding bind_filters parameter of the ranking view
  #dimension: age_and_gender_combo {sql:${users.age_and_gender_combo};;}
}
view: rank__order_item__for__gender {
  extends:[sequencing_ndt]
  derived_table: {
    #update with the name of the input explore you defined
    explore_source: rank__order_item__for__gender__explore {
      column: parent_unique_id  {field:sequence_input__order_item_for_gender__view.input_parent_unique_id__dimension}
      column: child_unique_id   {field:sequence_input__order_item_for_gender__view.input_child_unique_id__dimension}#
      column: order_by_dimension {field:sequence_input__order_item_for_gender__view.order_by_dimension}
      #bind filters can be added here if necessary. List
      #bind_filters: {from_field: users.age_and_gender_combo to_field: sequence_input__order_item_for_gender__view.age_and_gender_combo} #bind filters where necessary... no way to pre-emptively bind all filters
    }
  }
}
explore: rank__order_item__for__gender__explore {#?name by the parent/child combination?
  #update 'my_explore' to your explore name
  extends:[my_explore]
  #?may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base). not sure if that's the case though. further testing required
  #update the from to match the input view name above
  join: sequence_input__order_item_for_gender__view {sql:;;relationship:one_to_one}
  #update the join name to match the ranking view defined above, and update the references to mach that same join name
  join: rank__order_item__for__gender {
    sql_on:
    ${rank__order_item__for__gender.child_unique_id}   =${sequence_input__order_item_for_gender__view.input_child_unique_id__dimension} and
    ${rank__order_item__for__gender.parent_unique_id}  =${sequence_input__order_item_for_gender__view.input_parent_unique_id__dimension} and
    ${rank__order_item__for__gender.order_by_dimension}=${sequence_input__order_item_for_gender__view.order_by_dimension};;
    relationship: many_to_one}# dev note:in case the unique_id field isn't really unique, this is more accurate. don't plan to measure things on the sequencing, so symmetric aggregates wont be invoked
}
#END OF WHAT DEV NEEDS TO SEE
#####












### IF YOU WANTED ANOTHER COPY ON A DIFFERENT FIELD...
view: rank__order_item__for__age__view {#?name by the parent/child combination?
  extends: [sequence_input]
  #Update with fields that are valid together in an explore:
  dimension: input_parent_unique_id__dimension  {sql:${users.age};;}
  dimension: input_child_unique_id__dimension   {sql:${order_items.id};;}
  dimension: order_by_dimension                 {sql:${order_items.created_raw};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
  #(Customization): bind dimension references can be added here if necessary. Will have to list each explicitly here and in corresponding bind_filters parameter of the ranking view
  #dimension: age_and_gender_combo {sql:${users.age_and_gender_combo};;}
}
view: rank__order_item__for__age {
  extends:[sequencing_ndt]
  derived_table: {
    #update with the name of the input explore you defined
    explore_source: rank__order_item__for__age__explore { #(Customization): bind filters can be added here if necessary. List
                                                          #bind_filters: {from_field: users.age_and_gender_combo to_field: sequence_input__order_item_for_gender__view.age_and_gender_combo} #bind filters where necessary... no way to pre-emptively bind all filters
      column: parent_unique_id  {field:rank__order_item__for__age__view.input_parent_unique_id__dimension}
      column: child_unique_id   {field:rank__order_item__for__age__view.input_child_unique_id__dimension}#
      column: order_by_dimension {field:rank__order_item__for__age__view.order_by_dimension}
      }
  }
}
explore: rank__order_item__for__age__explore {#?name by the parent/child combination?
  #update 'my_explore' to your explore name
  extends:[my_explore]
  #?may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base). not sure if that's the case though. further testing required
  #update the from to match the input view name above
  join: rank__order_item__for__age__view {sql:;;relationship:one_to_one}
  #update the join name to match the ranking view defined above, and update the references to mach that same join name
  join: rank__order_item__for__age {
    sql_on:
      ${rank__order_item__for__age.child_unique_id}   =${rank__order_item__for__age__view.input_child_unique_id__dimension} and
      ${rank__order_item__for__age.parent_unique_id}  =${rank__order_item__for__age__view.input_parent_unique_id__dimension} and
      ${rank__order_item__for__age.order_by_dimension}=${rank__order_item__for__age__view.order_by_dimension};;
    relationship: many_to_one
  }# dev note:in case the unique_id field isn't really unique, this is more accurate. don't plan to measure things on the sequencing, so symmetric aggregates wont be invoked
}


### IF YOU WANTED ANOTHER COPY ON A DIFFERENT FIELD...
view: rank__user_id__for_user_days_since_joined__and__first_name__view {#?name by the parent/child combination?
  extends: [sequence_input]
  #Update with fields that are valid together in an explore:
  dimension: input_parent_unique_id__dimension  {sql:${users.days_since_joined}||${users.first_name};;}
  dimension: input_child_unique_id__dimension   {sql:${users.id};;}
  dimension: order_by_dimension                 {sql:${users.created_raw};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
  #(Customization): bind dimension references can be added here if necessary. Will have to list each explicitly here and in corresponding bind_filters parameter of the ranking view
  #dimension: age_and_gender_combo {sql:${users.age_and_gender_combo};;}
}
view: rank__user_id__for_user_days_since_joined__and__first_name {
  extends:[sequencing_ndt]
  derived_table: {
    #update with the name of the input explore you defined
    explore_source: rank__user_id__for_user_days_since_joined__and__first_name__explore { #(Customization): bind filters can be added here if necessary. List
      column: parent_unique_id  {field:rank__user_id__for_user_days_since_joined__and__first_name__view.input_parent_unique_id__dimension}
      column: child_unique_id   {field:rank__user_id__for_user_days_since_joined__and__first_name__view.input_child_unique_id__dimension}#
      column: order_by_dimension {field:rank__user_id__for_user_days_since_joined__and__first_name__view.order_by_dimension}
      #bind_filters: {from_field: users.age_and_gender_combo to_field: sequence_input__order_item_for_gender__view.age_and_gender_combo} #bind filters where necessary... no way to pre-emptively bind all filters
    }
  }
}
explore: rank__user_id__for_user_days_since_joined__and__first_name__explore {#?name by the parent/child combination?
  #update 'my_explore' to your explore name
  extends:[my_explore]
  #?may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base). not sure if that's the case though. further testing required
  #update the from to match the input view name above
  join: rank__user_id__for_user_days_since_joined__and__first_name__view {sql:;;relationship:one_to_one}
  #update the join name to match the ranking view defined above, and update the references to mach that same join name
  join: rank__user_id__for_user_days_since_joined__and__first_name {
    sql_on:
        ${rank__user_id__for_user_days_since_joined__and__first_name.child_unique_id}   =${rank__user_id__for_user_days_since_joined__and__first_name__view.input_child_unique_id__dimension} and
        ${rank__user_id__for_user_days_since_joined__and__first_name.parent_unique_id}  =${rank__user_id__for_user_days_since_joined__and__first_name__view.input_parent_unique_id__dimension} and
        ${rank__user_id__for_user_days_since_joined__and__first_name.order_by_dimension}=${rank__user_id__for_user_days_since_joined__and__first_name__view.order_by_dimension};;
    relationship: many_to_one
  }# dev note:in case the unique_id field isn't really unique, this is more accurate. don't plan to measure things on the sequencing, so symmetric aggregates wont be invoked
}

### IF YOU WANTED ANOTHER COPY ON A DIFFERENT FIELD...
# rank sale price for user
view: rank__sale_price__for_user__view {#?name by the parent/child combination?
  extends: [sequence_input]
  #Update with fields that are valid together in an explore:
  dimension: input_parent_unique_id__dimension  {sql:${order_items.user_id};;}
  dimension: input_child_unique_id__dimension   {sql:${order_items.id};;}
  dimension: order_by_dimension                 {sql:/**/${order_items.sale_price};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
  dimension: order_by_descending_toggle         {sql:true;;}
  #(Customization): bind dimension references can be added here if necessary. Will have to list each explicitly here and in corresponding bind_filters parameter of the ranking view
  #dimension: age_and_gender_combo {sql:${users.age_and_gender_combo};;}
}
view: rank__sale_price__for_user {
  extends:[sequencing_ndt]
  derived_table: {
    #update with the name of the input explore you defined
    explore_source: rank__sale_price__for_user__explore { #(Customization): bind filters can be added here if necessary. List
      column: parent_unique_id  {field:rank__sale_price__for_user__view.input_parent_unique_id__dimension}
      column: child_unique_id   {field:rank__sale_price__for_user__view.input_child_unique_id__dimension}#
      column: order_by_dimension {field:rank__sale_price__for_user__view.order_by_dimension}
      derived_column: sequence_number {sql:${EXTENDED} {{ rank__sale_price__for_user__view.order_by_descending_text_for_sql._sql }});;}
      #bind_filters: {from_field: users.age_and_gender_combo to_field: sequence_input__order_item_for_gender__view.age_and_gender_combo} #bind filters where necessary... no way to pre-emptively bind all filters
    }
  }
}
explore: rank__sale_price__for_user__explore {#?name by the parent/child combination?
  #update 'my_explore' to your explore name
  extends:[my_explore]
  #?may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base). not sure if that's the case though. further testing required
  #update the from to match the input view name above
  join: rank__sale_price__for_user__view {sql:;;relationship:one_to_one}
#update the join name to match the ranking view defined above, and update the references to mach that same join name
  join: rank__sale_price__for_user {
    sql_on:
      ${rank__sale_price__for_user.child_unique_id}   =${rank__sale_price__for_user__view.input_child_unique_id__dimension} and
      ${rank__sale_price__for_user.parent_unique_id}  =${rank__sale_price__for_user__view.input_parent_unique_id__dimension} and
      ${rank__sale_price__for_user.order_by_dimension}=/**/${rank__sale_price__for_user__view.order_by_dimension};;
    relationship: many_to_one
  }# dev note:in case the unique_id field isn't really unique, this is more accurate. don't plan to measure things on the sequencing, so symmetric aggregates wont be invoked
}


### IF YOU WANTED ANOTHER COPY ON A DIFFERENT FIELD...
# rank sale price for user
view: rank__order_item__for_user__view {#?name by the parent/child combination?
  extends: [sequence_input]
  #Update with fields that are valid together in an explore:
  dimension: input_parent_unique_id__dimension  {sql:${order_items.user_id};;}
  dimension: input_child_unique_id__dimension   {sql:${order_items.id};;}
  dimension: order_by_dimension                 {sql:${order_items.id};;}#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
  dimension: order_by_descending_toggle         {sql:true;;}
  #(Customization): bind dimension references can be added here if necessary. Will have to list each explicitly here and in corresponding bind_filters parameter of the ranking view
  #dimension: age_and_gender_combo {sql:${users.age_and_gender_combo};;}
}
view: rank__order_item__for_user {
  extends:[sequencing_ndt]
  derived_table: {
    #update with the name of the input explore you defined
    explore_source: rank__order_item__for_user__explore { #(Customization): bind filters can be added here if necessary. List
      column: parent_unique_id  {field:rank__order_item__for_user__view.input_parent_unique_id__dimension}
      column: child_unique_id   {field:rank__order_item__for_user__view.input_child_unique_id__dimension}#
      column: order_by_dimension {field:rank__order_item__for_user__view.order_by_dimension}
      derived_column: sequence_number {sql:${EXTENDED} {{ rank__order_item__for_user__view.order_by_descending_text_for_sql._sql }});;}
      #bind_filters: {from_field: users.age_and_gender_combo to_field: sequence_input__order_item_for_gender__view.age_and_gender_combo} #bind filters where necessary... no way to pre-emptively bind all filters
    }
  }
}
explore: rank__order_item__for_user__explore {#?name by the parent/child combination?
  #update 'my_explore' to your explore name
  extends:[my_explore]
  #?may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base). not sure if that's the case though. further testing required
  #update the from to match the input view name above
  join: rank__order_item__for_user__view {sql:;;relationship:one_to_one}
#update the join name to match the ranking view defined above, and update the references to mach that same join name
  join: rank__order_item__for_user {
    sql_on:
      ${rank__order_item__for_user.child_unique_id}   =${rank__order_item__for_user__view.input_child_unique_id__dimension} and
      ${rank__order_item__for_user.parent_unique_id}  =${rank__order_item__for_user__view.input_parent_unique_id__dimension} and
      ${rank__order_item__for_user.order_by_dimension}=${rank__order_item__for_user__view.order_by_dimension};;
    relationship: many_to_one
  }# dev note:in case the unique_id field isn't really unique, this is more accurate. don't plan to measure things on the sequencing, so symmetric aggregates wont be invoked
}







######
### Toggle between inputs
### seems really ugly to template.. with the binding filters and all
# rank sale price for user
view: rank__order_item_for_user_with_toggle__view {#?name by the parent/child combination?
  extends: [sequence_input]
  #Update with fields that are valid together in an explore:
  dimension: input_parent_unique_id__dimension  {sql:${order_items.user_id};;}
  dimension: input_child_unique_id__dimension   {sql:${order_items.id};;}
  dimension: order_by_dimension                 {

    sql:
{% if select_order_by._parameter_value == 'order_items.id' %}
${order_items.id}
{% elsif select_order_by._parameter_value == 'order_items.sale_price' %}
${order_items.sale_price}
{% elsif select_order_by._parameter_value == 'order_items.returned_raw'%}
${order_items.returned_raw}
{% else %}
${order_items.created_raw}
{% endif %}
    ;;

    }#must be same as child field or have a one_to_one relationship (ie id and created_time is ok)
  dimension: order_by_descending_toggle         {sql:true;;}

  parameter: select_order_by {
    hidden: yes #this is controlled via bind filters from the ndt
    type: unquoted
    allowed_value: {
      label: "order_items.id"
      value: "order_items.id"
    }
    allowed_value: {
      label: "order_items.sale_price"
      value: "order_items.sale_price"
    }
    allowed_value: {
      label: "order_items.created_raw"
      value: "order_items.created_raw"
    }
    allowed_value: {
      label: "order_items.returned_raw"
      value: "order_items.returned_raw"
    }
  }

  #(Customization): bind dimension references can be added here if necessary. Will have to list each explicitly here and in corresponding bind_filters parameter of the ranking view
  #dimension: age_and_gender_combo {sql:${users.age_and_gender_combo};;}
}
view: rank__order_item_for_user_with_toggle {
  extends:[sequencing_ndt]
  derived_table: {
    #update with the name of the input explore you defined
    explore_source: rank__order_item_for_user_with_toggle__explore { #(Customization): bind filters can be added here if necessary. List
      column: parent_unique_id  {field:rank__order_item_for_user_with_toggle__view.input_parent_unique_id__dimension}
      column: child_unique_id   {field:rank__order_item_for_user_with_toggle__view.input_child_unique_id__dimension}#
      column: order_by_dimension {field:rank__order_item_for_user_with_toggle__view.order_by_dimension}
      bind_filters: {from_field: rank__order_item_for_user_with_toggle.select_order_by to_field: rank__order_item_for_user_with_toggle__view.select_order_by}
      derived_column: sequence_number {sql:${EXTENDED} {{ rank__order_item_for_user_with_toggle__view.order_by_descending_text_for_sql._sql }});;}
      #bind_filters: {from_field: users.age_and_gender_combo to_field: sequence_input__order_item_for_gender__view.age_and_gender_combo} #bind filters where necessary... no way to pre-emptively bind all filters
    }
  }
  parameter: select_order_by {
    type: unquoted
    allowed_value: {
      label: "order_items.id"
      value: "order_items.id"
    }
    allowed_value: {
      label: "order_items.sale_price"
      value: "order_items.sale_price"
    }
    allowed_value: {
      label: "order_items.created_raw"
      value: "order_items.created_raw"
    }
    allowed_value: {
      label: "order_items.returned_raw"
      value: "order_items.returned_raw"
    }
  }

}
explore: rank__order_item_for_user_with_toggle__explore {#?name by the parent/child combination?
  #update 'my_explore' to your explore name
  extends:[my_explore]
  #?may need to explicitly mention base view name of my_explore (if it's not set explicitly in the base). not sure if that's the case though. further testing required
  #update the from to match the input view name above
  join: rank__order_item_for_user_with_toggle__view {sql:;;relationship:one_to_one}
#update the join name to match the ranking view defined above, and update the references to mach that same join name
  join: rank__order_item_for_user_with_toggle {
    sql_on:
      ${rank__order_item_for_user_with_toggle.child_unique_id}   =${rank__order_item_for_user_with_toggle__view.input_child_unique_id__dimension} and
      ${rank__order_item_for_user_with_toggle.parent_unique_id}  =${rank__order_item_for_user_with_toggle__view.input_parent_unique_id__dimension} and
      ${rank__order_item_for_user_with_toggle.order_by_dimension}=
{% if rank__order_item_for_user_with_toggle.select_order_by._parameter_value == 'order_items.id' %}
${order_items.id}
{% elsif rank__order_item_for_user_with_toggle.select_order_by._parameter_value == 'order_items.sale_price' %}
${order_items.sale_price}
{% elsif rank__order_item_for_user_with_toggle.select_order_by._parameter_value == 'order_items.returned_raw'%}
${order_items.returned_raw}
{% else %}
${order_items.created_raw}
{% endif %}

      ;;
    relationship: many_to_one
  }# dev note:in case the unique_id field isn't really unique, this is more accurate. don't plan to measure things on the sequencing, so symmetric aggregates wont be invoked
}
