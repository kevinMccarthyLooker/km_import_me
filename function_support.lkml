#take 'input' entered in extending view, and gather up handy information.
#vvvvv Function Support #{

#no source tables used

view: parse_input {
  dimension: view_label {sql:__TEST-{{_view._name}}-input;;hidden:yes}

  dimension: input {
    view_label: "{{view_label._sql}}"
    sql:;;#input will be overriden by extending view
  }
  measure: measure_input {
    view_label: "{{view_label._sql}}"
    sql:;;#input will be overriden by extending view
  }
  dimension: input_sql_holder {
    view_label: "{{view_label._sql}}"
    sql:0/*${input}*/;;
  }#need to use a looker reference IN THE QUERY so that it gets fully converted to corresponding sql.  Uses comments so that this field doesn't change query results

  measure: measure_input_sql_holder {
#     type: string
    sql: 0/*${measure_input}*/ ;;
  }


# dimension: parsed_input1 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[0]}};; required_fields: [input_sql_holder]}
#   dimension: parsed_input1 {sql:{% assign my_array = input_sql_holder._sql | replace: '0/*','(' | remove: '*/' | replace: '^^',')' %}{{my_array[0]}};; required_fields: [input_sql_holder]}
  dimension: parsed_input1 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0] }};; required_fields: [input_sql_holder,measure_input_sql_holder] view_label: "{{view_label._sql}}"}
  dimension: parsed_input2 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[1] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[1] }};; required_fields: [input_sql_holder,measure_input_sql_holder] view_label: "{{view_label._sql}}"}
  dimension: parsed_input3 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[2] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[2] }};; required_fields: [input_sql_holder,measure_input_sql_holder] view_label: "{{view_label._sql}}"}
  dimension: parsed_input4 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[3] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[3] }};; required_fields: [input_sql_holder,measure_input_sql_holder] view_label: "{{view_label._sql}}"}
#}^^^
  dimension: input1_dimension {sql:(${parsed_input1});;}#wrap in parens to ensure correct calculations on ratios, etc.
  dimension: input2_dimension {sql:(${parsed_input2});;}
  dimension: input3_dimension {sql:(${parsed_input3});;}
  dimension: input4_dimension {sql:(${parsed_input4});;}

  measure: input1_measure {sql:(${parsed_input1});;}#wrap in parens to ensure correct calculations on ratios, etc.
  measure: input2_measure {sql:(${parsed_input2});;}
  measure: input3_measure {sql:(${parsed_input3});;}
  measure: input4_measure {sql:(${parsed_input4});;}




#   measure: parsed_measure_input {sql:{% assign my_array = measure_input_sql._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0] | prepend: '(' | append: ')'}};; required_fields: [measure_input_sql]}
#
#   measure: parsed_measure_input1_sql {sql:{% assign my_array = measure_input_sql._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0]}};; required_fields: [measure_input_sql]}
#   measure: parsed_measure_input1_measure {sql:{{ parsed_measure_input1_sql._sql | prepend: '(' | append: ')' }};; required_fields: [measure_input_sql]}
#
#
#   dimension: parsed_measure_input1_sql_as_dimension{sql:{% assign my_array = measure_input_sql._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0]}};; required_fields: [measure_input_sql]}

}









#use this version to keep fields hidden. The unhidden version can be used for testing
view: parse_input_hidden {
  extends: [parse_input]
  dimension: input            {hidden:yes}
  dimension: input_sql_holder {hidden:yes}
  dimension: parsed_input1    {hidden:yes}
  dimension: parsed_input2    {hidden:yes}
  dimension: parsed_input3    {hidden:yes}
  dimension: parsed_input4    {hidden:yes}
}

#defaults for the output field
view: output {
  dimension: output {
    label: "{{_view._name | replace: '_',' ' }}"
    sql: 'function error: this sql should be overridden' ;;#will be overriden
  }
}
#}<<<
#^^^^ END Function Support
