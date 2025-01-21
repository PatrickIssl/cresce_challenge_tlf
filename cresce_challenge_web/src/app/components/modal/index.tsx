import React from "react";

interface Product {
  name: string;
  description: string;
  type: string;
  old_price: string;
  new_price: string;
  price: any;
  discount_percentage: string;
  take: string;
  pay: string;
  date_activation: string;
  date_inactivation: string;
  image: string | null;
  status: boolean;
}

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  onEdit: () => void;
  product?: Product;
}

const Modal: React.FC<ModalProps> = ({ isOpen, onClose, onEdit, product }) => {
  if (!isOpen || !product) return null;
  const discountValue =
    product.price -
    (product.price * parseInt(product.discount_percentage, 10)) / 100;
  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg w-full max-w-md mx-4">
        <div className="flex justify-between items-center p-4 border-b-2 border-b-blue-400">
          <h2 className="text-lg text-gray-600 m-auto font-bold">
            Detalhes do desconto
          </h2>
          <button
            onClick={onClose}
            className="text-blue-600 hover:text-blue-800"
          >
            ✕
          </button>
        </div>
        <div className="p-6">
          <div className="flex space-x-4">
            <div className="w-48">
              <img
                src={product.image || "/placeholder-image.png"}
                alt={product.name}
                className="w-full"
              />
            </div>
            <div className="flex-1">
              {product.type === "PERCENTUAL" && (
                <p className="text-lg font-bold">
                  {product.discount_percentage}% OFF
                </p>
              )}

              {product.type === "LEVE_PAGUE" && (
                <p className="text-lg font-bold">
                  Leve {product.take} Pague {product.pay}
                </p>
              )}
              <h3 className="font-medium">{product.name}</h3>
              <p className="text-sm text-gray-600">{product.description}</p>
              <div className="mt-2">
                {product.type === "DE_POR" && (
                  <>
                    <p className="text-md text-gray-500">
                      de R$ {product.old_price}
                    </p>
                    <p className="text-lg font-medium">
                      por R$ {product.new_price}
                    </p>
                  </>
                )}
                {product.type === "PERCENTUAL" && (
                  <>
                    <p className="text-md text-gray-500 line-through">
                      R$ {product.price}
                    </p>
                    <p className="text-lg font-medium">R$ {discountValue.toFixed(2)}</p>
                  </>
                )}
                {product.type === "LEVE_PAGUE" && (
                  <p className="text-lg font-bold">R$ {product.price}</p>
                )}
              </div>
            </div>
          </div>
        </div>
        <div className="flex justify-between p-4 space-x-4">
          <button
            onClick={onEdit}
            className="px-4 py-2 w-full text-blue-600 border border-blue-600 rounded hover:bg-blue-50"
          >
            Editar
          </button>
          <button
            onClick={onClose}
            className="px-4 py-2 w-full bg-blue-600 text-white rounded hover:bg-blue-700"
          >
            Fechar
          </button>
        </div>
      </div>
    </div>
  );
};

export default Modal;
