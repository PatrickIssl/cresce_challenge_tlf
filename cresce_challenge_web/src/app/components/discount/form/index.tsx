import React, { useEffect, useRef, useState } from "react";
import { Product } from "../types";

interface FakeStoreProduct {
  id: number;
  title: string;
  price: number;
  description: string;
  category: string;
  image: string;
}

interface DiscountProps {
  product?: Product;
  handleSubmit: (product: Product) => void;
}

function DiscountForm({ product, handleSubmit }: DiscountProps) {
  const [fakeStoreProducts, setFakeStoreProducts] = useState<FakeStoreProduct[]>([]);
  const [selectedProduct, setSelectedProduct] = useState<string>("");
  const [image, setImage] = useState<string | null>(null);
  const [discountType, setDiscountType] = useState("");
  const [isActive, setIsActive] = useState(true);
  const [formData, setFormData] = useState<Product>({
    id: "",
    fakeProductId: "",
    name: "",
    description: "",
    type: "",
    old_price: "",
    new_price: "",
    price: "",
    discount_percentage: "",
    take: "",
    pay: "",
    date_activation: "",
    date_inactivation: "",
    image: null,
    status: true,
  });

  const fileInputRef = useRef<HTMLInputElement>(null);
  
  useEffect(() => {
    fetch("https://fakestoreapi.com/products")
      .then((res) => res.json())
      .then((data) => setFakeStoreProducts(data))
      .catch((error) => console.error("Error fetching products:", error));
  }, []);

  useEffect(() => {
    if (product?.name) {
      setIsActive(product.status);
      setSelectedProduct(product.fakeProductId);
      setDiscountType(product.type ? product.type.toUpperCase() : "");
      setFormData(product);
      setImage(product.image);
    }
  }, [product]);

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    const file = e.dataTransfer.files[0];
    if (file && file.type.startsWith("image/")) {
      handleFile(file);
    }
  };

  const handleFile = (file: File) => {
    const reader = new FileReader();
    reader.onload = (e) => {
      const imageResult = e.target?.result as string;
      setImage(imageResult);
      setFormData((prev) => ({ ...prev, image: imageResult }));
    };
    reader.readAsDataURL(file);
  };

  const handleClick = () => {
    fileInputRef.current?.click();
  };

  const handleFileInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file && file.type.startsWith("image/")) {
      handleFile(file);
    }
  };

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>
  ) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleProductSelect = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const productId = e.target.value;
    setSelectedProduct(productId);

    if (productId) {
      const selected = fakeStoreProducts.find((p) => p.id.toString() === productId);
      if (selected) {
        setFormData((prev) => ({
          ...prev,
          description: selected.description,
          old_price: selected.price.toString(),
          price: selected.price.toString(),
          image: selected.image,
        }));
        setImage(selected.image);
      }
    }
  };

  const handleDiscountTypeChange = (e: { target: { value: string } }) => {
    const newDiscountType = e.target.value;
    setDiscountType(newDiscountType);
    setFormData({
      ...formData,
      type: e.target.value,
      new_price: "",
      discount_percentage: "",
      take: "",
      pay: "",
    });
  };

  return (
    <div className="flex min-h-screen bg-gray-100 p-4 mt-12 md:mt-0">
      <div className="flex-1 mx-auto">
        <h1 className="text-xl md:text-3xl font-semibold">Editar desconto</h1>
        <p className="text-sm md:text-base">Loja: Super João - Nova loja online</p>

        <div className="bg-white p-4 md:p-6 mt-4 rounded-lg shadow-sm">
          <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 border-b border-b-gray-200 pb-4">
            <h2 className="text-lg mb-2 md:mb-0">Formulário cadastro desconto</h2>
            <div className="flex items-center">
              <span className="mr-2 text-sm md:text-base">Ativo</span>
              <label className="relative inline-flex items-center cursor-pointer">
                <input
                  type="checkbox"
                  checked={isActive}
                  onChange={() => {
                    formData.status = !isActive;
                    setIsActive(!isActive);
                  }}
                  className="sr-only peer"
                />
                <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
              </label>
            </div>
          </div>
          <form
            role="form"
            className="space-y-4"
            onSubmit={(e) => {
              e.preventDefault();
              formData.fakeProductId = selectedProduct;
              handleSubmit(formData);
            }}
          >
            <div>
              <label htmlFor="product-select" className="block text-sm font-medium mb-1">
                Selecionar Produto
              </label>
              <select
                id="product-select"
                value={selectedProduct}
                onChange={handleProductSelect}
                className="w-full p-2 border rounded text-sm md:text-base"
              >
                <option value="">Selecione um produto</option>
                {fakeStoreProducts.map((product) => (
                  <option key={product.id} value={product.id}>
                    {product.title}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label htmlFor="name" className="block text-sm font-medium mb-1">
                Nome do desconto
              </label>
              <input
                id="name"
                type="text"
                name="name"
                value={formData.name ?? ""}
                onChange={handleInputChange}
                className="w-full p-2 border rounded text-sm md:text-base"
              />
            </div>
            <div>
              <label htmlFor="description" className="block text-sm font-medium mb-1">
                Descrição do desconto
              </label>
              <textarea
                name="description"
                id="description"
                value={formData.description ?? ""}
                onChange={handleInputChange}
                className="w-full p-2 border rounded text-sm md:text-base"
                rows={3}
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">
                Tipo do desconto
              </label>
              <select
                value={discountType}
                onChange={handleDiscountTypeChange}
                className="w-full p-2 md:p-4 border rounded text-sm md:text-base"
              >
                <option value="" disabled></option>
                <option value="DE_POR">DE / POR</option>
                <option value="PERCENTUAL">PERCENTUAL</option>
                <option value="LEVE_PAGUE">LEVE + PAGUE -</option>
              </select>
            </div>
            {discountType === "DE_POR" && (
              <div className="flex flex-col md:flex-row gap-4">
                <div className="flex flex-col w-full">
                  <label className="block text-sm font-medium mb-1">
                    Preço "DE"
                  </label>
                  <input
                    type="number"
                    name="old_price"
                    value={formData.old_price}
                    onChange={handleInputChange}
                    className="p-2 border rounded text-sm md:text-base"
                  />
                </div>
                <div className="flex flex-col w-full">
                  <label className="block text-sm font-medium mb-1">
                    Preço "POR"
                  </label>
                  <input
                    type="number"
                    name="new_price"
                    value={formData.new_price}
                    onChange={handleInputChange}
                    className="p-2 border rounded text-sm md:text-base"
                  />
                </div>
              </div>
            )}
            {discountType === "PERCENTUAL" && (
              <div className="flex flex-col md:flex-row gap-4">
                <div className="flex flex-col w-full">
                  <label className="block text-sm font-medium mb-1">
                    Preço
                  </label>
                  <input
                    type="number"
                    name="price"
                    value={formData.price}
                    onChange={handleInputChange}
                    className="p-2 border rounded text-sm md:text-base"
                  />
                </div>
                <div className="flex flex-col w-full">
                  <label className="block text-sm font-medium mb-1">
                    Percentual de Desconto
                  </label>
                  <input
                    type="number"
                    name="discount_percentage"
                    value={formData.discount_percentage}
                    onChange={handleInputChange}
                    className="p-2 border rounded text-sm md:text-base"
                  />
                </div>
              </div>
            )}
            {discountType === "LEVE_PAGUE" && (
              <div className="flex flex-col md:flex-row gap-4">
                <div className="flex flex-col w-full">
                  <label className="block text-sm font-medium mb-1">
                    Preço
                  </label>
                  <input
                    type="number"
                    name="price"
                    value={formData.price}
                    onChange={handleInputChange}
                    className="p-2 border rounded text-sm md:text-base"
                  />
                </div>
                <div className="flex flex-col w-full">
                  <label className="block text-sm font-medium mb-1">Leve</label>
                  <input
                    type="number"
                    name="take"
                    value={formData.take}
                    onChange={handleInputChange}
                    className="p-2 border rounded text-sm md:text-base"
                  />
                </div>
                <div className="flex flex-col w-full">
                  <label className="block text-sm font-medium mb-1">
                    Pague
                  </label>
                  <input
                    type="number"
                    name="pay"
                    value={formData.pay}
                    onChange={handleInputChange}
                    className="p-2 border rounded text-sm md:text-base"
                  />
                </div>
              </div>
            )}
            <div className="flex flex-col md:flex-row gap-4">
              <div className="flex flex-col w-full">
                <label className="block text-sm font-medium mb-1">
                  Data de ativação
                </label>
                <input
                  type="datetime-local"
                  name="date_activation"
                  value={formData.date_activation}
                  onChange={handleInputChange}
                  className="p-2 border rounded text-sm md:text-base"
                />
              </div>
              <div className="flex flex-col w-full">
                <label className="block text-sm font-medium mb-1">
                  Data de inativação
                </label>
                <input
                  type="datetime-local"
                  name="date_inactivation"
                  value={formData.date_inactivation}
                  onChange={handleInputChange}
                  className="p-2 border rounded text-sm md:text-base"
                />
              </div>
            </div>
            <div
              className="border-2 border-dashed border-gray-300 rounded-lg p-6 md:p-12 text-center cursor-pointer"
              onDragOver={(e) => e.preventDefault()}
              onDrop={handleDrop}
              onClick={handleClick}
            >
              {image ? (
                <div className="relative">
                  <img
                    src={image}
                    alt="Uploaded"
                    className="max-w-full h-96 mx-auto"
                  />
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      setImage(null);
                      setFormData((prev) => ({ ...prev, image: null }));
                    }}
                    className="absolute top-2 right-2 bg-red-500 text-white rounded-full p-1"
                  >
                    <svg
                      className="w-4 h-4"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M6 18L18 6M6 6l12 12"
                      />
                    </svg>
                  </button>
                </div>
              ) : (
                <div>
                  <div className="flex justify-center mb-2">
                    <svg
                      className="w-8 h-8 md:w-12 md:h-12 text-gray-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
                      />
                    </svg>
                  </div>
                  <p className="text-gray-500 text-sm md:text-base">
                    Arraste e solte a imagem aqui ou clique para upload!
                  </p>
                </div>
              )}
              <input
                type="file"
                ref={fileInputRef}
                className="hidden"
                accept="image/*"
                onChange={handleFileInput}
              />
            </div>
            <div className="flex justify-end">
              <button
                type="submit"
                className="bg-[#008DC9] text-white px-4 md:px-6 py-2 rounded hover:bg-[#007bb3] text-sm md:text-base"
              >
                Salvar
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}

export default DiscountForm;