"use client";

import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { fetchRandomMeal } from "@/lib/actions/meals.actions";
import { ChefHat, Loader2 } from "lucide-react";
import Image from "next/image";
import { useState, useTransition } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";

const MealsPage = () => {
  const [randomMeal, setRandomMeal] = useState<
    | {
        strArea: string;
        strCategory: string;
        strMeal: string;
        strInstructions: string;
        strMealThumb: string;
      }[]
    | null
  >(null);
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  const handleRandomMealFetch = async () => {
    setError(null);
    startTransition(async () => {
      const data = await fetchRandomMeal();
      await new Promise((resolve) => setTimeout(resolve, 1000));

      setRandomMeal(data.meals);
    });
  };

  return (
    <div className="flex flex-col items-center container mx-auto py-8 px-4 max-w-3xl">
      <div className="text-center mb-8">
        <h1 className="text-3xl font-bold mb-3">Random Meal Generator</h1>
        <p className="text-muted-foreground mb-6">
          Discover new recipes with a single click!
        </p>

        <Button
          onClick={handleRandomMealFetch}
          size="lg"
          className="min-w-[180px]"
          disabled={isPending}
        >
          {isPending ? (
            <>
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              Finding meal...
            </>
          ) : (
            <>
              <ChefHat className="mr-2 h-4 w-4" />
              {randomMeal ? "Try another meal" : "Get random meal"}
            </>
          )}
        </Button>
      </div>

      {error && (
        <div className="bg-destructive/10 text-destructive rounded-lg p-4 mb-6 w-full">
          {error}
        </div>
      )}

      <div className="w-full">
        {isPending ? (
          <div className="w-full rounded-lg border bg-card shadow-sm p-4">
            <div className="flex flex-col md:flex-row gap-6">
              <Skeleton className="h-[200px] w-full md:w-[200px] rounded-full bg-zinc-800" />
              <div className="flex-1 space-y-4">
                <Skeleton className="h-8 w-3/4 bg-zinc-800" />
                <div className="flex gap-2">
                  <Skeleton className="h-5 w-20 bg-zinc-800" />
                  <Skeleton className="h-5 w-20 bg-zinc-800" />
                </div>
                <div className="space-y-2">
                  <Skeleton className="h-4 w-full bg-zinc-800" />
                  <Skeleton className="h-4 w-full bg-zinc-800" />
                  <Skeleton className="h-4 w-3/4 bg-zinc-800" />
                </div>
              </div>
            </div>
          </div>
        ) : randomMeal && randomMeal.length > 0 ? (
          <div className="w-full rounded-lg border bg-card shadow-sm overflow-hidden">
            <div className="flex flex-col md:flex-row">
              <div className="relative h-[200px] md:h-auto md:w-[200px]">
                <Image
                  src={
                    randomMeal[0].strMealThumb ||
                    "/placeholder.svg?height=400&width=400"
                  }
                  alt={randomMeal[0].strMeal}
                  fill
                  className="object-cover"
                  sizes="(max-width: 768px) 100vw, 200px"
                />
              </div>
              <div className="p-6 flex-1">
                <h2 className="text-2xl font-bold mb-2">
                  {randomMeal[0].strMeal}
                </h2>
                <div className="flex flex-wrap gap-2 mb-4">
                  <span className="inline-flex items-center rounded-full bg-primary/10 px-2.5 py-0.5 text-xs font-medium text-primary">
                    {randomMeal[0].strCategory}
                  </span>
                  <span className="inline-flex items-center rounded-full bg-secondary/10 px-2.5 py-0.5 text-xs font-medium text-secondary-foreground">
                    {randomMeal[0].strArea}
                  </span>
                </div>
                <div className="text-sm text-muted-foreground mb-4">
                  <p className="line-clamp-3">
                    {randomMeal[0].strInstructions}
                  </p>
                </div>

                <Dialog>
                  <DialogTrigger asChild>
                    <Button variant="outline">View Full Recipe</Button>
                  </DialogTrigger>
                  <DialogContent className="max-w-3xl max-h-[90vh] overflow-y-auto bg-zinc-900">
                    <DialogHeader>
                      <DialogTitle>{randomMeal[0].strMeal}</DialogTitle>
                      <DialogDescription>
                        {randomMeal[0].strCategory} • {randomMeal[0].strArea}
                      </DialogDescription>
                    </DialogHeader>
                    <div className="relative h-[200px] w-full my-4">
                      <Image
                        src={
                          randomMeal[0].strMealThumb ||
                          "/placeholder.svg?height=400&width=400"
                        }
                        alt={randomMeal[0].strMeal}
                        fill
                        className="object-cover rounded-md"
                        sizes="(max-width: 768px) 100vw, 600px"
                      />
                    </div>
                    <div className="space-y-4">
                      <h3 className="text-lg font-medium">Instructions</h3>
                      <p className="text-sm whitespace-pre-line">
                        {randomMeal[0].strInstructions}
                      </p>
                    </div>
                  </DialogContent>
                </Dialog>
              </div>
            </div>
          </div>
        ) : !isPending && !randomMeal && !error ? (
          <div className="text-center p-12 border border-dashed rounded-lg">
            <ChefHat className="mx-auto h-12 w-12 text-muted-foreground mb-4" />
            <h3 className="text-lg font-medium mb-2">No meal selected yet</h3>
            <p className="text-muted-foreground mb-4">
              Click the button above to discover a random recipe
            </p>
          </div>
        ) : null}
      </div>
    </div>
  );
};

export default MealsPage;
