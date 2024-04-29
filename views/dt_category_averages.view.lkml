view: category_averages {
  derived_table: {
    sql:
      SELECT
                category,
                SUM(retail_price) AS total_revenue,
                AVG(retail_price) AS average_revenue,
                count(distinct order_items.id) as total_units_sold,
                count(distinct order_items.id)/count(distinct order_items.user_id) as average_units_per_customer
              FROM products left join order_items on
                order_items.product_id = products.id
              WHERE order_items.created_at >= '2024-01-01 00:00:00'
              GROUP BY category
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  # dimension_group: created {
  #   type: time
  #   timeframes: [raw, time, date, week, month, quarter, year]
  #   sql: ${TABLE}.created_at ;;
  # }

  dimension: total_category_revenue {
    type: number
    sql: ${TABLE}.total_revenue ;;
    value_format_name: usd_0
    label: "Total Category Revenue YTD"
  }

  dimension: average_category_revenue {
    type: number
    sql: ${TABLE}.average_revenue ;;
    value_format_name: usd_0
    label: "Average Category Revenue YTD"
  }

  dimension: total_category_units_sold {
    type: number
    sql: ${TABLE}.total_units_sold ;;
    value_format_name: decimal_0
    label: "Total Category Units Sold YTD"
  }

  dimension: category_average_units_sold_per_customer {
    type: number
    sql: ${TABLE}.average_units_per_customer ;;
    value_format_name: decimal_2
    label: "Category AVerage Units Sold per Customer YTD"
  }

  set: detail {
    fields: [
      category,
      total_category_revenue,
      average_category_revenue
    ]
  }
}
