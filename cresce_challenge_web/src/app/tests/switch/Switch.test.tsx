import React from "react";
import { render, screen } from "@testing-library/react";
import "@testing-library/jest-dom";
import StatusIndicator from "../../components/switch";

describe("Switch Component", () => {
  test("renderiza corretamente quando ligado", () => {
    render(<StatusIndicator checked={true} />);
    const switchElement = screen.getByTestId("switch-container");
    expect(switchElement).toHaveClass("bg-blue-500");
  });

  test("renderiza corretamente quando desligado", () => {
    render(<StatusIndicator checked={false} />);
    const switchElement = screen.getByTestId("switch-container");
    expect(switchElement).toHaveClass("bg-gray-300");
  });
});
