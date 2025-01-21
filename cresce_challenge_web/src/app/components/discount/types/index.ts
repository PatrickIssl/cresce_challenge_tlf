export interface Product {
  id: string;
  fakeProductId: string;
  name: string;
  description: string;
  type: string;
  old_price: string;
  new_price: string;
  price: string;
  discount_percentage: string;
  take: string;
  pay: string;
  date_activation: string;
  date_inactivation: string;
  image: string | null;
  status: boolean;
}
