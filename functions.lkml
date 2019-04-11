### Functions Examples
## General patterns is that you'll set sql of an 'input' fields to point to another field in your model, and you'll extend to inherit the 'Output' field
## May include fomrat settings, etc
include: "function_support"
#vvvv Functions {
#vvvv
view: safe_divide{
  extends: [parse_input,output]
  dimension: output{
    hidden: no
    sql:${parsed_input1}*1.0/nullif(${parsed_input2},0) ;;
    type:number
    value_format_name:decimal_1
  }
}

view: acronymize {
  extends: [parse_input,output]
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

# view: min_maxify_dimension {
#   extends: [parse_input,output]
#   dimension: output {
# sql:
# case when ${input1_dimension}<${input2_dimension}
#   then ${input2_dimension}
#   else
#     case
#     when ${input1_dimension}>${input3_dimension}
#       then ${input3_dimension}
#     else ${input1_dimension}
#     end
# end
# ;;
#   }
# }

view: min_maxify_dimension {
  extends: [output]
  dimension: input_min {hidden:yes}
  dimension: input_max {hidden:yes}
  dimension: input_field {hidden:yes}
  dimension: output {
    hidden: no
#     {% if _dialect._name == 'redshift' %}

    sql:
{% if _dialect._name == 'redshift' %}
  least(greatest(${input_field},${input_min}),greatest(${input_max},${input_min}))
{% else %}
  case when ${input_field}<${input_min} then ${input_min}
  else
    case when ${input_field}>${input_max} then ${input_max}
    else ${input_field}
    end
  end
{% endif %}
    ;;
  }
}
view: min_maxify_dimension_unhidden {
  extends: [ min_maxify_dimension]
  dimension: input_field  {hidden: no group_label:"{{_view._name}}(hidden fields)"}
  dimension: input_min    {hidden: no group_label:"{{_view._name}}(hidden fields)"}
  dimension: input_max    {hidden: no group_label:"{{_view._name}}(hidden fields)"}
  dimension: output       {hidden: no group_label:"{{_view._name}}(hidden fields)"}
}

view: smiley_emojis_percent {
  extends: [parse_input]
  measure: output {
#     type: max
    sql: ${input1_dimension} ;;
    html:
<div style="font-size:12px;">
    {% assign n = value %}
    {% assign break = 10 %}
    {% assign break_counter = 0 %}
    {% assign cell_break = 10 %}
    {% assign cell_break_counter = 0 %}
    {% for num in (1..100) %}
{% assign integer_representation = value | times: 100 %}

{% if num < integer_representation %}
<span style="background-color:#a4f442;">😀</span>
{% else %}
<span style="background-color:#f47741;">😡</span>
{% endif %}
     {% assign break_counter = break_counter | plus: 1 %}
     {% if break_counter >= break %}
        <br>
        {% assign break_counter = 0 %}
        {% assign cell_break_counter = cell_break_counter | plus: 1 %}
          {% if cell_break_counter >= cell_break %}
            <br>
            {% assign cell_break_counter = 0 %}
          {% endif %}
      {% endif %}
    {% endfor %}
</div>
    ;;
  }
}

view: smiley_emojis {
  extends: [parse_input]
  measure: output {
    sql: ${input1_dimension} ;;
    html:
    {% assign n = value %}
    {% assign break = 10 %}
    {% assign break_counter = 0 %}
    {% assign cell_break = 10 %}
    {% assign cell_break_counter = 0 %}
    {% for num in (1..n) %}
😀
     {% assign break_counter = break_counter | plus: 1 %}
     {% if break_counter >= break %}
        <br>
        {% assign break_counter = 0 %}
        {% assign cell_break_counter = cell_break_counter | plus: 1 %}
          {% if cell_break_counter >= cell_break %}
            <br>
            {% assign cell_break_counter = 0 %}
          {% endif %}
      {% endif %}
    {% endfor %}
    </tr>
    </table>

    ;;
    }
  }


view: smiley_emojis_pile {
  extends: [parse_input,output]
  dimension: input_emoji {sql:;;}
  dimension: default_emoji {
    sql:😀;;
  }
  dimension: final_emoji {
    sql: {% if input_emoji._sql >'' %}{{input_emoji._sql}}{% else %}{{default_emoji._sql}}{% endif %} ;;
    required_fields: [input1_dimension]

  }

  measure: output_measure {
    sql: ${input1_dimension} ;;
#     required_fields: [final_emoji]
    html:
<div align="center" style="font-size:18px;">

    {% assign n = value %}
    {% assign break = 1 %}
    {% assign break_counter = 0 %}
    {% for num in (1..n) %}
{{final_emoji._sql}}
     {% assign break_counter = break_counter | plus: 1 %}
     {% if break_counter >= break %}
        <br>

        {% assign break_counter = 0 %}
        {% assign break = break | plus: 2 %}
      {% endif %}
    {% endfor %}
</div>
    ;;
  }
}


view: if_dimension_equals_value_then_emoji_else_other_emoji {
  extends: [parse_input]
  dimension: input_dimension {}
  dimension: value {sql:15;;}
  dimension: emoji {sql:😀;;}
  dimension: other_emoji {sql:😡;;}
  dimension: meets_criteria {
    sql:case when ${input_dimension}>=${value} then 1 else 0 end;;
  }
  dimension: output {
    required_fields: [input_dimension]
    sql: ${input_dimension};;
    html:  {% if meets_criteria._value == 1 %}{{emoji._sql}}{% else %}{{other_emoji._sql}}{%endif%};;
  }

}
