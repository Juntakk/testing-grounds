"use client";
import React, { JSX } from "react";
import { usePagination } from "../hooks/usePagination";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { PaginationEllipsis } from "./ui/pagination";

type Item = {
  id: number;
  name: string;
  value: string;
};

const mockData: Item[] = Array.from({ length: 35 }, (_, i) => ({
  id: i + 1,
  name: `Item ${i + 1}`,
  value: `Value ${i + 1}`,
}));

const PaginationComponent: React.FC = () => {
  const {
    paginatedData,
    currentPage,
    totalPages,
    nextPage,
    prevPage,
    goToPage,
  } = usePagination(mockData, 5);

  const getPaginationButtons = () => {
    const delta = 1; // Nombre de pages affichées autour de currentPage
    const buttons: (JSX.Element | string)[] = [];
    const pages: number[] = [];

    // Pages toujours affichées
    pages.push(1);
    if (currentPage - delta > 2) pages.push(-1); // Ajoute "..." après 1 si l'écart est trop grand
    for (
      let i = Math.max(2, currentPage - delta);
      i <= Math.min(totalPages - 1, currentPage + delta);
      i++
    ) {
      pages.push(i);
    }
    if (currentPage + delta < totalPages - 1) pages.push(-1); // Ajoute "..." avant totalPages si nécessaire
    if (totalPages > 1) pages.push(totalPages);

    // Générer les boutons
    pages.forEach((page, i) => {
      if (page === -1) {
        buttons.push(
          <span key={`ellipsis-${i}`} className="px-0">
            <PaginationEllipsis />
          </span>
        );
      } else {
        buttons.push(
          <button
            key={page}
            onClick={() => goToPage(page)}
            className={`px-3.5 rounded-md transition hover:cursor-pointer text-gray-900 dark:text-white ${
              currentPage === page
                ? "bg-primary text-primary-foreground dark:bg-primary dark:text-primary-foreground dark:border dark:rounded"
                : "hover:bg-muted dark:hover:bg-muted/50"
            }`}
          >
            {page}
          </button>
        );
      }
    });

    return buttons;
  };

  return (
    <div className="w-full p-6 bg-card text-card-foreground rounded-lg shadow-md dark:bg-card-dark dark:text-card-foreground-dark">
      <table className="w-full border border-border border-collapse rounded-md overflow-hidden dark:border-border-dark">
        <thead>
          <tr className="bg-primary text-primary-foreground dark:bg-primary-dark dark:text-primary-foreground-dark">
            <th className="border border-border p-3 text-left dark:border-border-dark">
              ID
            </th>
            <th className="border border-border p-3 text-left dark:border-border-dark">
              Name
            </th>
            <th className="border border-border p-3 text-left dark:border-border-dark">
              Value
            </th>
          </tr>
        </thead>
        <tbody>
          {paginatedData.map((item) => (
            <tr
              key={item.id}
              className="text-left transition-colors hover:bg-muted/50 dark:hover:bg-muted-dark"
            >
              <td className="border border-border p-3 dark:border-border-dark">
                {item.id}
              </td>
              <td className="border border-border p-3 dark:border-border-dark">
                {item.name}
              </td>
              <td className="border border-border p-3 dark:border-border-dark">
                {item.value}
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* Pagination Controls */}
      <div className="flex items-center justify-center mt-6 gap-2 w-full">
        <button
          onClick={prevPage}
          disabled={currentPage === 1}
          className="flex justify-center items-center px-4 py-2 w-full rounded-md disabled:opacity-50 hover:cursor-pointer text-gray-900 dark:text-white dark:hover:bg-muted-dark"
        >
          <ChevronLeft className="font-bold mt-0.25" />
          <span className="hidden sm:block">Previous</span>
        </button>

        {/* Pagination Buttons */}
        <div className="flex gap-2 w-full justify-center">
          {getPaginationButtons()}
        </div>

        <button
          onClick={nextPage}
          disabled={currentPage === totalPages}
          className="flex justify-center items-center px-4 py-2 w-full rounded-md disabled:opacity-50 hover:cursor-pointer text-gray-900 dark:text-white dark:hover:bg-muted-dark"
        >
          <span className="hidden sm:block">Next</span>
          <ChevronRight className="font-bold mt-0.25" />
        </button>
      </div>
    </div>
  );
};

export default PaginationComponent;
