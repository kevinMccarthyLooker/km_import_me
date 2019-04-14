include: "function_support"

view: emojis {
  extends: [input,output]
  dimension: default_emoji {
    hidden: yes
    sql:😀;;
  }
  dimension: input_emoji {
    hidden: yes
    sql:;;
  }
  dimension: final_emoji {
    hidden: yes
    sql: {% if input_emoji._sql >'' %}{{input_emoji._sql}}{% else %}{{default_emoji._sql}}{% endif %} ;;
  }
  dimension: alternate_emoji {
    hidden: yes
    sql:😡;;
  }
  dimension: default_emojis_per_row {
    hidden: yes
    sql:10;;
  }
  dimension: input_emojis_per_row {
    hidden: yes
    sql:;;
  }
  dimension: final_emojis_per_row {
    hidden: yes
    sql: {% if input_emojis_per_row._sql >'' %}{{input_emojis_per_row._sql}}{% else %}{{default_emojis_per_row._sql}}{% endif %} ;;
  }
  dimension: default_break_every_x_rows {
    hidden: yes
    sql:10;;
  }
  dimension: input_break_every_x_rows {
    hidden: yes
    sql:;;
  }
  dimension: final_break_every_x_rows {
    hidden: yes
    sql: {% if input_break_every_x_rows._sql >'' %}{{input_break_every_x_rows._sql}}{% else %}{{default_break_every_x_rows._sql}}{% endif %} ;;
  }
  dimension: default_max_size_px {
    hidden: yes
    sql:10;;
  }
  dimension: input_max_size_px {
    hidden: yes
    sql:;;
  }
  dimension: final_max_size_px {
    hidden: yes
    sql: {% if input_max_size_px._sql >'' %}{{input_max_size_px._sql}}{% else %}{{default_max_size_px._sql}}{% endif %} ;;
  }
  dimension: default_min_size_px {
    hidden: yes
    sql:10;;
  }
  dimension: input_min_size_px {
    hidden: yes
    sql:;;
  }
  dimension: final_min_size_px {
    hidden: yes
    sql: {% if input_min_size_px._sql >'' %}{{input_min_size_px._sql}}{% else %}{{default_min_size_px._sql}}{% endif %} ;;
  }
  measure: number_iterations {
    hidden: yes
    sql:${measure_input};;
  }
  measure: threshold {
    hidden: yes
    sql:${measure_input};;
  }
  measure: output_measure {
    hidden: no
    sql: ${measure_input} ;;
#   <span style="background-color:#a4f442;">😀</span>
html:
{%assign final_px = final_max_size_px._sql | times: 1.0 %}
{%assign number_iterations_denominator = number_iterations._value | times: 1.0 %}
{% assign adjusted_px_calc = 2400.0 | divided_by: number_iterations_denominator | times: 1.0 %}
{%if adjusted_px_calc < final_px %}{%assign final_px = adjusted_px_calc %}{%endif%}
{%assign specified_min_size = final_min_size_px._sql | times: 1.0 %}
{%if final_px < specified_min_size %}{%assign final_px = specified_min_size %}{%endif%}
<div style="font-size:{{final_px}}px;">
{% assign n = number_iterations._value %}
{% assign break = final_emojis_per_row._sql | times: 1.0 %}
{% assign break_counter = 0 %}
{% assign cell_break = final_break_every_x_rows._sql | times: 1.0 %}
{% assign cell_break_counter = 0 %}
{% assign cell_break_breakpoint = break | times: cell_break %}
{% for num in (1..n) %}
{% assign integer_representation = threshold._value | times: 1 %}
{% if num <= integer_representation %}
{{final_emoji._sql}}
{% else %}
{{alternate_emoji._sql}}
{% endif %}
{% assign break_check = num | modulo: break %}
{% if break_check == 0 %}<br>{% endif %}
{% assign cell_break_check = num | modulo: cell_break_breakpoint %}
{% if cell_break_check == 0 %}<br>{% endif %}
{% endfor %}
<br>
</div>
    ;;
  }
}

##############
# update defaults to automatically handle percents in a certain way
  view: emojis_percent {
    extends: [input,output,emojis]
    measure: number_iterations {sql:100;;}
    dimension: final_break_every_x_rows {sql: 10 ;;}
    dimension: final_emojis_per_row {sql: 10;;}
    measure: threshold {sql:${measure_input}*100.0;;}
  }

############
# silly 'pile' format
view: smiley_emojis_pile {
  extends: [input,output,emojis]
  measure: output_measure {
    hidden: no
    sql: ${measure_input} ;;
    html:
    <div align="center" style="font-size:6px;">
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

##########
# conditionally format with emoji
view: emoji_conditionally_format_by_threshold {
  extends: [input,output,emojis]
  dimension: static_threshold_input {
    hidden:yes
    sql:100;;
  }
  dimension: meets_criteria {
#     required_fields: [input,static_threshold_input]
    hidden: yes
    sql:(case when ${input}>=${static_threshold_input} then 1 else 0 end);;
  }
  dimension: output {
    hidden: no
    sql: ${input};;
    html: {{rendered_value}} {% if  meets_criteria._value == 1 %}{{final_emoji._sql}}{% else %}{{alternate_emoji._sql}}{%endif%};;
  }
  measure: output_measure {hidden: yes}

}
