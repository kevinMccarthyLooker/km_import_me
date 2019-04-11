######
### MULTIPLE DIFFERENT versions of users base table(s)
######
include: "functions"
#testing adding above view instead of in explore:
view: user_age_30_to_40{extends:[min_maxify_dimension]
  dimension: input_min    {sql:30;;}
  dimension: input_max    {sql:40;;}
  dimension: input_field  {sql:${users.age};;}
  dimension: output {
    #override output format here. Otherwise it will appear using the view name.
    label: "{{_view._name | replace: '_',' ' }}"
    view_label: "Users"
  }
}
view: user_age_30_to_param{extends:[min_maxify_dimension]
  dimension: input_min    {sql:30;;}
  dimension: input_max    {sql:{% parameter users.integer_input_test %};;}
  dimension: input_field  {sql:${users.age};;}
  dimension: output {
    #override output format here. Otherwise it will appear using the view name.
    label: "{{_view._name | replace: '_',' ' }}"
    view_label: "Users"
  }
}

# explore: user_age_30_to_40 {view_name:users hidden:yes join: user_age_30_to_40 {sql:;; relationship: one_to_one}}
#extend users explores to include this like: extends: [user_age_30_to_40]
#add the following join in explore: join: user_age_30_to_40 {sql:;; relationship: one_to_one}

#Typical setup, but with minimal fields for clarity
view: users{
  parameter: integer_input_test {type:number}
  sql_table_name: public.users ;;
  dimension: id {primary_key:yes}
  dimension_group: created
  {
    type: time
    timeframes: [raw,date,month]
  }
  dimension: age {type:number}
  dimension: latitude {type: number}
  measure: count {type: count}
  dimension_group: now {
    datatype: timestamp
    type: time
    timeframes: [raw,date]
    sql: getdate() ;;
  }
  dimension: days_since_joined {
    type: duration_day
    sql_start:  ${created_date};;
    sql_end: ${now_date} ;;
  }
}


####################################
# For demo of adding basic standards
# Here we follow the approach of creating an explicit field called primary_key, and assign our normal primary_key in the sql parameter, so we can use standard count(etc) definitions.
# So, in this approach, we plan to extend the following simple view, which will add things like Count, primary_key_range, or some other standards
view: users__for_standards {
  sql_table_name: public.users ;;
  dimension: id {}
  dimension: primary_key {sql:${id};;}
  dimension: age {}
  dimension_group: created {type:time sql:${TABLE}.created_at;;}
}

#demo adding 'standards.  The actual base table should be added last so that it overrides the underlying explore
include: "to_be_extended_direct_on_views"
view: users__standards_applied{extends: [primary_key_and_counts,users__for_standards]}
#but is the view pattern better than this anyway?



##################################
# include: "main"
# include:"to_be_extended_direct_on_views"
# include: "custom_tiers"
# view: users__direct_extension__old {
#   sql_table_name: public.users ;;
#
# ####### Primary_key_and_counts support.  Extends imported view in imported project
#   extends: [primary_key_and_counts,compare_using_cutoff_parameter]
#   dimension: primary_key {sql:${id};;}
#   dimension: field_to_compare {sql:${age};;}
# #######
#
#   dimension: id {}
#   dimension_group: created
#   {
#     type: time
#     timeframes: [raw,date,month]
#   }
#   dimension: age {type:number}
#   dimension: latitude {type: number}
#   #measure count is imported
#   measure: my_count {
#     type: number
#     sql: ${count} ;;
#   }
# }
