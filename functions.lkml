### Functions Examples
## General patterns is that you'll set sql of an 'input' fields to point to another field in your model, and you'll extend to inherit the 'Output' field
## May include fomrat settings, etc
include: "function_support"
#vvvv Functions {
#vvvv
view: safe_divide
{
  extends: [parse_input,output]
  dimension: output
  {
    sql:${parsed_input1}*1.0/nullif(${parsed_input2},0) ;;
    type:number
    value_format_name:decimal_1
  }
}

view: acronymize {
  extends: [parse_input_hidden,output]
  dimension: output {
    sql:
    {% assign v = parsed_input1._sql | size%}{% if v > 0  %}(left(${parsed_input1},1)){% endif %}
    {% assign v = parsed_input2._sql | size%}{% if v > 0  %}||(left(${parsed_input2},1)){% endif %}
    {% assign v = parsed_input3._sql | size%}{% if v > 0  %}||(left(${parsed_input3},1)){% endif %}
    {% assign v = parsed_input4._sql | size%}{% if v > 0  %}||(left(${parsed_input4},1)){% endif %}
    ;;
    type:string
  }
}

view: min_maxify_dimension {
  extends: [parse_input_hidden,output]
  dimension: output {
    sql:
case when ${input1_dimension}<${input2_dimension} then ${input2_dimension}
else
  case when ${input1_dimension}>${input3_dimension} then ${input3_dimension}
  else ${input1_dimension}
  end
end
;;
  }
}


#}<<<

# view: conditionally_format__field_number__threshold_number {
#   extends: [parse_input_hidden,output]
#   dimension: meets_threshold {
#     type: number
#     sql: case when ${parsed_input1}>=${parsed_input2} then 1 else 0 end;;
#   }
#   dimension: output {
#     sql: ${parsed_input1} ;;
# #     sql: case when ${parsed_input1}>=${parsed_input2} then 'meets' else 'doesnt meet' end ;;
#     html: <div align="center" style="width:100%; color:white; background: {% if meets_threshold._value == 1 %}green{% else %}red{% endif %};" >{{rendered_value}}</div> ;;
#     type: number
# #       case: {
# #         when:{
# #           sql:${parsed_input1}>=${parsed_input2};;
# #           label: "meets"
# #         }
# #         else: "doesn't meet threshold"
# #       }
# #     type: string
# #     html: {{parsed_input1._rendered_value}} ;;
# # html: t ;;
#   }
# }

#^^^^ End Functions
