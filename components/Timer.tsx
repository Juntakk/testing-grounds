"use client";
import { t } from "@/locales/en";
import { useState, useEffect } from "react";

const Timer = () => {
  const [time, setTime] = useState<number>(0);

  useEffect(() => {
    setTime(Date.now());
  }, []);

  //   useEffect(() => {
  //     if (time !== null) {
  //       const updateTimer = () => {
  //         setTime((prev) => prev! + 1000);
  //         setTimeout(updateTimer, 1000);
  //       };

  //       const timer = setTimeout(updateTimer, 1000);

  //       return () => clearTimeout(timer);
  //     }
  //   }, [time]);

  const formatTime = (milliseconds: number) => {
    const seconds = milliseconds / 1000;
    const remainingMinutes = milliseconds - seconds / 60;
    const hours = remainingMinutes / 60;
    const days = hours / 24;

    return "";
  };

  return (
    <div>
      {t.timeElapsed}
      {formatTime(time)}
    </div>
  );
};

export default Timer;
