import React from "react";
import { render, screen, fireEvent, act } from "@testing-library/react";
import "@testing-library/jest-dom";
import EditDiscountForm from "../edit/[id]/page";
import { useParams, useRouter } from "next/navigation";

jest.mock("next/navigation", () => ({
  useRouter: jest.fn(),
  useParams: jest.fn(),
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

describe("EditDiscountForm Component", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });


  test("Deve atualizar o produto e redirecionar ao submeter o formulário", async () => {
    const pushMock = jest.fn();
    (useRouter as jest.Mock).mockReturnValue({ push: pushMock });
    (useParams as jest.Mock).mockReturnValue({ id: "1" });

    const mockProduct = {
      id: 1,
      name: "Desconto Antigo",
      discount: 5,
      type: "DE_POR",
      status: true,
      fakeProductId: 123,
      image: "fake-image-url.jpg",
    };
    localStorage.setItem("products", JSON.stringify([mockProduct]));

    await act(async () => {
      render(<EditDiscountForm />);
    });

    const nameInput = screen.getByDisplayValue("Desconto Antigo");
    fireEvent.change(nameInput, { target: { value: "Desconto Novo" } });

    fireEvent.submit(screen.getByRole("form"));

    const updatedProducts = JSON.parse(localStorage.getItem("products") || "[]");
    expect(updatedProducts[0].name).toBe("Desconto Novo");

    expect(pushMock).toHaveBeenCalledWith("/");
  });
});
