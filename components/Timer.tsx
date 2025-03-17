"use client";
import { useState, useEffect } from "react";

const TimerComponent = () => {
  const [time, setTime] = useState<number>(0);

  useEffect(() => {
    setTime(Date.now());
  }, []);

  useEffect(() => {
    if (time !== null) {
      const updateTimer = () => {
        setTime((prev) => prev! + 1000);
        setTimeout(updateTimer, 1000);
      };

      const timer = setTimeout(updateTimer, 1000);

      return () => clearTimeout(timer);
    }
  }, [time]);

  return (
    <div>Time Elapsed since January 1st 1970: {Math.round(time / 10000)}</div>
  );
};

export default TimerComponent;
