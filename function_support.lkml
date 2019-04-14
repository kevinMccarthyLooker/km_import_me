#This view will set base defaults for fields which may be enabled in various functions
view: input {
  view_label: "{{_view._name}}"

  #Sometimes you will need to bring a dimension into the query in order to access the fully resolved sql...
  #but you don't want selecting the dimension to change the grain of the results...
  #can us some manipulation of sql commenting to get that done
  dimension: input {hidden: yes}
  dimension: input_sql_holder {
    # required_fields: [input]
    hidden: yes
    sql:0/*${input}*/;;#need to use a looker reference IN THE QUERY so that it gets fully converted to corresponding sql.  Uses comments so that this field doesn't change query results
  }
  # measure: measurify_input {
  #   required_fields: [input_sql_holder]
  #   sql:
  #   {% assign input_to_parse = input_sql_holder._sql | append: '^^' %}
  #   {% assign my_array = input_to_parse | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}
  #   max({{my_array[0]}})
  #   ;;
  #   }
    # {% assign my_array = input_to_parse | replace: '0/*','(' | remove: '*/' | replace: '^^',')' %}{{my_array[0]}}

# {% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[1] }}
    measure: measure_input {hidden: yes}
}

#defaults for the output field
view: output {
  view_label: "{{_view._name}}"
  dimension: output {
    hidden: yes #unhide in extending view when using
    view_label: "{{_view._name | replace: '_',' ' }}"
    label: "{{_view._name | replace: '_',' ' }}"
    sql: ' DEFAULT TO BE OVERRIDDEN' ;;
  }
  measure: output_measure {
    type: number
    hidden: yes #unhide in extending view when using
    view_label: "{{_view._name | replace: '_',' ' }}"
    #     view_label: "{{_view.view_label__sql_placeholder._sql | replace: \"''/*\", '' | replace: \"*/\", '' }}"
    label: "{{_view._name | replace: '_',' ' }}"
    sql: ' DEFAULT TO BE OVERRIDDEN' ;;
  }
}
