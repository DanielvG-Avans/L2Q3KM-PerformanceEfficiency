"use client";

import { useState, useMemo } from "react";
import {
  filterAndSortProducts,
  getInventory,
  normalizeQuery,
  paginateProducts,
  type BenchmarkQuery,
} from "@/data/mockData";
import { StoreFront } from "@/components/StoreFront";

const PAGE_SIZE = 40;

export default function CSRPage() {
  const [query, setQuery] = useState<BenchmarkQuery>(normalizeQuery());

  const inventory = useMemo(
    () => getInventory(query.scenario),
    [query.scenario],
  );
  const filtered = useMemo(
    () => filterAndSortProducts(inventory, query),
    [inventory, query],
  );
  const paged = useMemo(
    () => paginateProducts(filtered, query.page, PAGE_SIZE),
    [filtered, query.page],
  );

  const handleQueryChange = (updates: Partial<BenchmarkQuery>) => {
    setQuery((prev) => ({ ...prev, ...updates }));
  };

  return (
    <StoreFront
      products={paged.items}
      query={query}
      totalItems={filtered.length}
      page={paged.page}
      totalPages={paged.totalPages}
      onQueryChange={handleQueryChange}
      onPageChange={(nextPage) => handleQueryChange({ page: nextPage })}
      isClient={true}
    />
  );
}
