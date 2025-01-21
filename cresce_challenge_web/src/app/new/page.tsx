"use client";
import { useRouter } from "next/navigation";
import DiscountForm from "../components/discount/form";

interface Product {
  id: string;
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

const NewDiscountForm = () => {
  const router = useRouter();

  const handleSubmit = (formData: Product) => {
    const existingProducts = JSON.parse(
      localStorage.getItem("products") || "[]"
    );

    const newProduct = {
      ...formData,
      id: Math.floor(Math.random() * 1000),
    };

    existingProducts.push(newProduct);

    localStorage.setItem("products", JSON.stringify(existingProducts));

    router.push("/");
  };

  return <DiscountForm handleSubmit={handleSubmit} />;
};

export default NewDiscountForm;
