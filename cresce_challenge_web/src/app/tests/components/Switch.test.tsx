import React from "react";
import { render, screen, act } from "@testing-library/react";
import "@testing-library/jest-dom";
import StatusIndicator from "../../components/switch";

describe("Switch Component", () => {
  test("Deve mostrar o componente sem erro", () => {
    act(() => {
      render(<StatusIndicator checked={false} />);
    });
    expect(screen.getByTestId("switch-container")).toBeInTheDocument();
  });

  test("Deve exibir ligado", () => {
    act(() => {
      render(<StatusIndicator checked={true} />);
    });
    const switchContainer = screen.getByTestId("switch-container");
    expect(switchContainer).toHaveClass("bg-blue-500");
  });

  test("Deve exibir desligado", () => {
    act(() => {
      render(<StatusIndicator checked={false} />);
    });
    const switchContainer = screen.getByTestId("switch-container");
    expect(switchContainer).toHaveClass("bg-gray-300");
  });
});
