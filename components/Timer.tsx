"use client";
import { t } from "@/locales/en";
import { useState, useEffect } from "react";

const Timer = () => {
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
    <div>
      {t.timeElapsed}
      {Math.round(time)}
    </div>
  );
};

export default Timer;
