view: products {
  sql_table_name: `thelook.products` ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Google Search"
      url: "https://www.google.com/search?q={{ value }}"
      icon_url: "https://www.google.com/favicon.ico"
    }
    link: {
      label: "Facebook Search"
      url: "https://www.facebook.com/search/top/?q={{ value }}"
      icon_url: "https://facebook.com/favicon.ico"
    }
    link: {
      label: "View Brand Details"
      url: "https://looker.bytecode.io/dashboards/7D9btkie93hdvtwC6SdW6X?Brand={{ value | url_encode }}"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  link: {
    label: "Google Search"
    url: "https://www.google.com/search?q={{ value }}"
    icon_url: "https://www.google.com/favicon.ico"
  }
  link: {
    label: "Facebook Search"
    url: "https://www.facebook.com/search/top/?q={{ value }}"
    icon_url: "https://facebook.com/favicon.ico"
  }
    link: {
      label: "View Category Details"
      url: "https://looker.bytecode.io/dashboards/7D9btkie93hdvtwC6SdW6X?Category={{ value | url_encode }}"
    }
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  measure: average_cost {
    type: number
    sql: sum(${cost})/count(${id}) ;;
    value_format_name: usd_0
    drill_fields: [product_detail*, average_cost]
  }

  measure: average_gross_margin {
    type: number
    sql: (sum(${retail_price}) - sum(${cost})) / count(${id}) ;;
    value_format_name: usd_0
    drill_fields: [product_detail*, average_gross_margin]
  }

  measure: average_revenue {
    type: average
    sql: ${retail_price} ;;
    value_format_name: usd_0
    drill_fields: [product_detail*, average_revenue]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: gross_margin_percentage {
    type: number
    sql: 1.0 * ((sum(${retail_price}) - sum(${cost})) / nullif(sum(${retail_price}), 0)) ;;
    value_format_name: percent_2
    drill_fields: [product_detail*, gross_margin_percentage]
  }

  measure: percent_of_total_revenue {
    type: number
    sql: 1.0 * ${total_revenue} / sum(${total_revenue}) over () ;;
    value_format_name: percent_4
    drill_fields: [product_detail*, percent_of_total_revenue]
  }

  measure: total_cost {
    type: number
    sql: sum(${cost}) ;;
    value_format_name: usd_0
    drill_fields: [product_detail*, total_cost]
  }

  measure: total_gross_margin {
    type: number
    sql: sum(${retail_price}) - sum(${cost}) ;;
    value_format_name: usd_0
    drill_fields: [product_detail*, total_gross_margin]
  }

  measure: total_revenue {
    type: number
    sql: sum(${retail_price}) ;;
    value_format_name: usd_0
    drill_fields: [product_detail*, total_revenue]
  }

  set: detail {
    fields: [
      id,
      name,
      distribution_centers.name,
      distribution_centers.id,
      inventory_items.count,
      order_items.count
    ]
  }

  set: product_detail {
    fields: [
      products.id,
      products.sku,
      products.name,
      products.category,
      products.department,
      products.brand
    ]
  }
}



# view: products {
#   sql_table_name: `thelook.products` ;;
#   drill_fields: [id]

#   dimension: id {
#     primary_key: yes
#     type: number
#     sql: ${TABLE}.id ;;
#   }
#   dimension: brand {
#     type: string
#     sql: ${TABLE}.brand ;;
#     link:
#       {label: "Google Search"
#         url: "https://www.google.com/search?q={{ value }}"
#         icon_url: "https://www.google.com/favicon.ico"
#       }
#     link: {label: "Facebook Search"
#             url: "https://www.facebook.com/search/top/?q={{ value }}"
#             icon_url: "https://facebook.com/favicon.ico"}
#       }
#   dimension: category {
#     type: string
#     sql: ${TABLE}.category ;;
#   }
#   dimension: cost {
#     type: number
#     sql: ${TABLE}.cost ;;
#   }
#   dimension: department {
#     type: string
#     sql: ${TABLE}.department ;;
#   }
#   dimension: distribution_center_id {
#     type: number
#     # hidden: yes
#     sql: ${TABLE}.distribution_center_id ;;
#   }
#   dimension: name {
#     type: string
#     sql: ${TABLE}.name ;;
#   }
#   dimension: retail_price {
#     type: number
#     sql: ${TABLE}.retail_price ;;
#   }
#   dimension: sku {
#     type: string
#     sql: ${TABLE}.sku ;;
#   }
#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }
#   # measure: total_sale_price {
#   #   type: sum
#   #   sql: ${retail_price} ;;
#   #   value_format_name: usd
#   # }
#   measure: total_revenue {
#     type: number
#     sql: sum(${retail_price}) ;;
#     drill_fields: [product_detail*,total_revenue]
#     value_format_name: usd_0
#   }
#   measure: average_revenue {
#     type: average
#     sql: ${retail_price};;
#     drill_fields: [product_detail*,average_revenue]
#     value_format_name: usd_0
#   }
#   # measure: average_revenue {
#   #   type: number
#   #   sql: sum(${retail_price})/count(${id}) ;;
#   #   drill_fields: [products.category, products.name]
#   #   value_format_name: usd_0
#   # }

#   # measure: average_sale_price {
#   #   type: average
#   #   sql: ${retail_price} ;;
#   #   value_format_name: usd_0
#   # }
#   # measure: cumulative_total_sales {
#   #   type: number
#   #   sql: sum(${TABLE}.retail_price) over (order by ${order_items.created_raw} desc) ;;
#   #   value_format_name: usd_0
#   # }
#   # measure: total_cost {
#   #   type: sum
#   #   sql: ${cost} ;;
#   #   value_format_name: usd_0
#   # }
#   measure: total_cost {
#     type: number
#     sql: sum(${cost}) ;;
#     value_format_name: usd_0
#     drill_fields: [product_detail*,total_cost]
#   }
#   measure: average_cost {
#     type: number
#     sql: sum(${cost})/count(${id}) ;;
#     value_format_name: usd_0
#     drill_fields: [product_detail*,average_cost]
#   }
#   measure: total_gross_margin {
#     type: number
#     sql: sum(${retail_price})-sum(${cost}) ;;
#     drill_fields: [product_detail*,total_gross_margin]
#     value_format_name: usd_0
#   }
#   measure: average_gross_margin {
#     type: number
#     sql: (sum(${retail_price})-sum(${cost}))/count(${id})  ;;
#     drill_fields: [product_detail*,average_gross_margin]
#     value_format_name: usd_0
#   }
#   measure: gross_margin_percentage {
#     type: number
#     sql: 1.0*((sum(${retail_price})-sum(${cost}))/nullif(sum(${retail_price}),0)) ;;
#     drill_fields: [product_detail*,gross_margin_percentage]
#     value_format_name: percent_2
#   }
#   measure: percent_of_total_revenue {
#     type: number
#     sql: 1.0 * ${total_revenue} / sum(${total_revenue}) over () ;;
#     value_format_name: percent_4
#     drill_fields: [product_detail*,percent_of_total_revenue]
#   }


#   # ----- Sets of fields for drilling ------
#   set: detail {
#     fields: [
#   id,
#   name,
#   distribution_centers.name,
#   distribution_centers.id,
#   inventory_items.count,
#   order_items.count
#   ]
#   }

#   set: product_detail {
#     fields: [products.id,products.sku,products.name,products.category,products.department,products.brand]
#   }

# }
