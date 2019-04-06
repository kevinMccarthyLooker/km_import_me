include: "function_support"
#vvvv Functions {
#vvvv
view: safe_divide
{
  extends: [parse_input_hidden,output]
  dimension: output
  {
    sql:(${parsed_input1})*1.0/nullif(${parsed_input2},0) ;;
    type:number
    value_format_name:decimal_1
  }
}

view: acronymize {
  extends: [parse_input_hidden,output]
  dimension: output
  {
    sql:
    {% assign v = parsed_input1._sql | size%}{% if v > 0  %}(left(${parsed_input1},1)){% endif %}
    {% assign v = parsed_input2._sql | size%}{% if v > 0  %}||(left(${parsed_input2},1)){% endif %}
    {% assign v = parsed_input3._sql | size%}{% if v > 0  %}||(left(${parsed_input3},1)){% endif %}
    {% assign v = parsed_input4._sql | size%}{% if v > 0  %}||(left(${parsed_input4},1)){% endif %}
    ;;
    type:string
  }
}
#}<<<
#^^^^ End Functions
