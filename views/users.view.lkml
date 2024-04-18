view: users {
  sql_table_name: `thelook.users` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql:  ${TABLE}.city ;;
  }

  dimension: city_location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }
  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }
  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }
  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }
  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }
  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }
  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }
  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }
  dimension: age_group {
    type: tier
    tiers: [15, 26, 36, 51, 66]
    style: integer
    sql: ${age} ;;
  }

  dimension: customer_length {
    type: string
    sql: CASE
          WHEN
            ${created_raw} >= TIMESTAMP(DATETIME_ADD(DATETIME(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY, 'America/Los_Angeles')), INTERVAL -89 DAY))
            AND ${created_raw} < TIMESTAMP(DATETIME_ADD(DATETIME(TIMESTAMP(DATETIME_ADD(DATETIME(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY, 'America/Los_Angeles')), INTERVAL -89 DAY), 'America/Los_Angeles')), INTERVAL 90 DAY))
          THEN "New Customer"
          ELSE "Long-Term Customer"
          END ;;
  }

  dimension: is_new_user {
    type: string
    sql: case when extract(month from ${created_date})=extract(month from current_date())
     then 'New User'
     else 'Returning User' end ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }

  measure: new_customers_count {
    type: count
    filters: [customer_length: "New Customer"]
    # drill_fields: [customer_length]
    drill_fields: [product_detail*,new_customers_count]
  }

  measure: long_term_customers_count {
    type: count
    filters: [customer_length: "Long-Term Customer"]
    drill_fields: [product_detail*,long_term_customers_count]
  }

  measure: new_user_count {
    type: count
    filters: [is_new_user: "New User"]
    label: "New Users Created this Month "
    drill_fields: [product_detail*,new_user_count]
  }

  measure: older_user_count {
    type: count
    filters: [is_new_user: "Users Created Prior to Current Month"]
    drill_fields: [product_detail*,older_user_count]
  }

  measure: user_count {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [product_detail*,user_count]
  }

  dimension: current_date {
    type: date
    datatype: date
    sql: current_date();;
  }

  dimension: last_month_vs_last_year {
    type: string
    sql: CASE
          WHEN EXTRACT(YEAR FROM ${created_date}) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
          AND EXTRACT(MONTH FROM ${created_date}) = EXTRACT(MONTH FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
              THEN 'Last Month'
          WHEN EXTRACT(YEAR FROM ${created_date}) = EXTRACT(YEAR FROM CURRENT_DATE()) - 1
              THEN 'Last Year'
          ELSE 'All Other Time Periods'
       END ;;
  }

  dimension: last_month{
    type: date
    datatype: date
    sql: EXTRACT(MONTH FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH));;
  }

  dimension: days_since_signup {
    type: number
    sql: date_diff(current_date(),date(${created_date}),day);;
    value_format_name: id
  }

  dimension: months_since_signup {
    type: number
    sql: DATE_DIFF(CURRENT_DATE(), ${created_date}, month);;
    value_format_name: id
  }

  measure: average_number_of_days_since_signup {
    type: average
    sql: ${days_since_signup} ;;
    value_format_name: id
    drill_fields: [product_detail*,user_count]
  }

  measure: average_number_of_months_since_signup {
    type: average
    sql: ${months_since_signup} ;;
    value_format_name: id
    drill_fields: [product_detail*,user_count]
  }

  dimension: days_signup_sort_key {
    type: number
    hidden: yes
    sql: CASE
        WHEN ${days_since_signup} >= 0 AND ${days_since_signup} < 10 THEN 1
        WHEN ${days_since_signup} >= 10 AND ${days_since_signup} < 20 THEN 2
        WHEN ${days_since_signup} >= 20 AND ${days_since_signup} < 30 THEN 3
        WHEN ${days_since_signup} >= 30 AND ${days_since_signup} < 40 THEN 4
        WHEN ${days_since_signup} >= 40 AND ${days_since_signup} < 50 THEN 5
        WHEN ${days_since_signup} >= 50 AND ${days_since_signup} < 60 THEN 6
        WHEN ${days_since_signup} >= 60 AND ${days_since_signup} < 70 THEN 7
        WHEN ${days_since_signup} >= 70 AND ${days_since_signup} < 80 THEN 8
        WHEN ${days_since_signup} >= 80 AND ${days_since_signup} < 90 THEN 9
        WHEN ${days_since_signup} >= 90 AND ${days_since_signup} < 100 THEN 10
        WHEN ${days_since_signup} >= 100 THEN 11
        ELSE 12  -- Optional, for handling unexpected or null cases
       END ;;
  }

  dimension: days_signup_tier {
    type: tier
    sql: ${days_since_signup} ;;
    tiers: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    style: integer
    order_by_field: days_signup_sort_key
  }

  dimension: months_signup_sort_key {
    type: number
    hidden: yes
    sql: CASE
        WHEN ${months_since_signup} >= 0 and ${months_since_signup} < 1 THEN 1
        WHEN ${months_since_signup} >= 1 and ${months_since_signup} < 2 THEN 2
        WHEN ${months_since_signup} >= 2 and ${months_since_signup} < 3 THEN 3
        WHEN ${months_since_signup} >= 3 and ${months_since_signup} < 4 THEN 4
        WHEN ${months_since_signup} >= 4 and ${months_since_signup} < 5 THEN 5
        WHEN ${months_since_signup} >= 5 and ${months_since_signup} < 6 THEN 6
        WHEN ${months_since_signup} >= 6 THEN 7
       END ;;
  }

  dimension: months_signup_tier {
    type: tier
    sql: ${months_since_signup} ;;
    tiers: [1, 2, 3, 4, 5, 6]
    style: integer
    order_by_field: months_signup_sort_key
  }

  measure: average_revenue_per_user {
    type: number
    sql: sum(${products.retail_price})/count(distinct ${id}) ;;
    value_format_name: usd_0
    drill_fields: [product_detail*,user_count]
  }

  set: product_detail {
    fields: [products.id,products.sku,products.name,products.category,products.department,products.brand]
  }
}
