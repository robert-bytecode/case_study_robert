view: cv_category_averages {

  dimension: pk {
    type: string
    sql: GENERATE_UUID() ;;
    primary_key: yes
    hidden: yes

  }

  measure: selected_brand_vs_category_difference_revenue {
    type: number
    sql: ${products.selected_brand_revenue} - ${category_averages.average_category_revenue} ;;
    label: "Revenue Difference: Selected Brand vs. Category"
    value_format_name: usd_0
  }

  # measure: selected_brand_units {
  #   type: count
  #   sql:
  #   {% if products.brand._is_filtered %}
  #     CASE WHEN {% condition products.brand %} ${products.brand} {% endcondition %} THEN ${order_items.id} END
  #   {% else %}
  #     ${order_items.id}
  #   {% endif %}
  # ;;
  #   label: "Selected Brand Units Sold"
  #   value_format_name: id

  # }

  measure: selected_brand_units {
    type: count_distinct
    sql: CASE WHEN {% condition products.brand %} ${products.brand} {% endcondition %} THEN ${order_items.id} END ;;
    label: "Selected Brand Units Sold"
  }

  # measure: selected_brand_customers{
  #   type: count_distinct
  #   sql:
  #   {% if products.brand._is_filtered %}
  #     CASE WHEN {% condition products.brand %} ${products.brand} {% endcondition %} THEN ${order_items.user_id} END
  #   {% else %}
  #     ${order_items.user_id}
  #   {% endif %}
  # ;;
  #   label: "Selected Brand Customers Sold"
  #   value_format_name: id

  # }

  measure: selected_brand_customers {
    type: count_distinct
    sql: CASE WHEN {% condition products.brand %} ${products.brand} {% endcondition %} THEN ${order_items.user_id} END ;;
    label: "Selected Brand Customers Sold"
  }

  measure: selected_brand_average_units_per_customer {
    type: number
    sql: ${selected_brand_units}/${selected_brand_customers} ;;
    value_format_name: percent_1
    label: "Selected Brand Average Units per Customer"
  }

  measure: selected_brand_vs_category_difference_avg_units{
    type: number
    sql: ${selected_brand_average_units_per_customer} -  ${category_averages.category_average_units_sold_per_customer} ;;
    label: "Average Units per Customer: Selected Brand vs. Category"
    value_format_name: percent_1
  }

  measure: selected_brand_vs_category_units_percent_of_total{
    type: number
    sql: (${selected_brand_units} /  ${category_averages.total_category_units_sold}) ;;
    label: "Selected Brand Units Sold: % of Category Total"
    value_format_name: percent_1
  }

}
