### Functions Examples
## General patterns is that you'll set sql of an 'input' fields to point to another field in your model, and you'll extend to inherit the 'Output' field
## May include fomrat settings, etc
include: "function_support"

view: safe_divide{
  extends: [input,output]
  dimension: divide_by {hidden:yes}
  dimension: output{
    hidden: no
    sql:${input}*1.0/nullif(${divide_by},0) ;;
    type:number
    value_format_name:decimal_1
  }
}

view: acronymize {
  extends: [input,output]
  dimension: output {
    sql:
left(split_part(${input},' ',1),1)||left(split_part(${input},' ',2),1)||
left(split_part(${input},' ',3),1)||left(split_part(${input},' ',4),1)||
left(split_part(${input},' ',5),1)||left(split_part(${input},' ',6),1)||
left(split_part(${input},' ',7),1)||left(split_part(${input},' ',8),1)||
left(split_part(${input},' ',9),1)||left(split_part(${input},' ',10),1)
     ;;
    type:string
  }
}

view: min_maxify_dimension {
  extends: [output]
  dimension: input_min {hidden:yes}
  dimension: input_max {hidden:yes}
  dimension: input_field {hidden:yes}
  dimension: output {
    hidden: no
#     {% if _dialect._name == 'redshift' %}
#     sql:
# {% if _dialect._name == 'redshift' %}
#   least(greatest(${input_field},${input_min}),greatest(${input_max},${input_min}))
# {% else %}
#   case when ${input_field}<${input_min} then ${input_min}
#   else
#     case when ${input_field}>${input_max} then ${input_max}
#     else ${input_field}
#     end
#   end
# {% endif %}
#     ;;
sql:
case when
${input_field}
>
${input_min}
then --exceed minimum:
  case when
${input_field}
>
${input_max}
  then --exceeds max:
${input_max}
  else --between min and max:
${input_field}
  end
else --less than minimum:
${input_min}
end
;;
  }
}
