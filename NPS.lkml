include: "function_support"
view: nps {
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
# <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign is_odd = i | modulo: 2 %}{%if is_odd == 0 %}|{%endif%}{% endfor %}</span>
# <br>
# <br>
# <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign is_odd = i | modulo: 2 %}{%if is_odd == 0 %}|{%endif%}{% endfor %}</span>
# <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign is_odd = i | modulo: 2 %}{%if is_odd == 0 %}|{%endif%}{% endfor %}</span>
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
    <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign is_odd = i | modulo: 2 %}{%if is_odd == 0 %}|{%endif%}{% endfor %}</span>
    <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign is_odd = i | modulo: 2 %}{%if is_odd == 0 %}|{%endif%}{% endfor %}</span>
    <br>
    <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign is_odd = i | modulo: 2 %}{%if is_odd == 0 %}|{%endif%}{% endfor %}</span>
    ;;
# {{promos}}
# {{detracts}}
# {{neuts}}
# -
# {{remaining_promos}}
# -
# {{remaining_detracts}}
# {% for i in (1..promos) %}
# 😀
# {% endfor %}
# <br>
# {% for i in (1..detracts) %}
# 😡
# {% endfor %}
# <br>
# {% for i in (1..neuts) %}
# 🤖
# {% endfor %}

# {{promos}}
# {{detracts}}
# {{neuts}}

  }

}
