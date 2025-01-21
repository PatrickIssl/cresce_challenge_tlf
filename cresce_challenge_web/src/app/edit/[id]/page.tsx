"use client";
import { useState, useRef, useEffect } from "react";
import { useParams, useRouter } from "next/navigation";
import DiscountForm from "@/app/components/discount/form";
import { Product } from "@/app/components/discount/types";

const EditDiscountForm = () => {
  const router = useRouter();
  const params = useParams();
  const productId = params.id;
  const [initialProduct, setInitialProduct] = useState({} as Product);

  useEffect(() => {
    const products = JSON.parse(localStorage.getItem("products") || "[]");
    const product = products.find(
      (p: Product) => p.id.toString() === productId?.toString()
    );
    if (product) {
      setInitialProduct(product);
    }
  }, [productId]);

  const handleSubmit = (formData: Product) => {
    const products = JSON.parse(localStorage.getItem("products") || "[]");
    const productIndex = products.findIndex(
      (p: Product) => p.id.toString() === productId?.toString()
    );
    if (productIndex !== -1) {
      products[productIndex] = formData;
      localStorage.setItem("products", JSON.stringify(products));
      router.push("/");
    }
  };
  return <DiscountForm product={initialProduct} handleSubmit={handleSubmit} />;
}
export default EditDiscountForm;
