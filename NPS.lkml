include: "function_support"
view: nps {
  measure: another_measure {type:sum sql:1;;}
  dimension: primary_key { primary_key:yes}
  dimension: promoters {hidden:yes}
  dimension: detractors {hidden:yes}
  dimension: neutrals {hidden:yes}
  dimension: output {
    type: number
    sql:round(100*(${promoters}-${detractors})*1.0/nullif((${promoters}+${detractors}+${neutrals}),0));;
# html:
# {%assign promos = promoters._value %}
# {%assign detracts = detractors._value %}
# {%assign neuts = neutrals._value %}
# {%assign min_promos_detractors = promos %}
# {%if min_promos_detractors > detracts %}
#   {%assign min_promos_detractors = detracts %}
# {%endif%}
# {% assign remaining_promos = promos | minus: min_promos_detractors %}
# {%if remaining_promos < 0 %}
#   {%assign remaining_promos = 0 %}
# {%endif%}
# {% assign remaining_detracts = detracts | minus: min_promos_detractors %}
# {%if remaining_detracts < 0 %}
#   {%assign remaining_detracts = 0 %}
# {%endif%}
# <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# <br>
# <br>
# <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# ;;
    html:
    {%assign promos = promoters._value %}
    {%assign detracts = detractors._value %}
    {%assign neuts = neutrals._value %}
    {%assign min_promos_detractors = promos %}
    {%if min_promos_detractors > detracts %}
    {%assign min_promos_detractors = detracts %}
    {%endif%}
    {% assign remaining_promos = promos | minus: min_promos_detractors %}
    {%if remaining_promos < 0 %}
    {%assign remaining_promos = 0 %}
    {%endif%}
    {% assign remaining_detracts = detracts | minus: min_promos_detractors %}
    {%if remaining_detracts < 0 %}
    {%assign remaining_detracts = 0 %}
    {%endif%}
    Net: ({{promos| round}} - {{detracts | round}}) / {{promos | plus: detracts | plus: neuts | round}} = {{rendered_value}}<br>
    <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
    <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
    <br>
    <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
    ;;
# {{promos}}
# {{detracts}}
# {{neuts}}
# -
# {{remaining_promos}}
# -
# {{remaining_detracts}}
}

  measure: promoters_measure {}
  measure: detractors_measure {}
  measure: neutrals_measure {}
  measure: output_measure_explanation {
    sql:
    'Net: ('||${promoters_measure}||' - '||${detractors_measure}||') / '||${promoters_measure}||' + '||${neutrals_measure}||' = '||${output_measure}
    ;;
  }
  measure: output_measure {
    type: number
    sql:

    round(100*(${promoters_measure}-${detractors_measure})*1.0/nullif((${promoters_measure}+${detractors_measure}+${neutrals_measure}),0))
    ;;
# html:
# {%assign promos = promoters._value %}
# {%assign detracts = detractors._value %}
# {%assign neuts = neutrals._value %}
# {%assign min_promos_detractors = promos %}
# {%if min_promos_detractors > detracts %}
#   {%assign min_promos_detractors = detracts %}
# {%endif%}
# {% assign remaining_promos = promos | minus: min_promos_detractors %}
# {%if remaining_promos < 0 %}
#   {%assign remaining_promos = 0 %}
# {%endif%}
# {% assign remaining_detracts = detracts | minus: min_promos_detractors %}
# {%if remaining_detracts < 0 %}
#   {%assign remaining_detracts = 0 %}
# {%endif%}
# <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# <br>
# <br>
# <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# ;;
#this version tries to highlight the net by pairing promoters and detracters
#     html:
#     <div align="left">
#     {%assign promos = promoters_measure._value %}
#     {%assign detracts = detractors_measure._value %}
#     {%assign neuts = neutrals_measure._value %}
#     {%assign min_promos_detractors = promos %}
#     {%if min_promos_detractors > detracts %}
#     {%assign min_promos_detractors = detracts %}
#     {%endif%}
#     {% assign remaining_promos = promos | minus: min_promos_detractors %}
#     {%if remaining_promos < 0 %}
#     {%assign remaining_promos = 0 %}
#     {%endif%}
#     {% assign remaining_detracts = detracts | minus: min_promos_detractors %}
#     {%if remaining_detracts < 0 %}
#     {%assign remaining_detracts = 0 %}
#     {%endif%}
#     <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
#     <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
#     <br>
#     <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
#     </div>
#     ;;
    html:
    <div align="left">
    {%assign promos = promoters_measure._value %}
    {%assign detracts = detractors_measure._value %}
    {%assign neuts = neutrals_measure._value %}
    <span style="background-color:#a9c574;">{% for i in (1..promos) %}😀{%assign mod = i | modulo: 10 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
    <br>
    <span style="background-color:##b55656;">{% for i in (1..detracts) %}😡{%assign mod = i | modulo: 10 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>{%comment%}
{%endcomment%}<span style="background-color:#929292;">{% for i in (1..neuts) %}🤖{%assign mod = i | modulo: 10 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
    </div>
    ;;
#replaced with a separate field
#     Net: ({{promos| round}} - {{detracts | round}}) / {{promos | plus: detracts | plus: neuts | round}} = {{rendered_value}}<br>

# {{promos}}
# {{detracts}}
# {{neuts}}
# -
# {{remaining_promos}}
# -
# {{remaining_detracts}}
  }

}
