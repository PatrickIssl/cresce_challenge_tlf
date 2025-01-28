import React, { act } from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import "@testing-library/jest-dom";
import DiscountForm from "../../components/discount/form/index";

global.fetch = jest.fn(() =>
  Promise.resolve({
    ok: true,
    status: 200,
    json: () => Promise.resolve([{ id: 1, title: "Producto", price: 100, description: "descrição", category: "Categoria", image: "imagem" }]),
  })
) as jest.Mock;

describe("DiscountForm Component", () => {
  const mockHandleSubmit = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
    render(<DiscountForm handleSubmit={mockHandleSubmit} />);
  });

  test("Deve mostrar o componentes corretamente", () => {
    expect(screen.getByText(/Editar desconto/i)).toBeInTheDocument();
  });

  test("Deve chamar o metodo submit com o valor do campo", () => {
    fireEvent.change(screen.getByLabelText(/Nome do desconto/i), {
      target: { value: "Desconto" },
    });
    fireEvent.click(screen.getByText(/Salvar/i));
    expect(mockHandleSubmit).toHaveBeenCalledWith(expect.objectContaining({
      name: "Desconto",
    }));
  });

  test("Deve alterar o estado do input", () => {
    fireEvent.change(screen.getByLabelText(/Nome do desconto/i), {
      target: { value: "Novo Nome" },
    });
    const input = screen.getByLabelText(/Nome do desconto/i) as HTMLInputElement;
    expect(input.value).toBe("Novo Nome");
  });

});
