"use client";

import { useState } from "react";

const GamePage = () => {
  const colors = [
    "red",
    "green",
    "blue",
    "orange",
    "yellow",
    "cyan",
    "teal",
    "purple",
    "pink",
  ];

  function getRandomColor() {
    const rand = Math.floor(Math.random() * colors.length);
    return colors[rand];
  }

  const [gridColors, setGridColors] = useState(Array(9).fill("transparent"));

  const handleEnter = (index: number) => {
    setGridColors((prev) =>
      prev.map((color, i) => (i === index ? getRandomColor() : color))
    );
  };
  const handleLeave = (index: number) => {
    setGridColors((prev) =>
      prev.map((color, i) => (i === index ? "transparent" : color))
    );
  };

  return (
    <div className="flex justify-center items-center h-screen">
      <div className="w-[400px] h-[500px] grid grid-cols-3 border-2">
        {gridColors.map((color, index) => (
          <div
            key={index}
            style={{ background: color }}
            className={`h-full w-full border-2 rounded-none`}
            onMouseEnter={() => handleEnter(index)}
            onMouseLeave={() => handleLeave(index)}
          ></div>
        ))}
      </div>
    </div>
  );
};

export default GamePage;
