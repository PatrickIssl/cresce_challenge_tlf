import React from "react";
import { render, screen, fireEvent, act } from "@testing-library/react";
import "@testing-library/jest-dom";
import NewDiscountForm from "../new/page";
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

global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.resolve([]),
  })
) as jest.Mock;

describe("NewDiscountForm Component", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Deve permitir adicionar um novo desconto", async () => {
    const pushMock = jest.fn();
    (useRouter as jest.Mock).mockReturnValue({ push: pushMock });

    await act(async () => {
      render(<NewDiscountForm />);
    });

    fireEvent.change(screen.getByLabelText("Nome do desconto"), { target: { value: "Promoção Especial" } });
    fireEvent.change(screen.getByLabelText("Descrição do desconto"), { target: { value: "Desconto de 20% em todos os produtos" } });

    fireEvent.submit(screen.getByRole("form"));

    const savedProducts = JSON.parse(localStorage.getItem("products") || "[]");
    expect(savedProducts.length).toBe(1);
    expect(savedProducts[0].name).toBe("Promoção Especial");

    expect(pushMock).toHaveBeenCalledWith("/");
  });
});
