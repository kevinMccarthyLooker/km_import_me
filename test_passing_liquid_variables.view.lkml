#couldn't get any values to pass
# view: test_passing_liquid_variables {
#   dimension: a {
#     type: string
#     sql:
#     {% assign liquid_on_a = 'liquid_a' %}
#     1
#   ${b}
#
#     ;;}
# # {{liquid_on_a}}
#   dimension: b {
#   type: string
#
#     sql:
#         {% assign liquid_b = b._liquid_on_ac %}
# {{liquid_on_a}}
#     --2
#     ;;
#
#     }
#     # {{b._liquid_on_a._value}}
#         # --${a}--didn't get variable from a
# # ${a}
#
# }
