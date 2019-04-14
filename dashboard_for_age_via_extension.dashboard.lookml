# - dashboard: dashboard_for_age_via_extension
#   title: dashboard_for_age_via_extension
#   extends: new_dashboard
#   layout: newspaper
#   elements:
#   - name: Change from Prior Week
#     title: Change from Prior Week
#     model: import_test_model
#     explore: users_for_dynamic_lookml_dashboard_block_demo
#     type: single_value
#     fields: [dashboard_select_fields_age.for_dashboard_count, dashboard_select_fields_age.count_per_week,
#       dashboard_select_fields_age.weeks_ago_special_for_pivot_label, dashboard_select_fields_age.weeks_ago]
#     sorts: [dashboard_select_fields_age.weeks_ago_special_for_pivot_label]
