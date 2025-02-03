create view analysis.batches_sold_valued_mgmt as
select
  abs.sales_order_id,
  abs.sales_order_line_id,
  abs.sales_order_external_reference,
  abs.sales_order_line_external_reference,
  abs.shipment_id,
  abs.shipment_line_id,
  abs.shipment_external_reference,
  abs.shipment_line_external_reference,
  abs.selling_entity,
  abs.customer_entity_id,
  abs.country,
  abs.order_month,
  abs.order_date,
  abs.quantity_ordered,
  abs.product,
  abs.sku,
  abs.sku_label,
  abs.unit_price_lc,
  abs.unit_price_eur,
  abs.discount_per_unit_lc,
  abs.discount_per_unit_eur,
  abs.line_amount_lc,
  abs.line_amount_eur,
  abs.currency,
  abs.exchange_rate_used,
  abs.batch_number,
  abs.reported_batch,
  abs.predicted_batch,
  abs.quantity_shipped,
  abs.shipped_line_value_lc,
  abs.shipped_line_value_eur,
  abs.shipped_units,
  'mgmt'::text as cogs_type,
  iob.management_cost_eur as cogs_per_quantity_shipped,
  abs.quantity_shipped * (iob.management_cost_eur * abs.exchange_rate_used) as shipped_line_cogs_lc,
  abs.quantity_shipped * iob.management_cost_eur as shipped_line_cogs_eur
from
  analysis.batches_sold_cached abs
  left join inventory.operations_batches iob on iob.batch_number = abs.batch_number
  and iob.sku_id::text = abs.sku
  and iob.management_cost_eur is not null;
