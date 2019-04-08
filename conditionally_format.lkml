### Functions Examples
## General patterns is that you'll set sql of an 'input' fields to point to another field in your model, and you'll extend to inherit the 'Output' field
## May include fomrat settings, etc
include: "function_support"

view: conditionally_format__field_number__threshold_number {
  extends: [parse_input_hidden,output]
  dimension: meets_threshold {
    type: number
    sql: case when ${parsed_input1}>=${parsed_input2} then 1 else 0 end;;
  }
  dimension: output {
    sql: ${parsed_input1} ;;
#     sql: case when ${parsed_input1}>=${parsed_input2} then 'meets' else 'doesnt meet' end ;;
    html: <div align="center" style="width:100%; color:white; background:{% if meets_threshold._value == 1 %}green{% else %}black{% endif %};">{{rendered_value}}{% if meets_threshold._value == 1 %} 😁{% else %} 😡{% endif %}
</div> ;;
    type: number
  }

  measure: max_meets_threshold {
    label: "😁 or 😡(max_meets_threshold)"
    type: max
    sql: ${meets_threshold} ;;
    html: <div align="center" style="width:100%; color:white; background:{% if value == 1 %}green{% else %}black{% endif %};">{% if value == 1 %} 😁{% else %} 😡{% endif %}
    </div> ;;
  }

  measure: min_meets_threshold {
    label: "😁 or 😡(min_meets_threshold)"
    type: min
    sql: ${meets_threshold} ;;
    html: <div align="center" style="width:100%; color:white; background:{% if value == 1 %}green{% else %}black{% endif %};">{% if value == 1 %} 😁{% else %} 😡{% endif %}
      </div> ;;
  }


  dimension: parsed_input2_no_parens {
    #removes the first and last characters where we've added parens
    sql:
    {% assign sql = parsed_input2._sql %}
    {% assign sql = sql | slice: 1,sql.size %}
    {% assign sql = sql | split: "" | reverse | join: "" %}
    {% assign sql = sql | slice: 1,sql.size %}
    {% assign sql = sql | split: "" | reverse | join: "" %}
    {{ sql }} ;;
  }

  measure:  parsed_measure_input {
    type: number
    html:
    {% assign threshold = parsed_input2_no_parens._sql | times: 1.0 %}
    <div align="center" style="width:100%; color:white; background:{% if value > threshold %}green{% else %}black{% endif %};">{% if value > threshold %} >1{% else %} not >1{% endif %}</div> ;;
    required_fields: [parsed_input2]
#     html: {{value}} - {{parsed_input2_no_parens._sql}};;
  }
# parsed_input2_no_parens._sql

}

#^^^^ End Functions
#
