view: revenue_aggregated {
 derived_table: {
  explore_source: products {
    column: user_id { field: order_items.user_id }
    column: total_revenue { field: products.total_revenue }
    # Assumes 'orders_per_customer' is a measure in 'order_items' view counting distinct orders per user
  }
}

dimension: user_id {
  type: string
  primary_key: yes
  # sql: ${TABLE}.user_id ;;
}

dimension: total_revenue {
  type: number
  # sql: ${TABLE}.total_revenue ;;
  value_format_name: usd_0
}

# Hidden sorting dimension

  dimension: customer_lifetime_revenue_sort_key {
    type: number
    hidden: yes
    sql: CASE
          WHEN ${total_revenue} BETWEEN 0.00 AND 4.99 THEN 1
          WHEN ${total_revenue} BETWEEN 5.00 AND 19.99 THEN 2
          WHEN ${total_revenue} BETWEEN 20.00 AND 49.99 THEN 3
          WHEN ${total_revenue} BETWEEN 50.00 AND 99.99 THEN 4
          WHEN ${total_revenue} BETWEEN 100.00 AND 499.99 THEN 5
          WHEN ${total_revenue} BETWEEN 500.00 AND 999.99 THEN 6
          WHEN ${total_revenue} >= 1000.00 THEN 7
          ELSE 8
        END ;;
  }

# Customer lifetime revenue dimension with readable labels
  dimension: customer_lifetime_revenue {
    type: string
    sql: CASE
          WHEN ${total_revenue} BETWEEN 0.00 AND 4.99 THEN '$0.00 - $4.99'
          WHEN ${total_revenue} BETWEEN 5.00 AND 19.99 THEN '$5.00 - $19.99'
          WHEN ${total_revenue} BETWEEN 20.00 AND 49.99 THEN '$20.00 - $49.99'
          WHEN ${total_revenue} BETWEEN 50.00 AND 99.99 THEN '$50.00 - $99.99'
          WHEN ${total_revenue} BETWEEN 100.00 AND 499.99 THEN '$100.00 - $499.99'
          WHEN ${total_revenue} BETWEEN 500.00 AND 999.99 THEN '$500.00 - $999.99'
          WHEN ${total_revenue} >= 1000.00 THEN '$1000.00+'
          ELSE 'Unknown'
        END ;;
    order_by_field: customer_lifetime_revenue_sort_key
  }


# dimension: customer_lifetime_revenue {
#   type: string
#   sql:  CASE
#     WHEN ${total_revenue} BETWEEN 0.00 AND 4.99 THEN '1: $0.00 - $4.99'
#     WHEN ${total_revenue} BETWEEN 5.00 AND 19.99 THEN '2: $5.00 - $19.99'
#     WHEN ${total_revenue} BETWEEN 20.00 AND 49.99 THEN '3: $20.00 - $49.99'
#     WHEN ${total_revenue} BETWEEN 50.00 AND 99.99 THEN '4: $50.00 - $99.99'
#     WHEN ${total_revenue} BETWEEN 100.00 AND 499.99 THEN '5: $100.00 - $499.99'
#     WHEN ${total_revenue} BETWEEN 500.00 AND 999.99 THEN '6: $500.00 - $999.99'
#     WHEN ${total_revenue} >= 1000.00 THEN '7: $1000.00+'
#     ELSE 'Unknown'
#     END ;;
# }

  # dimension: customer_lifetime_revenue {
  #   type: tier
  #   sql: ${total_revenue} ;;
  #   tiers: [0, 5, 20, 50, 100, 500, 1000]
  #   style: integer
  # }

  # dimension: customer_lifetime_revenue {
  #   type: string
  #   sql: CASE
  #         WHEN ${total_revenue} = 0 THEN '$0'
  #         WHEN ${total_revenue} = 5 THEN '$1 - $4.99'
  #         WHEN ${total_revenue} = 20 THEN '$5 - $19.99'
  #         WHEN ${total_revenue} = 50 THEN '$20 - $49.99'
  #         WHEN ${total_revenue} = 100 THEN '$50 - $99.99'
  #         WHEN ${total_revenue} = 500 THEN '$100 - $499.99'
  #         WHEN ${total_revenue} = 1000 THEN '$500 - $999.99'
  #         ELSE 'Over $1000'
  #       END ;;
  # }


}
