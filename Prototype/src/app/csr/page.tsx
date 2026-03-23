"use client";

import { useState, useMemo } from "react";
import { getInventory } from "@/data/mockData";
import { StoreFront } from "@/components/StoreFront";

const allProducts = getInventory(); // In-memory constant

export default function CSRPage() {
  const [search, setSearch] = useState("");

  const filtered = useMemo(() => {
    return allProducts.filter((p) =>
      p.name.toLowerCase().includes(search.toLowerCase()),
    );
  }, [search]);

  return (
    <StoreFront products={filtered} onSearch={setSearch} isClient={true} />
  );
}
