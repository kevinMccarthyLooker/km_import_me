#### For standard views
view: primary_key_and_counts {
  extends: [date_helpers]
  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: null ;; #extending view must override sql parameter to be the primary_key for that view. (e.g. extending view has dimension: primary_key {sql: ${id};;}}
  }
  measure: count {
    type: count
    # sql: case when ${primary_key} is not null then 1 else null end ;;
    filters: {
      field: primary_key
      value: "-NULL"
    }
  }
  measure: count_distinct {
    type: count_distinct
    sql: ${primary_key};;
  }
  measure: primary_key_range {
    type: string
    sql: min(${primary_key})||' to '||max(${primary_key});;
  }
}

view: date_helpers{
  dimension: current_year                     {hidden:yes sql:{{'now' | date: '%Y'}};;}
  dimension: current_year_two_digits          {hidden:yes sql:{{'now' | date: '%y'}};;}
  dimension: current_monthnumber              {hidden:yes sql:{{'now' | date: '%m'}};;}
  dimension: current_day_of_month             {hidden:yes sql:{{'now' | date: '%d'}};;}
  dimension: current_daynumber_of_year        {hidden:yes sql:{{'now' | date: '%j'}};;}
  dimension: current_milliseconds_since_1970  {hidden:yes sql:{{'now' | date: '%Q'}};;}
  dimension: current_day_of_week_monday_is_1  {hidden:yes sql:{{'now' | date: '%u'}};;}
  dimension: seconds_in_a_minute              {hidden:yes sql:60;;}
  dimension: seconds_in_an_hour               {hidden:yes sql:3600;;}
  dimension: seconds_in_a_day                 {hidden:yes sql:86400;;}
  dimension: seconds_in_a_week                {hidden:yes sql:604800;;}#things that might need to be quoted...
  dimension: current_month_name_unquoted      {hidden:yes sql:{{'now' | date: '%b'}};;}
  dimension: current_month_name_quoted        {hidden:yes sql:'{{'now' | date: '%b'}}';;}
  dimension: current_date_unquoted            {hidden:yes sql:{{'now' | date: '%Y-%m-%d'}};;}
  dimension: current_datetime_unquoted            {hidden:yes sql:{{'now' | date: '%Y-%m-%d %H:%M:%S'}};;}
  dimension: now_for_conversion {
    hidden: yes
    datatype: datetime
    type: date_time
    sql:'{{'now' | date: '%Y-%m-%d %H:%M:%S'}}';;
  }
  dimension: now_converted_as_date_field {
    hidden: yes
    type: string
    sql: cast(${now_for_conversion} as datetime) ;;
  }
  dimension: my_timezone_offset_seconds {
    hidden: yes
    type:number
    sql: datediff(s,'{{'now' | date: '%Y-%m-%d %H:%M:%S'}}',${now_converted_as_date_field}) ;;
  }
}


#not fully fleshed out, but we can make user attributes more accessible in the IDE

view: user_attribute_helpers {
  sql_table_name: public.users ;;
  dimension: user_email {
    # hidden: yes
    sql: {{_user_attributes['email']}} ;;
  }
  dimension: user_email_domain {
    # hidden: yes
    sql: {% assign at_pos = _user_attributes['email'] | split: '@' %}{{at_pos[1]}};;
  }
  dimension: is_looker {
    sql: {% if user_email_domain._sql == 'looker.com' %}Yes{%else%}No{%endif%} ;;
  }
}


view: standards {
  extends: [primary_key_and_counts,date_helpers,user_attribute_helpers]
}
