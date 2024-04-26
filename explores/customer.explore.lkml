include: "/views/**/*.view.lkml"
# include: "/views/products.view.lkml"

explore: users {
  label: "Customers"
  join: events {
    type: left_outer
    sql_on: ${events.user_id}=${users.id} ;;
    relationship: one_to_many
  }
  join: users_with_returns {
    type: left_outer
    sql_on: ${users.id}=${users_with_returns.user_id_return} ;;
    relationship: many_to_one
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id}=${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: products {
    type: left_outer
    sql_on: ${order_items.product_id}=${products.id} ;;
    relationship: many_to_one
  }
  join: sale_price_by_user {
    type: left_outer
    sql_on: ${users.id}=${sale_price_by_user.user_id} ;;
    relationship: one_to_many
  }
  join: first_purchased {
    type: left_outer
    sql_on: ${events.user_id}=${first_purchased.user_id} ;;
    relationship: many_to_one
  }
  join: orders_aggregated {
    type: left_outer
    sql_on: ${order_items.user_id}=${orders_aggregated.user_id} ;;
    relationship: many_to_one
  }
  join: revenue_aggregated {
    type: left_outer
    sql_on: ${order_items.user_id}=${revenue_aggregated.user_id} ;;
    relationship: many_to_one
  }
  join: orders_created {
    type: left_outer
    sql_on: ${order_items.user_id}=${orders_created.user_id} ;;
    relationship: many_to_one
  }
  join: repeat_customers {
    type: left_outer
    sql_on: ${order_items.user_id}=${repeat_customers.user_id} ;;
    relationship: many_to_one
  }
  join: last_order {
    type: left_outer
    sql_on: ${order_items.user_id}=${last_order.id} ;;
    relationship: many_to_one
  }
  join: order_sequence {
    type: left_outer
    sql_on: ${events.id}= ${order_sequence.id} ;;
    relationship: one_to_one
  }
  join: category_averages {
    type: left_outer
    sql_on: ${products.category}=${category_averages.category} ;;
    relationship: many_to_one
  }
  join: cv_category_averages {
    type: left_outer
    sql:;;
    relationship: one_to_one
  }
}
