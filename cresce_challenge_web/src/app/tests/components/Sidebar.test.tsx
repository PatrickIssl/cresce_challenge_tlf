import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import "@testing-library/jest-dom";
import { Sidebar } from "../../components/sidebar";

describe("Sidebar Component", () => {
  test("Sidebar deve estar fechada por padrão", () => {
    render(<Sidebar />);

    const sidebar = screen.getByTestId("sidebar");
    expect(sidebar).toHaveClass("-translate-x-full");
  });

  test("Sidebar deve abrir ao clicar no botão de menu", () => {
    render(<Sidebar />);
    const menuButton = screen.getByTestId("menu-button");
    fireEvent.click(menuButton);
    const sidebar = screen.getByTestId("sidebar");
    expect(sidebar).toHaveClass("translate-x-0");
  });

  test("Sidebar deve fechar ao clicar no botão de fechar", () => {
    render(<Sidebar />);

    const menuButton = screen.getByTestId("menu-button");
    fireEvent.click(menuButton);

    const closeButton = screen.getByTestId("close-button");
    fireEvent.click(closeButton);

    const sidebar = screen.getByTestId("sidebar");
    expect(sidebar).toHaveClass("-translate-x-full");
  });

  test("Sidebar fecha ao clicar fora dela", () => {
    render(<Sidebar />);

    const menuButton = screen.getByTestId("menu-button");
    fireEvent.click(menuButton);

    const overlay = screen.getByTestId("overlay");
    fireEvent.click(overlay);

    const sidebar = screen.getByTestId("sidebar");
    expect(sidebar).toHaveClass("-translate-x-full");
  });

  test("Sidebar deve conter um link para Lista descontos", () => {
    render(<Sidebar />);

    const menuItem = screen.getByText("Lista descontos");
    expect(menuItem).toBeInTheDocument();
  });
});
