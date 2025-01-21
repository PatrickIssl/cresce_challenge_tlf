"use client";
import React, { useState, useEffect } from "react";
import StatusIndicator from "./components/switch";
import { useRouter } from "next/navigation";
import Modal from "./components/modal";

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

const DiscountList = () => {
  const router = useRouter();
  const [products, setProducts] = useState<Product[]>([]);
  const [statusFilter, setStatusFilter] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);

  useEffect(() => {
    const storedProducts = localStorage.getItem("products");
    if (storedProducts) {
      setProducts(JSON.parse(storedProducts));
    }
  }, []);

  const handleViewProduct = (product: Product) => {
    setSelectedProduct(product);
    setIsModalOpen(true);
  };

  const handleEditProduct = () => {
    if (selectedProduct) {
      router.push(`/edit/${selectedProduct.id}`);
    }
  };

  const filteredProducts = products.filter((product) => {
    const typeFilterCase = typeFilter.toLowerCase();
    if (statusFilter === "ativo" && !product.status) return false;
    if (statusFilter === "inativo" && product.status) return false;
    if (typeFilterCase && product?.type?.toLowerCase() !== typeFilterCase)
      return false;
    return true;
  });

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString();
  };

  return (
    <div className="p-4 md:p-6 bg-gray-100 min-h-screen mt-12 md:mt-0">
      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onEdit={handleEditProduct}
        product={selectedProduct || undefined}
      />
      <h1 className="text-2xl md:text-3xl font-semibold">Lista de descontos</h1>
      <p className="text-gray-600 mb-4">Loja: Super João - Nova loja online</p>
      <div className="bg-white rounded-lg shadow">
        <div className="flex flex-col md:flex-row justify-between items-center mb-2 border-b border-b-gray-200 p-4">
          <h2 className="text-lg mb-2 md:mb-0">Descontos cadastrados</h2>
          <button
            onClick={() => router.push("/new")}
            className="w-full md:w-48 bg-[#0088b3] text-white px-4 py-2 rounded"
          >
            Novo desconto
          </button>
        </div>
        <div className="flex flex-col md:flex-row gap-4 mb-4 w-full p-4">
          <div className="w-full md:w-1/2">
            <label className="block mb-2" htmlFor="status-filter">Status</label>
            <select
              className="border p-2 md:p-4 rounded w-full"
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
            >
              <option value="">Todos</option>
              <option value="ativo">Ativo</option>
              <option value="inativo">Inativo</option>
            </select>
          </div>
          <div className="w-full md:w-1/2">
            <label className="block mb-2">Tipo desconto</label>
            <select
              className="border p-2 md:p-4 rounded w-full"
              value={typeFilter}
              onChange={(e) => setTypeFilter(e.target.value)}
            >
              <option value="">Todos</option>
              <option value="Leve + Pague -">Leve + Pague -</option>
              <option value="De_Por">De / Por</option>
              <option value="Percentual">Percentual</option>
            </select>
          </div>
        </div>
        <div className="hidden md:block overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-200">
              <tr>
                <th className="px-4 py-2 text-left">ID</th>
                <th className="px-4 py-2 text-left">Desconto</th>
                <th className="px-4 py-2 text-left">Tipo</th>
                <th className="px-4 py-2 text-left">Data ativação</th>
                <th className="px-4 py-2 text-left">Data inativação</th>
                <th className="px-4 py-2 text-left">Status</th>
                <th className="px-4 py-2 text-left"></th>
              </tr>
            </thead>
            <tbody>
              {filteredProducts.map((product, index) => (
                <tr key={index} className="border-b">
                  <td className="px-4 py-2">{product.id}</td>
                  <td className="px-4 py-2">
                    <div className="flex items-center gap-2">
                      <img
                        src={product.image || ""}
                        alt={product.name}
                        className="w-8 h-8 object-cover rounded"
                      />
                      <span>{product.name}</span>
                    </div>
                  </td>
                  <td className="px-4 py-2">{product.type}</td>
                  <td className="px-4 py-2">{formatDate(product.date_activation)}</td>
                  <td className="px-4 py-2">{formatDate(product.date_inactivation)}</td>
                  <td className="px-4 py-2">
                    <StatusIndicator checked={product.status} />
                  </td>
                  <td className="px-4 py-2">
                    <button aria-label="Visualizar" onClick={() => handleViewProduct(product)} className="text-blue-500">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        className="h-7 w-7"
                        viewBox="0 0 20 20"
                        fill="currentColor"
                      >
                        <path d="M10 12a2 2 0 100-4 2 2 0 000 4z" />
                        <path
                          fillRule="evenodd"
                          d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z"
                          clipRule="evenodd"
                        />
                      </svg>
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="md:hidden">
          {filteredProducts.map((product, index) => (
            <div key={index} className="border-b p-4">
              <div className="flex items-center justify-between mb-2">
                <div className="flex items-center gap-2">
                  <img
                    src={product.image || ""}
                    alt={product.name}
                    className="w-8 h-8 object-cover rounded"
                  />
                  <span className="font-medium">{product.name}</span>
                </div>
                <button onClick={() => handleViewProduct(product)} className="text-blue-500">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="h-6 w-6"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                  >
                    <path d="M10 12a2 2 0 100-4 2 2 0 000 4z" />
                    <path
                      fillRule="evenodd"
                      d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z"
                      clipRule="evenodd"
                    />
                  </svg>
                </button>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <div>
                  <span className="text-gray-500">ID:</span> {product.id}
                </div>
                <div>
                  <span className="text-gray-500">Tipo:</span> {product.type}
                </div>
                <div>
                  <span className="text-gray-500">Ativação:</span>{" "}
                  {formatDate(product.date_activation)}
                </div>
                <div>
                  <span className="text-gray-500">Inativação:</span>{" "}
                  {formatDate(product.date_inactivation)}
                </div>
                <div className="col-span-2">
                  <span className="text-gray-500">Status:</span>{" "}
                  <StatusIndicator checked={product.status} />
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default DiscountList;