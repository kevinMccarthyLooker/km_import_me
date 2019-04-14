- dashboard: dashboard_to_be_extended
  title: dashboard_to_be_extended
  layout: newspaper
  load_configuration: wait
  query_timezone: user_timezone
  elements:
  - name: Change from Prior Week
    title: Change from Prior Week
    model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo
    type: single_value
    fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.count_per_week,
      dashboard_select_fields.weeks_ago_special_for_pivot_label, dashboard_select_fields.weeks_ago]
    filters:
      dashboard_select_fields.weeks_ago: "(0, 3)"
    sorts: [dashboard_select_fields.weeks_ago_special_for_pivot_label]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: current_week, label: Current Week, expression: 'offset(${dashboard_select_fields.for_dashboard_count},364)',
        value_format: !!null '', value_format_name: !!null '', is_disabled: true,
        _kind_hint: measure, _type_hint: number}, {table_calculation: 53_week_avg,
        label: 53 Week Avg, expression: "if(row()=1,\n  sum(if(mod(row(),7)=0,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=2,\n  sum(if(mod(row(),7)=1,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=3,\n  sum(if(mod(row(),7)=2,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=4,\n  sum(if(mod(row(),7)=3,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=5,\n  sum(if(mod(row(),7)=4,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=6,\n  sum(if(mod(row(),7)=5,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=7,\n  sum(if(mod(row(),7)=6,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nnull\n)\n)\n)\n)\n)\n)\n)", value_format: !!null '', value_format_name: decimal_1,
        is_disabled: true, _kind_hint: measure, _type_hint: number}, {table_calculation: last_week,
        label: Last Week, expression: "${dashboard_select_fields.for_dashboard_count}",
        value_format: !!null '', value_format_name: !!null '', is_disabled: true,
        _kind_hint: measure, _type_hint: number}, {table_calculation: vs_same_week_year_prior,
        label: Vs Same Week Year Prior, expression: "(${dashboard_select_fields.for_dashboard_count}/offset(${dashboard_select_fields.for_dashboard_count},1))",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    color_application:
      collection_id: 0a5cba20-3b6e-4739-b9e3-ba1d442d992d
      palette_id: 47126dad-3a99-4cff-926a-a99f3b2eeccc
      options:
        steps: 5
    custom_color_enabled: true
    custom_color: ''
    show_single_value_title: false
    single_value_title: Of Prior Week
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: Same Week Yr Prior
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: dashboard_select_fields.count_per_week,
            id: 53 weeks prior - 53 - dashboard_select_fields.count_per_week, name: 53
              weeks prior}, {axisId: dashboard_select_fields.count_per_week, id: Avg
              of weeks between - 2 - dashboard_select_fields.count_per_week, name: Avg
              of weeks between}, {axisId: dashboard_select_fields.count_per_week,
            id: last week - 1 - dashboard_select_fields.count_per_week, name: last
              week}], showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    size_by_field: ''
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '7'
    hidden_series: []
    legend_position: center
    trellis_rows: 7
    series_types: {}
    point_style: circle
    series_colors:
      last week - 1 - dashboard_select_fields.count_per_week: "#000000"
    series_labels:
      Female - dashboard_select_fields.for_dashboard_count: Last Week
      Male - dashboard_select_fields.for_dashboard_count: Last Week
      Female - 53_weeks_prior: 53 Weeks Prior
      Female - average_across_53_weeks: 53 Week Avg
      Male - 53_weeks_prior: 53 Weeks Prior
      Male - average_across_53_weeks: 53 Week Avg
    series_point_styles:
      53 weeks prior - 53 - dashboard_select_fields.count_per_week: diamond
    show_value_labels: false
    label_density: 25
    x_axis_scale: ordinal
    y_axis_combined: true
    swap_axes: true
    show_null_points: true
    interpolation: step
    ordering: none
    show_null_labels: false
    show_dropoff: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.weeks_ago_special_for_pivot_label,
      dashboard_select_fields.count_per_week]
    note_state: expanded
    note_display: above
    note_text: Vs Prior Week
    listen: {}
    row: 4
    col: 4
    width: 2
    height: 2
  - name: Total Last Week vs Yr Prior
    title: Total Last Week vs Yr Prior
    model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo
    type: single_value
    fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.count_per_week,
      dashboard_select_fields.weeks_ago_special_for_pivot_label]
    filters:
      dashboard_select_fields.weeks_ago: "(0, 54)"
      dashboard_select_fields.weeks_ago_special_for_pivot_label: "-Avg of weeks between"
    sorts: [dashboard_select_fields.weeks_ago_special_for_pivot_label]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: current_week, label: Current Week, expression: 'offset(${dashboard_select_fields.for_dashboard_count},364)',
        value_format: !!null '', value_format_name: !!null '', is_disabled: true,
        _kind_hint: measure, _type_hint: number}, {table_calculation: 53_week_avg,
        label: 53 Week Avg, expression: "if(row()=1,\n  sum(if(mod(row(),7)=0,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=2,\n  sum(if(mod(row(),7)=1,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=3,\n  sum(if(mod(row(),7)=2,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=4,\n  sum(if(mod(row(),7)=3,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=5,\n  sum(if(mod(row(),7)=4,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=6,\n  sum(if(mod(row(),7)=5,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=7,\n  sum(if(mod(row(),7)=6,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nnull\n)\n)\n)\n)\n)\n)\n)", value_format: !!null '', value_format_name: decimal_1,
        is_disabled: true, _kind_hint: measure, _type_hint: number}, {table_calculation: last_week,
        label: Last Week, expression: "${dashboard_select_fields.for_dashboard_count}",
        value_format: !!null '', value_format_name: !!null '', is_disabled: true,
        _kind_hint: measure, _type_hint: number}, {table_calculation: vs_same_week_year_prior,
        label: Vs Same Week Year Prior, expression: "(${dashboard_select_fields.count_per_week}/offset(${dashboard_select_fields.count_per_week},1))",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    color_application:
      collection_id: 0a5cba20-3b6e-4739-b9e3-ba1d442d992d
      palette_id: 47126dad-3a99-4cff-926a-a99f3b2eeccc
      options:
        steps: 5
    custom_color_enabled: true
    custom_color: ''
    show_single_value_title: false
    single_value_title: Of Same Wk (Prior Yr)
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: Same Week Yr Prior
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: dashboard_select_fields.count_per_week,
            id: 53 weeks prior - 53 - dashboard_select_fields.count_per_week, name: 53
              weeks prior}, {axisId: dashboard_select_fields.count_per_week, id: Avg
              of weeks between - 2 - dashboard_select_fields.count_per_week, name: Avg
              of weeks between}, {axisId: dashboard_select_fields.count_per_week,
            id: last week - 1 - dashboard_select_fields.count_per_week, name: last
              week}], showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    size_by_field: ''
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '7'
    hidden_series: []
    legend_position: center
    trellis_rows: 7
    series_types: {}
    point_style: circle
    series_colors:
      last week - 1 - dashboard_select_fields.count_per_week: "#000000"
    series_labels:
      Female - dashboard_select_fields.for_dashboard_count: Last Week
      Male - dashboard_select_fields.for_dashboard_count: Last Week
      Female - 53_weeks_prior: 53 Weeks Prior
      Female - average_across_53_weeks: 53 Week Avg
      Male - 53_weeks_prior: 53 Weeks Prior
      Male - average_across_53_weeks: 53 Week Avg
    series_point_styles:
      53 weeks prior - 53 - dashboard_select_fields.count_per_week: diamond
    show_value_labels: false
    label_density: 25
    x_axis_scale: ordinal
    y_axis_combined: true
    swap_axes: true
    show_null_points: true
    interpolation: step
    ordering: none
    show_null_labels: false
    show_dropoff: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.weeks_ago_special_for_pivot_label,
      dashboard_select_fields.count_per_week]
    note_state: expanded
    note_display: above
    note_text: vs Same Wk Prior Year
    listen: {}
    row: 2
    col: 4
    width: 2
    height: 2
  - name: Date Explanation / Validation
    title: Date Explanation / Validation
    model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo
    type: table
    fields: [dashboard_select_fields.weeks_ago_special_for_pivot_label, dashboard_select_fields.min_date,
      dashboard_select_fields.max_date, dashboard_select_fields.for_dashboard_count]
    filters:
      dashboard_select_fields.weeks_ago: "(0, 54)"
    sorts: [dashboard_select_fields.weeks_ago_special_for_pivot_label]
    limit: 500
    query_timezone: America/New_York
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      dashboard_select_fields.weeks_ago_special_for_pivot_label: Period
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    hidden_series: []
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: true
    totals_color: "#808080"
    title_hidden: true
    listen: {}
    row: 0
    col: 14
    width: 10
    height: 2
  - name: Last Week
    title: Last Week
    model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo
    type: looker_column
    fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.for_dashboard_compare_dimension,
      dashboard_select_fields.row_placeholder]
    pivots: [dashboard_select_fields.for_dashboard_compare_dimension]
    filters:
      dashboard_select_fields.dashboard_weeks: 1 weeks ago for 1 weeks
    sorts: [dashboard_select_fields.for_dashboard_count desc 0, dashboard_select_fields.for_dashboard_compare_dimension]
    limit: 500
    query_timezone: America/New_York
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: 20 to 39 - dashboard_select_fields.for_dashboard_count,
            id: 20 to 39 - dashboard_select_fields.for_dashboard_count, name: 20 to
              39}, {axisId: 40 to 59 - dashboard_select_fields.for_dashboard_count,
            id: 40 to 59 - dashboard_select_fields.for_dashboard_count, name: 40 to
              59}, {axisId: 60 or Above - dashboard_select_fields.for_dashboard_count,
            id: 60 or Above - dashboard_select_fields.for_dashboard_count, name: 60
              or Above}, {axisId: Below 20 - dashboard_select_fields.for_dashboard_count,
            id: Below 20 - dashboard_select_fields.for_dashboard_count, name: Below
              20}], showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: percent
    limit_displayed_rows: false
    hidden_series: []
    legend_position: center
    font_size: ''
    series_types: {}
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: true
    totals_color: "#808080"
    show_null_points: true
    hidden_fields:
    note_state: expanded
    note_display: above
    note_text: Distribution
    listen: {}
    row: 2
    col: 12
    width: 2
    height: 11
  - name: Overview for Last Week
    type: text
    title_text: Overview for Last Week
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 0
    width: 7
    height: 2
  - name: Weekly Variance From Avg
    title: Weekly Variance From Avg
    model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo
    type: looker_scatter
    fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.for_dashboard_compare_dimension,
      dashboard_select_fields.dashboard_weeks]
    pivots: [dashboard_select_fields.for_dashboard_compare_dimension]
    fill_fields: [dashboard_select_fields.dashboard_weeks]
    filters:
      dashboard_select_fields.dashboard_weeks: 53 weeks ago for 53 weeks
    sorts: [dashboard_select_fields.for_dashboard_compare_dimension 0, dashboard_select_fields.dashboard_weeks
        desc]
    limit: 500
    total: true
    row_total: right
    dynamic_fields: [{table_calculation: calculation, label: "∆", expression: "((\n\
          \  ${dashboard_select_fields.for_dashboard_count}/${dashboard_select_fields.for_dashboard_count:row_total})\n\
          -\n(\n  ${dashboard_select_fields.for_dashboard_count:total}\n  /\n  (\n\
          \    sum(pivot_row(${dashboard_select_fields.for_dashboard_count:total}))\n\
          \  )\n)\n)\n/\n(\n  ${dashboard_select_fields.for_dashboard_count:total}\n\
          \  /\n  (\n    sum(pivot_row(${dashboard_select_fields.for_dashboard_count:total}))\n\
          \  )\n)", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/New_York
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: calculation, id: 20
              to 39 - calculation, name: 20 to 39}, {axisId: calculation, id: 40 to
              59 - calculation, name: 40 to 59}, {axisId: calculation, id: 60 or Above
              - calculation, name: 60 or Above}, {axisId: calculation, id: Below 20
              - calculation, name: Below 20}], showLabels: false, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    size_by_field: ''
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: right
    series_types:
      avg_week: line
    point_style: circle
    series_colors:
      Female - last_week_highlight: "#9fdee0"
      Male - last_week_highlight: "#cfcfcf"
    series_point_styles:
      Female - last_week_highlight: diamond
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    reference_lines: [{reference_type: line, range_start: max, range_end: min, margin_top: deviation,
        margin_value: mean, margin_bottom: deviation, label_position: center, color: "#000000",
        line_value: '0', label: Avg}]
    show_null_points: false
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [dashboard_select_fields.for_dashboard_count, avg_distribution_for_all_weeks,
      of_week]
    row: 8
    col: 14
    width: 10
    height: 5
  - name: 53 Week Trend
    title: 53 Week Trend
    model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo
    type: looker_area
    fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.for_dashboard_compare_dimension,
      dashboard_select_fields.dashboard_weeks]
    pivots: [dashboard_select_fields.for_dashboard_compare_dimension]
    fill_fields: [dashboard_select_fields.dashboard_weeks]
    filters:
      dashboard_select_fields.dashboard_weeks: 53 weeks ago for 53 weeks
    sorts: [dashboard_select_fields.for_dashboard_compare_dimension 0, dashboard_select_fields.dashboard_weeks]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: dashboard_select_fields.for_dashboard_count,
            id: 20 to 39 - dashboard_select_fields.for_dashboard_count, name: 20 to
              39}, {axisId: dashboard_select_fields.for_dashboard_count, id: 40 to
              59 - dashboard_select_fields.for_dashboard_count, name: 40 to 59}, {
            axisId: dashboard_select_fields.for_dashboard_count, id: 60 or Above -
              dashboard_select_fields.for_dashboard_count, name: 60 or Above}, {axisId: dashboard_select_fields.for_dashboard_count,
            id: Below 20 - dashboard_select_fields.for_dashboard_count, name: Below
              20}], showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: right
    series_types: {}
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    row: 2
    col: 14
    width: 10
    height: 6
  - name: By Day of Week
    title: By Day of Week
    model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo
    type: looker_line
    fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.day_of_week,
      dashboard_select_fields.count_per_week, dashboard_select_fields.weeks_ago_special_for_pivot_label]
    pivots: [dashboard_select_fields.weeks_ago_special_for_pivot_label]
    fill_fields: [dashboard_select_fields.day_of_week]
    filters:
      dashboard_select_fields.weeks_ago: "(0, 54)"
    sorts: [dashboard_select_fields.weeks_ago_special_for_pivot_label desc, dashboard_select_fields.day_of_week]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: current_week, label: Current Week, expression: 'offset(${dashboard_select_fields.for_dashboard_count},364)',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {table_calculation: 53_week_avg, label: 53
          Week Avg, expression: "if(row()=1,\n  sum(if(mod(row(),7)=0,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=2,\n  sum(if(mod(row(),7)=1,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=3,\n  sum(if(mod(row(),7)=2,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=4,\n  sum(if(mod(row(),7)=3,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=5,\n  sum(if(mod(row(),7)=4,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=6,\n  sum(if(mod(row(),7)=5,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=7,\n  sum(if(mod(row(),7)=6,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nnull\n)\n)\n)\n)\n)\n)\n)", value_format: !!null '', value_format_name: decimal_1,
        _kind_hint: measure, _type_hint: number, is_disabled: true}, {table_calculation: last_week,
        label: Last Week, expression: "${dashboard_select_fields.for_dashboard_count}",
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number, is_disabled: true}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: dashboard_select_fields.count_per_week,
            id: 53 weeks prior - 53 - dashboard_select_fields.count_per_week, name: 53
              weeks prior}, {axisId: dashboard_select_fields.count_per_week, id: Avg
              of weeks between - 2 - dashboard_select_fields.count_per_week, name: Avg
              of weeks between}, {axisId: dashboard_select_fields.count_per_week,
            id: last week - 1 - dashboard_select_fields.count_per_week, name: last
              week}], showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '7'
    legend_position: center
    trellis_rows: 1
    series_types:
      last week - 1 - dashboard_select_fields.count_per_week: area
    point_style: circle
    series_colors:
      last week - 1 - dashboard_select_fields.count_per_week: rgb(200,0,150)
    series_labels:
      Female - dashboard_select_fields.for_dashboard_count: Last Week
      Male - dashboard_select_fields.for_dashboard_count: Last Week
      Female - 53_weeks_prior: 53 Weeks Prior
      Female - average_across_53_weeks: 53 Week Avg
      Male - 53_weeks_prior: 53 Weeks Prior
      Male - average_across_53_weeks: 53 Week Avg
    series_point_styles:
      53 weeks prior - 53 - dashboard_select_fields.count_per_week: diamond
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [dashboard_select_fields.for_dashboard_count]
    row: 6
    col: 0
    width: 6
    height: 7
  - name: Last Week Performance
    title: Last Week Performance
    model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo
    type: looker_line
    fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.count_per_week,
      dashboard_select_fields.weeks_ago_special_for_pivot_label, dashboard_select_fields.for_dashboard_compare_dimension]
    pivots: [dashboard_select_fields.weeks_ago_special_for_pivot_label]
    filters:
      dashboard_select_fields.weeks_ago: "(0, 54)"
    sorts: [dashboard_select_fields.weeks_ago_special_for_pivot_label desc, dashboard_select_fields.for_dashboard_compare_dimension]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: current_week, label: Current Week, expression: 'offset(${dashboard_select_fields.for_dashboard_count},364)',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {table_calculation: 53_week_avg, label: 53
          Week Avg, expression: "if(row()=1,\n  sum(if(mod(row(),7)=0,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=2,\n  sum(if(mod(row(),7)=1,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=3,\n  sum(if(mod(row(),7)=2,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=4,\n  sum(if(mod(row(),7)=3,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=5,\n  sum(if(mod(row(),7)=4,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=6,\n  sum(if(mod(row(),7)=5,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=7,\n  sum(if(mod(row(),7)=6,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nnull\n)\n)\n)\n)\n)\n)\n)", value_format: !!null '', value_format_name: decimal_1,
        _kind_hint: measure, _type_hint: number, is_disabled: true}, {table_calculation: last_week,
        label: Last Week, expression: "${dashboard_select_fields.for_dashboard_count}",
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number, is_disabled: true}]
    color_application:
      collection_id: 0a5cba20-3b6e-4739-b9e3-ba1d442d992d
      palette_id: 47126dad-3a99-4cff-926a-a99f3b2eeccc
      options:
        steps: 5
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: dashboard_select_fields.count_per_week,
            id: 53 weeks prior - 53 - dashboard_select_fields.count_per_week, name: 53
              weeks prior}, {axisId: dashboard_select_fields.count_per_week, id: Avg
              of weeks between - 2 - dashboard_select_fields.count_per_week, name: Avg
              of weeks between}, {axisId: dashboard_select_fields.count_per_week,
            id: last week - 1 - dashboard_select_fields.count_per_week, name: last
              week}], showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    size_by_field: ''
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '7'
    hidden_series: []
    legend_position: center
    trellis_rows: 7
    series_types:
      53 weeks prior - 53 - dashboard_select_fields.count_per_week: scatter
      Avg of weeks between - 2 - dashboard_select_fields.count_per_week: scatter
      last week - 1 - dashboard_select_fields.count_per_week: column
    point_style: circle
    series_colors:
      last week - 1 - dashboard_select_fields.count_per_week: rgba(200,0,150,0.5)
    series_labels:
      Female - dashboard_select_fields.for_dashboard_count: Last Week
      Male - dashboard_select_fields.for_dashboard_count: Last Week
      Female - 53_weeks_prior: 53 Weeks Prior
      Female - average_across_53_weeks: 53 Week Avg
      Male - 53_weeks_prior: 53 Weeks Prior
      Male - average_across_53_weeks: 53 Week Avg
    series_point_styles:
      53 weeks prior - 53 - dashboard_select_fields.count_per_week: diamond
    show_value_labels: false
    label_density: 25
    x_axis_scale: ordinal
    y_axis_combined: true
    swap_axes: true
    show_null_points: true
    interpolation: step
    ordering: none
    show_null_labels: false
    show_dropoff: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [dashboard_select_fields.for_dashboard_count]
    row: 2
    col: 6
    width: 6
    height: 11
  - name: Last Week Count (vs Last Yr's Avg Wk)
    title: Last Week Count (vs Last Yr's Avg Wk)
    model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo
    type: single_value
    fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.count_per_week,
      dashboard_select_fields.weeks_ago_special_for_pivot_label]
    filters:
      dashboard_select_fields.weeks_ago: "(0, 54)"
    sorts: [dashboard_select_fields.weeks_ago_special_for_pivot_label]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: current_week, label: Current Week, expression: 'offset(${dashboard_select_fields.for_dashboard_count},364)',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {table_calculation: 53_week_avg, label: 53
          Week Avg, expression: "if(row()=1,\n  sum(if(mod(row(),7)=0,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=2,\n  sum(if(mod(row(),7)=1,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=3,\n  sum(if(mod(row(),7)=2,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=4,\n  sum(if(mod(row(),7)=3,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=5,\n  sum(if(mod(row(),7)=4,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=6,\n  sum(if(mod(row(),7)=5,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nif(row()=7,\n  sum(if(mod(row(),7)=6,${dashboard_select_fields.for_dashboard_count},null)/53)\n\
          ,\nnull\n)\n)\n)\n)\n)\n)\n)", value_format: !!null '', value_format_name: decimal_1,
        _kind_hint: measure, _type_hint: number, is_disabled: true}, {table_calculation: last_week,
        label: Last Week, expression: "${dashboard_select_fields.for_dashboard_count}",
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number, is_disabled: true}]
    color_application:
      collection_id: 0a5cba20-3b6e-4739-b9e3-ba1d442d992d
      palette_id: 47126dad-3a99-4cff-926a-a99f3b2eeccc
      options:
        steps: 5
    custom_color_enabled: true
    custom_color: rgba(200,0,150,0.5)
    show_single_value_title: false
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: Weekly Avg
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: dashboard_select_fields.count_per_week,
            id: 53 weeks prior - 53 - dashboard_select_fields.count_per_week, name: 53
              weeks prior}, {axisId: dashboard_select_fields.count_per_week, id: Avg
              of weeks between - 2 - dashboard_select_fields.count_per_week, name: Avg
              of weeks between}, {axisId: dashboard_select_fields.count_per_week,
            id: last week - 1 - dashboard_select_fields.count_per_week, name: last
              week}], showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    size_by_field: ''
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '7'
    hidden_series: []
    legend_position: center
    trellis_rows: 7
    series_types: {}
    point_style: circle
    series_colors:
      last week - 1 - dashboard_select_fields.count_per_week: "#000000"
    series_labels:
      Female - dashboard_select_fields.for_dashboard_count: Last Week
      Male - dashboard_select_fields.for_dashboard_count: Last Week
      Female - 53_weeks_prior: 53 Weeks Prior
      Female - average_across_53_weeks: 53 Week Avg
      Male - 53_weeks_prior: 53 Weeks Prior
      Male - average_across_53_weeks: 53 Week Avg
    series_point_styles:
      53 weeks prior - 53 - dashboard_select_fields.count_per_week: diamond
    show_value_labels: false
    label_density: 25
    x_axis_scale: ordinal
    y_axis_combined: true
    swap_axes: true
    show_null_points: true
    interpolation: step
    ordering: none
    show_null_labels: false
    show_dropoff: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [dashboard_select_fields.for_dashboard_count, dashboard_select_fields.weeks_ago_special_for_pivot_label]
    note_state: collapsed
    note_display: above
    note_text: ''
    listen: {}
    row: 2
    col: 0
    width: 4
    height: 4
  - name: 'NOTE: WIP - See comments below'
    type: text
    title_text: 'NOTE: WIP - See comments below'
    subtitle_text: ''
    body_text: "- Some issue with week bucketing and timezones - 'last week' doesn't\
      \ sync well with the calendar week field."
    row: 0
    col: 7
    width: 7
    height: 2
