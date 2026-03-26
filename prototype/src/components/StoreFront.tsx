"use client";

import { BenchmarkQuery, categories, Product } from "@/data/mockData";

export const StoreFront = ({
  products,
  query,
  totalItems,
  page,
  totalPages,
  onQueryChange,
  onPageChange,
  basePath,
  isClient,
}: {
  products: Product[];
  query: BenchmarkQuery;
  totalItems: number;
  page: number;
  totalPages: number;
  onQueryChange?: (updates: Partial<BenchmarkQuery>) => void;
  onPageChange?: (nextPage: number) => void;
  basePath?: string;
  isClient: boolean;
}) => {
  const navigateWithQuery = (updates: Partial<BenchmarkQuery>) => {
    if (!basePath) {
      return;
    }

    const next = { ...query, ...updates };
    const params = new URLSearchParams();
    params.set("scenario", next.scenario);
    params.set("q", next.q);
    params.set("category", next.category);
    params.set("sort", next.sort);
    params.set("page", String(next.page));
    window.location.assign(`${basePath}?${params.toString()}`);
  };

  const emitQueryChange = (updates: Partial<BenchmarkQuery>) => {
    if (onQueryChange) {
      onQueryChange(updates);
      return;
    }

    navigateWithQuery(updates);
  };

  const emitPageChange = (nextPage: number) => {
    if (onPageChange) {
      onPageChange(nextPage);
      return;
    }

    navigateWithQuery({ page: nextPage });
  };

  return (
    <div className="bg-white min-h-screen text-slate-900 font-sans">
      <header className="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-gray-100 p-6">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-4">
          <h1 className="text-xl font-semibold tracking-widest uppercase">
            NORDIC
          </h1>
          <div className="grid w-full gap-3 md:grid-cols-5">
            <select
              className="w-full bg-gray-50 border-none rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-black"
              value={query.scenario}
              onChange={(e) =>
                emitQueryChange({
                  scenario: e.target.value as BenchmarkQuery["scenario"],
                  page: 1,
                })
              }>
              <option value="static">Static case</option>
              <option value="dynamic">Dynamic case</option>
              <option value="massive">Dynamic + large dataset</option>
            </select>
            <input
              type="text"
              placeholder="Search inventory..."
              className="w-full bg-gray-50 border-none rounded-lg px-4 py-2 text-sm focus:ring-2 focus:ring-black transition-all"
              value={query.q}
              onChange={(e) => emitQueryChange({ q: e.target.value, page: 1 })}
            />
            <select
              className="w-full bg-gray-50 border-none rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-black"
              value={query.category}
              onChange={(e) =>
                emitQueryChange({ category: e.target.value, page: 1 })
              }>
              {categories.map((category) => (
                <option key={category} value={category}>
                  {category}
                </option>
              ))}
            </select>
            <select
              className="w-full bg-gray-50 border-none rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-black"
              value={query.sort}
              onChange={(e) =>
                emitQueryChange({
                  sort: e.target.value as BenchmarkQuery["sort"],
                  page: 1,
                })
              }>
              <option value="name-asc">Name A-Z</option>
              <option value="price-asc">Price low-high</option>
              <option value="price-desc">Price high-low</option>
            </select>
            <span className="text-[10px] text-gray-400 self-center md:justify-self-end">
              {isClient ? "⚡ CLIENT-SIDE" : "🌐 SERVER-SIDE"}
            </span>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto p-8">
        <div className="flex justify-between items-baseline mb-8">
          <h2 className="text-3xl font-light">New Arrivals</h2>
          <span className="text-gray-400 text-sm">
            {totalItems} filtered items, page {page} / {totalPages}
          </span>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 xl:grid-cols-5 gap-8">
          {products.map((p) => (
            <div key={p.id} className="group cursor-pointer">
              <div
                className="aspect-4/5 rounded-2xl mb-4 transition-transform duration-500 group-hover:scale-[1.02]"
                style={{ backgroundColor: p.imageColor }}
              />
              <h3 className="font-medium text-sm">{p.name}</h3>
              <p className="text-gray-400 text-xs mt-1 truncate">
                {p.description}
              </p>
              <p className="mt-2 text-sm font-semibold">€{p.price}</p>
            </div>
          ))}
        </div>

        <div className="mt-10 flex items-center justify-center gap-3">
          <button
            type="button"
            className="rounded-lg border border-slate-200 px-4 py-2 text-sm disabled:opacity-40"
            disabled={page <= 1}
            onClick={() => emitPageChange(page - 1)}>
            Previous
          </button>
          <button
            type="button"
            className="rounded-lg border border-slate-200 px-4 py-2 text-sm disabled:opacity-40"
            disabled={page >= totalPages}
            onClick={() => emitPageChange(page + 1)}>
            Next
          </button>
        </div>
      </main>
    </div>
  );
};
