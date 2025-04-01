"use client";

import { Button } from "@/components/ui/button";
import { useState, useEffect, useMemo } from "react";

const GamePage = () => {
  const colors = useMemo(
    () => [
      "red",
      "green",
      "blue",
      "orange",
      "yellow",
      "cyan",
      "teal",
      "purple",
      "pink",
    ],
    []
  );

  const [gridColors, setGridColors] = useState(Array(9).fill("transparent"));
  const [sequence, setSequence] = useState<number[]>([]);
  const [userSequence, setUserSequence] = useState<number[]>([]);
  const [showSequence, setShowSequence] = useState(false);
  const [charging, setCharging] = useState(false);
  const [message, setMessage] = useState("");

  useEffect(() => {
    if (showSequence) {
      let index = 0;

      const interval = setInterval(() => {
        if (index < sequence.length) {
          setGridColors((prev) =>
            prev.map((color, i) =>
              i === sequence[index] ? colors[sequence[index]] : color
            )
          );
          setTimeout(() => {
            setGridColors(Array(9).fill("transparent"));
            index++;
          }, 500);
        } else {
          clearInterval(interval);
          setShowSequence(false);
        }
      }, 1000);
      return () => clearInterval(interval);
    }
  }, [colors, sequence, showSequence]);

  useEffect(() => {
    if (userSequence.length === sequence.length && sequence.length > 0) {
      if (JSON.stringify(userSequence) === JSON.stringify(sequence)) {
        setMessage("Correct! Next round!");
        setUserSequence([]);
        addColorToSequence();
      } else {
        setMessage("Game Over! Try again!");
        resetGame();
      }
    }
  }, [sequence, userSequence]);

  function addColorToSequence() {
    const rand = Math.floor(Math.random() * 9);
    setSequence((prev) => [...prev, rand]);
    setShowSequence(true);
  }

  function handleBoxClick(index: number) {
    if (!showSequence && !charging) {
      setUserSequence((prev) => [...prev, index]);
      setGridColors((prev) =>
        prev.map((color, i) => (i === index ? colors[index] : color))
      );
      setTimeout(() => {
        setGridColors((prev) =>
          prev.map((color, i) => (i === index ? "transparent" : color))
        );
      }, 500);
    }
  }

  function startGame() {
    setMessage("");
    setSequence([]);
    setUserSequence([]);
    setCharging(true);
    const chargeColors = Array(9)
      .fill(null)
      .map(() => getRandomColor());
    let index = 0;
    const interval = setInterval(() => {
      if (index < chargeColors.length) {
        setGridColors((prev) =>
          prev.map((color, i) => (i === index ? chargeColors[index] : color))
        );
        setTimeout(() => {
          index++;
          if (index < chargeColors.length) {
            setGridColors((prev) =>
              prev.map((color, i) =>
                i === index ? chargeColors[index] : color
              )
            );
          } else {
            setGridColors(Array(9).fill("transparent"));
            clearInterval(interval);
            setCharging(false);
            addColorToSequence();
          }
        }, 50);
      } else {
        clearInterval(interval);
        setCharging(false);
        addColorToSequence();
      }
    }, 50);
  }

  function resetGame() {
    setSequence([]);
    setUserSequence([]);
    setGridColors(Array(9).fill("transparent"));
  }

  function getRandomColor() {
    const rand = Math.floor(Math.random() * colors.length);
    return colors[rand];
  }

  return (
    <div className="flex flex-col justify-center items-center h-screen">
      <Button
        onClick={startGame}
        className="mb-4 p-2 bg-blue-500 text-white rounded"
      >
        Start Game
      </Button>
      <div className="w-[400px] h-[500px] grid grid-cols-3 gap-1">
        {gridColors.map((color, index) => (
          <div
            key={index}
            style={{ background: color, cursor: "pointer" }}
            className={`h-full w-full border-2 rounded-none`}
            onClick={() => handleBoxClick(index)}
          ></div>
        ))}
      </div>
      {message && <div className="mt-4 text-lg">{message}</div>}
    </div>
  );
};

export default GamePage;
