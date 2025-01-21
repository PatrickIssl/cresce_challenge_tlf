import React from "react";
import { render, screen, fireEvent, act, waitFor } from "@testing-library/react";
import "@testing-library/jest-dom";
import DiscountList from "../page";
import { useRouter } from "next/navigation";

jest.mock("next/navigation", () => ({
  useRouter: jest.fn(),
}));

const mockLocalStorage = (() => {
  let store: Record<string, string> = {};
  return {
    getItem: (key: string) => store[key] || null,
    setItem: (key: string, value: string) => (store[key] = value),
    clear: () => (store = {}),
  };
})();

Object.defineProperty(window, "localStorage", { value: mockLocalStorage });

describe("DiscountList Component", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Deve renderizar a lista de descontos", async () => {
    (useRouter as jest.Mock).mockReturnValue({ push: jest.fn() });

    const mockProducts = [
      {
        id: "1",
        name: "Promoção Teste",
        description: "Desconto de teste",
        type: "percentage",
        old_price: "100",
        new_price: "80",
        price: "80",
        discount_percentage: "20",
        take: "0",
        pay: "0",
        date_activation: "2024-01-01",
        date_inactivation: "2024-12-31",
        image: "fake-image-url.jpg",
        status: true,
      },
    ];
    localStorage.setItem("products", JSON.stringify(mockProducts));

    await act(async () => {
      render(<DiscountList />);
    });

    expect(screen.getAllByText("Promoção Teste").length).toBeGreaterThan(0);
    expect(screen.getByText("Lista de descontos")).toBeInTheDocument();
  });

  test("Deve redirecionar para a página de novo desconto", async () => {
    const pushMock = jest.fn();
    (useRouter as jest.Mock).mockReturnValue({ push: pushMock });

    await act(async () => {
      render(<DiscountList />);
    });

    fireEvent.click(screen.getByText("Novo desconto"));
    expect(pushMock).toHaveBeenCalledWith("/new");
  });

  test("Deve redirecionar para a página de edição ao clicar em editar", async () => {
    const pushMock = jest.fn();
    (useRouter as jest.Mock).mockReturnValue({ push: pushMock });

    await act(async () => {
      render(<DiscountList />);
    });

    fireEvent.click(screen.getByRole("button", { name: "Visualizar" }));

    fireEvent.click(screen.getByText("Editar"));

    expect(pushMock).toHaveBeenCalledWith("/edit/1");
  });
});
