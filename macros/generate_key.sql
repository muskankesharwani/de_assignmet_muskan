{% macro format_full_name(first_col, last_col) %}
    {{ first_col }} || ' ' || {{ last_col }}
{% endmacro %}
