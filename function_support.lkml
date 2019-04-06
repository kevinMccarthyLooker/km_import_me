#vvvvv Function Support #{

#no source tables used

view: parse_input {
  view_label: "for testing - {{_view._name}}"
  dimension: input {sql:;;}#input will be overriden by extending view
dimension: input_sql_holder {sql:0/*${input}*/;;}#need to use a looker reference in view so that it gets fully converted to corresponding sql.  Uses comments so that this field doesn't change query results
dimension: parsed_input1 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[0]}};; required_fields: [input_sql_holder]}
dimension: parsed_input2 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[1]}};; required_fields: [input_sql_holder]}
dimension: parsed_input3 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[2]}};; required_fields: [input_sql_holder]}
dimension: parsed_input4 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[3]}};; required_fields: [input_sql_holder]}
#vvv More slots{
# dimension: parsed_input5 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[4]}};; required_fields: [input_sql_holder]}
# dimension: parsed_input6 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[5]}};; required_fields: [input_sql_holder]}
# dimension: parsed_input7 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[6]}};; required_fields: [input_sql_holder]}
# dimension: parsed_input8 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[7]}};; required_fields: [input_sql_holder]}
# dimension: parsed_input9 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[8]}};; required_fields: [input_sql_holder]}
#}^^^
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
#vvv More slots{
#   dimension: parsed_input5    {hidden:yes}
#   dimension: parsed_input6    {hidden:yes}
#   dimension: parsed_input7    {hidden:yes}
#   dimension: parsed_input8    {hidden:yes}
#   dimension: parsed_input9    {hidden:yes}
#}^^^
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
