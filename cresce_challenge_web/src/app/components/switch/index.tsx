"use client";
import { useState } from "react";

interface SwitchProps {
  isOn: boolean;
}
interface checkedProps {
  checked: boolean;
}
const Switch = ({ isOn }: SwitchProps) => {
  return (
    <div className="relative inline-block w-10 h-5 cursor-pointer">
      <div
        data-testid="switch-container"
        className={`
          block w-full h-full rounded-full transition-all duration-300 ease-in-out
          ${isOn ? "bg-blue-500" : "bg-gray-300"}
        `}
      />
      <div
        className={`
          absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full shadow transition-all duration-300 ease-in-out
          ${isOn ? "transform translate-x-5" : "transform translate-x-0"}
        `}
      />
    </div>
  );
};
const StatusIndicator = ({ checked }: checkedProps) => {
  return (
    <div className="flex items-center gap-2">
      <Switch isOn={checked} />
    </div>
  );
};

export default StatusIndicator;
