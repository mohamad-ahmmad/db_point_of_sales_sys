--indexes: -------------------------------
create index item_index on item (
    supplier_id asc,
    category asc
);

analyze table item compute statistics;

------------

create index item_pricelist_index on pricelist_item (
    item_id asc,
    pl_id asc
);

analyze table pricelist_item compute statistics;

------------

create index inventory_index on inventory (
    expiry_date asc
);

analyze table inventory compute statistics;

-----------

create index sales_order_index on sales_order (
    so_date asc,
    net_amount asc
);

analyze table sales_order compute statistics;

-----------

create index sales_order_details_index on sales_order_details (
    so_id asc,
    item_id asc,
    pl_id
);

analyze table sales_order_details compute statistics;