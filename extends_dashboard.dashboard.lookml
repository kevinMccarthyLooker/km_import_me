
# - dashboard: extends_dashboard
#   title: FAA Additional
#   extends: new_dashboard
#   elements:
#   - name: Change from Prior Week
#     title: Change from Prior Week
#     model: import_test_model
#     explore: users_for_dynamic_lookml_dashboard_block_demo
#     type: single_value
#     fields: [dashboard_select_fields_age.for_dashboard_count, dashboard_select_fields_age.count_per_week,
#       dashboard_select_fields_age.weeks_ago_special_for_pivot_label, dashboard_select_fields_age.weeks_ago]
#     sorts: [dashboard_select_fields_age.weeks_ago_special_for_pivot_label]
#   - name: Last Week
#     title: 2Last Week
#     fields: [dashboard_select_fields_age.for_dashboard_count, dashboard_select_fields.for_dashboard_compare_dimension,
#       dashboard_select_fields.row_placeholder]
#     pivots: [dashboard_select_fields_age.for_dashboard_compare_dimension]
#     sorts: [dashboard_select_fields_age.for_dashboard_count desc 0, dashboard_select_fields.for_dashboard_compare_dimension]
