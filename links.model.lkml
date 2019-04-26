connection: "thelook_events_redshift"

explore: my_links {
  from: links2
  view_name: links
}

view: links {
  derived_table: {sql: select 1 as id ;;}

  measure: measure_input_dashboard_id {
    sql:  /dashboards/Pur2Qlf9hlFwnH6Es9F4pu  ;;
  }
  measure: measure_input_dashboard_link_label {
    sql:  Custom Direct Link  ;;
  }


  #use as a tiny tile, to provide a link on a dashboard.
  dimension: dimension_output{
    label: "Hover for More Info.  Click for Links"
    can_filter: no # disable and hide the default 'filter on this dimension value' explore filter
    # drill_fields: [dimension_output]

    type: string
    sql: 'placeholder value. Field intended for providing in browser rendered HTML' ;;

    #span title makes a grey hover window.  Can't seem to control font or exact spacing, but still, a space conscious way to provide notes
    html:
<span title=
"Dashboard X
----------------------------------
Data Owner: Kevin McCarthy

Business Owner: Doc McStuffins

Intended Users: Customer Support Team

Purpose: Highlight next steps and facilitate necessary interventions.  Provide actionable insights.

Other Notes:
4/19 Created
4/20 Updated with new at risk tile
4/21 Questions about change $ shown on tile X
"
</span>
<a href="#drillmenu">
      <img src="https://logo-core.clearbit.com/looker.com"/>
</a>
;;
    link: {
      url: "/browse"
      label: "Home"
    }
    link: {
      url: "/spaces/home"
      label: "Shared"
    }
    link: {
      url: "/dashboards/PINUBO155UTnyX6WiWjqYq"
      label: "Company Overview"
    }
    link: {
      url: "{{measure_input_dashboard_id._sql}}"
      label: "{{measure_input_dashboard_link_label._sql}}"
    }
    link: {
      url: "kevin.mccarthyy@looker.com?Subject=Regarding {{measure_input_dashboard_id._sql | replace:'s/',' '}}"
      label: "More Questions?"
    }

  }

dimension: team_home_space_url {
  sql:
  {% if _user_attributes['name'] == 'Kevin McCarthy' %}/spaces/244
  {% else %}
  {% endif %}
  ;;
}

dimension: basic_links_YesNo {
  sql:'Yes';;
}

dimension: dashboard_note_text_value {
  sql: 'placeholder' ;;
}

measure: measure_output {
  label: "Hover for More Info.  Click for Links"
  can_filter: no # disable and hide the default 'filter on this dimension value' explore filter
  # drill_fields: [dimension_output]

  type: string
  sql: max('placeholder value. Field intended for providing in browser rendered HTML') ;;

  #span title makes a grey hover window.  Can't seem to control font or exact spacing, but still, a space conscious way to provide notes
  html:
  <span title=
  "Dashboard X2
  {{dashboard_note_text_value._sql}}
  "
  </span>
  <a href="#drillmenu">
  <img src="https://logo-core.clearbit.com/looker.com"/>
  </a>
  ;;
  link: {label: "My Favorite Dashboard ID"
    url: "/dashboards/{{ _user_attributes['my_favorite_dashboard_id'] }}"
  }
  link: { label: "Home"
url: "
{% if basic_links_YesNo._sql == \"'Yes'\" %}
  /browse
{%endif%}"
  }#
  link: {label: "Shared"
url: "
{% if basic_links_YesNo._sql == \"'Yes'\" %}
  /spaces/home
{%endif%}"
  }
  link: {label: "Company Overview"
    url: "/dashboards/PINUBO155UTnyX6WiWjqYq"
  }
  link: {label: "{{measure_input_dashboard_link_label._sql}}"
    url: "{{measure_input_dashboard_id._sql}}"
  }
  link: {label: "More Questions?"
    url: "kevin.mccarthyy@looker.com?Subject=Regarding {{measure_input_dashboard_id._sql | replace:'s/',' '}}"
  }
  link: {label: "Custom Home Space"
    url: "{{team_home_space_url._sql}}"
  }
  link: {label: "Finance Department Space"
    url: "{% if _user_attributes['in_finance_group'] == 'Yes' %}/spaces/316{% endif %}"
  }

}
}
view: links2 {
  extends: [links]
  dimension: basic_links_YesNo {
    sql:'No';;
  }
}
