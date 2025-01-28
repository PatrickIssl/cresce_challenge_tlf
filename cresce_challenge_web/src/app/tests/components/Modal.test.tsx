import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import "@testing-library/jest-dom";
import Modal from "../../components/modal";

describe("Modal Component", () => {
  const mockProduct = {
    name: "Produto Teste",
    description: "Teste",
    type: "PERCENTUAL",
    old_price: "100",
    new_price: "80",
    price: 100,
    discount_percentage: "20",
    take: "1",
    pay: "1",
    date_activation: "2023-01-01",
    date_inactivation: "2023-12-31",
    image: null,
    status: true,
  };

  test("deve mostrar o modal quando isopen é true", () => {
    render(<Modal isOpen={true} onClose={() => {}} onEdit={() => {}} product={mockProduct} />);
    expect(screen.getByText("Detalhes do desconto")).toBeInTheDocument();
    expect(screen.getByText("Produto Teste")).toBeInTheDocument();
  });

  test("não deve mostrar o modal quando isopen é false", () => {
    render(<Modal isOpen={false} onClose={() => {}} onEdit={() => {}} product={mockProduct} />);
    expect(screen.queryByText("Detalhes do desconto")).not.toBeInTheDocument();
  });

  test("deve chamar a função onClose quando o botão Fechar é clicado", () => {
    const handleClose = jest.fn();
    render(<Modal isOpen={true} onClose={handleClose} onEdit={() => {}} product={mockProduct} />);
    fireEvent.click(screen.getByText("Fechar"));
    expect(handleClose).toHaveBeenCalledTimes(1);
  });

  test("deve chamar a função onEdit quando o botão Editar é clicado", () => {
    const handleEdit = jest.fn();
    render(<Modal isOpen={true} onClose={() => {}} onEdit={handleEdit} product={mockProduct} />);
    fireEvent.click(screen.getByText("Editar"));
    expect(handleEdit).toHaveBeenCalledTimes(1);
  });
});
