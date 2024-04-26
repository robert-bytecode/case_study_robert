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
              GROUP BY category ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: total_category_revenue {
    type: number
    sql: ${TABLE}.total_revenue ;;
    value_format_name: usd_0
  }

  dimension: average_category_revenue {
    type: number
    sql: ${TABLE}.average_revenue ;;
    value_format_name: usd_0
  }

  dimension: total_category_units_sold {
    type: number
    sql: ${TABLE}.total_units_sold ;;
    value_format_name: decimal_0
  }

  dimension: category_average_units_sold_per_customer {
    type: number
    sql: ${TABLE}.average_units_per_customer ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [
      category,
      total_category_revenue,
      average_category_revenue
    ]
  }
}
