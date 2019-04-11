#take 'input' entered in extending view, and gather up handy information.
#vvvvv Function Support #{

#no source tables used

view: parse_input {
  view_label: "{{_view._name}}"
#   dimension: view_label {
#     hidden:yes
#     sql: TEST-{{_view._name}};;
#   }

  dimension: input {
    hidden: yes
#     view_label: "{{view_label._sql}}"
    sql:;;#input will be overriden by extending view
  }
  measure: measure_input {
    hidden: yes
#     view_label: "{{view_label._sql}}"
    sql:;;#input will be overriden by extending view
  }
  dimension: input_sql_holder {
    hidden: yes
#     view_label: "{{view_label._sql}}"
    sql:0/*${input}*/;;
  }#need to use a looker reference IN THE QUERY so that it gets fully converted to corresponding sql.  Uses comments so that this field doesn't change query results

  measure: measure_input_sql_holder {
    hidden: yes
#     type: string
    sql: 0/*${measure_input}*/ ;;
  }


# dimension: parsed_input1 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[0]}};; required_fields: [input_sql_holder]}
#   dimension: parsed_input1 {sql:{% assign my_array = input_sql_holder._sql | replace: '0/*','(' | remove: '*/' | replace: '^^',')' %}{{my_array[0]}};; required_fields: [input_sql_holder]}
  dimension: parsed_input1 {hidden: yes sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0] }};; required_fields: [input_sql_holder,measure_input_sql_holder]}
  dimension: parsed_input2 {hidden: yes sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[1] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[1] }};; required_fields: [input_sql_holder,measure_input_sql_holder]}
  dimension: parsed_input3 {hidden: yes sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[2] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[2] }};; required_fields: [input_sql_holder,measure_input_sql_holder]}
  dimension: parsed_input4 {hidden: yes sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[3] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[3] }};; required_fields: [input_sql_holder,measure_input_sql_holder]}
#}^^^
  dimension: input1_dimension {hidden: yes sql:(${parsed_input1});;}#wrap in parens to ensure correct calculations on ratios, etc.
  dimension: input2_dimension {hidden: yes sql:(${parsed_input2});;}
  dimension: input3_dimension {hidden: yes sql:(${parsed_input3});;}
  dimension: input4_dimension {hidden: yes sql:(${parsed_input4});;}

  measure: input1_measure {hidden: yes sql:(${parsed_input1});;}#wrap in parens to ensure correct calculations on ratios, etc.
  measure: input2_measure {hidden: yes sql:(${parsed_input2});;}
  measure: input3_measure {hidden: yes sql:(${parsed_input3});;}
  measure: input4_measure {hidden: yes sql:(${parsed_input4});;}

#   measure: parsed_measure_input {sql:{% assign my_array = measure_input_sql._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0] | prepend: '(' | append: ')'}};; required_fields: [measure_input_sql]}
#
#   measure: parsed_measure_input1_sql {sql:{% assign my_array = measure_input_sql._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0]}};; required_fields: [measure_input_sql]}
#   measure: parsed_measure_input1_measure {sql:{{ parsed_measure_input1_sql._sql | prepend: '(' | append: ')' }};; required_fields: [measure_input_sql]}
#
#
#   dimension: parsed_measure_input1_sql_as_dimension{sql:{% assign my_array = measure_input_sql._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0]}};; required_fields: [measure_input_sql]}

}


#use this version to keep fields hidden. The unhidden version can be used for testing
view: parse_input_unhidden {
  extends: [parse_input]
  dimension: input            {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  dimension: input_sql_holder {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  dimension: parsed_input1    {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  dimension: parsed_input2    {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  dimension: parsed_input3    {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  dimension: parsed_input4    {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  dimension: input1_dimension {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  dimension: input2_dimension {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  dimension: input3_dimension {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  dimension: input4_dimension {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  measure: input1_measure     {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  measure: input2_measure     {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  measure: input3_measure     {group_label:"{{_view._name}}(hidden fields)" hidden:no}
  measure: input4_measure     {group_label:"{{_view._name}}(hidden fields)" hidden:no}
}




#defaults for the output field
view: output {
  view_label: "{{_view._name}}"
  dimension: output {
    hidden: yes #unhide in extending view when using
#     view_label: " DEFAULT TO BE OVERRIDDEN" # don't put a view label if you want to be able to override from the view or join
    label: "{{_view._name | replace: '_',' ' }}"
    sql: ' DEFAULT TO BE OVERRIDDEN' ;;
  }
  measure: output_measure {
    hidden: yes #unhide in extending view when using
#     view_label: " DEFAULT TO BE OVERRIDDEN"
    label: "{{_view._name | replace: '_',' ' }}"
    sql: ' DEFAULT TO BE OVERRIDDEN' ;;
  }

}
#}<<<
#^^^^ END Function Support
