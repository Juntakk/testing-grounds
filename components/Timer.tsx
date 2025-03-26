"use client";
import { t } from "@/locales/en";
import { useState, useEffect } from "react";

const Timer = () => {
  const [time, setTime] = useState<number>(
    Date.now() - new Date(1970, 0, 1).getTime()
  );

  useEffect(() => {
    const updateTimer = () => {
      setTime(Date.now() - new Date(1970, 0, 1).getTime());
    };

    const timer = setInterval(updateTimer, 1000);
    return () => clearInterval(timer);
  }, []);

  const formatTime = (milliseconds: number) => {
    const totalSeconds = Math.floor(milliseconds / 1000);
    const totalMinutes = Math.floor(totalSeconds / 60);
    const totalHours = Math.floor(totalMinutes / 60);
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const totalDays = Math.floor(totalHours / 24);

    const currentDate = new Date();
    const startDate = new Date(1970, 0, 1);

    let years = currentDate.getFullYear() - startDate.getFullYear();
    let months = currentDate.getMonth() - startDate.getMonth();
    let days = currentDate.getDate() - startDate.getDate();
    const hours = currentDate.getHours();
    const minutes = currentDate.getMinutes();
    const seconds = currentDate.getSeconds();

    if (days < 0) {
      months--;
      const prevMonth = (currentDate.getMonth() - 1 + 12) % 12;
      const daysInPrevMonth = new Date(
        currentDate.getFullYear(),
        prevMonth + 1,
        0
      ).getDate();
      days += daysInPrevMonth;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    return `${years} years, ${months} months, ${days} days, ${hours} hours, ${minutes} minutes, ${seconds} seconds`;
  };

  return (
    <div>
      {t.timeElapsed}: {formatTime(time)}
    </div>
  );
};

export default Timer;
