export class Product {
  constructor({
    id,
    name,
    description,
    price,
    image_url,
    layout_size,
    connectivity,
    product_type,
    keycaps_type
  }) {
    Object.assign(this, {
      id,
      name,
      description,
      price,
      image_url,
      layout_size,
      connectivity,
      product_type,
      keycaps_type
    });
  }
}
