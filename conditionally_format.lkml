### Functions Examples
## General patterns is that you'll set sql of an 'input' fields to point to another field in your model, and you'll extend to inherit the 'Output' field
## May include format settings, etc
#was originally build using a dimension input, then changed to a measure, so could use some more cleanup
include: "function_support"

view: conditionally_format__measure__threshold_measure {
  extends: [input,output]
  measure: threshold_measure {
    hidden:yes
    sql:0;;
  }
  measure: meets_threshold_measure {
    hidden: yes
    type: number
#     sql: case when ${parsed_input1}>=${parsed_input2} then 1 else 0 end;;
    sql: case when ${threshold_measure}>=${threshold_measure} then 1 else 0 end;;
  }
  measure: output_measure {
    hidden: no
    type: number
    sql: ${measure_input} ;;
#     sql: case when ${parsed_input1}>=${parsed_input2} then 'meets' else 'doesnt meet' end ;;
    html: <div align="center" style="width:100%; color:white; background:{% if meets_threshold_measure._value == 1 %}green{% else %}black{% endif %};">{{rendered_value}}{% if meets_threshold_measure._value == 1 %} 😁{% else %} 😡{% endif %}</div> ;;
  }

}
