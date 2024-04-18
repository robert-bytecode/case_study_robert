
view: sale_price_by_user {
  derived_table: {
    sql: select row_number() over (order by u.id, p.id, p.retail_price) as artificial_pk,
          u.id as user_id, p.id as product_id, p.retail_price
      from order_items o left join users u on
        o.user_id=u.id
          left join events e on
            u.id=e.user_id
          left join products p on
            o.product_id=p.id
      where e.event_type='purchase' ;;
  }

  # measure: count {
  #   type: count
  #   drill_fields: [detail*]
  # }

  dimension: key {
    primary_key: yes
    type: number
    sql: ${TABLE}.artificial_pk;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  measure: total_sales {
    type: sum
    sql: ${retail_price} ;;
    value_format_name: usd_0
    drill_fields: [product_detail*,total_sales]
  }

  measure: total_customers {
    type: count_distinct
    sql: ${user_id} ;;
    value_format_name: decimal_0
    drill_fields: [product_detail*,total_customers]
  }

  measure: average_spend_by_customer {
    type: number
    sql: 1.0 * (SUM(${retail_price}) / NULLIF(COUNT(DISTINCT ${user_id}), 0)) ;;
    drill_fields: [product_detail*,average_spend_by_customer]
    value_format_name: usd_0
  }

  # measure: average_sales {
  #   type: average
  #   sql: ${retail_price} ;;
  #   value_format_name: usd_0
  # }

  set: detail {
    fields: [
        user_id,
  product_id,
  retail_price
    ]
  }

  set: product_detail {
    fields: [products.id,products.sku,products.name,products.category,products.department,products.brand]
  }
}