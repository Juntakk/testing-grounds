"use server";

import { RANDOM_MEAL_URL } from "../constants";

export async function fetchRandomMeal() {
  const res = await fetch(RANDOM_MEAL_URL);
  const data = res.json();

  return data;
}
