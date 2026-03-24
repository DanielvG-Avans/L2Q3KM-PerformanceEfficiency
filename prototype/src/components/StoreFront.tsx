import { Product } from "@/data/mockData";

export const StoreFront = ({
  products,
  onSearch,
  isClient,
}: {
  products: Product[];
  onSearch?: (val: string) => void;
  isClient: boolean;
}) => (
  <div className="bg-white min-h-screen text-slate-900 font-sans">
    <header className="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-gray-100 p-6">
      <div className="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-4">
        <h1 className="text-xl font-semibold tracking-widest uppercase">
          NORDIC
        </h1>
        <div className="relative w-full max-w-sm">
          <input
            type="text"
            placeholder="Search inventory..."
            className="w-full bg-gray-50 border-none rounded-lg px-4 py-2 text-sm focus:ring-2 focus:ring-black transition-all"
            onChange={onSearch ? (e) => onSearch(e.target.value) : undefined}
          />
          <span className="absolute right-3 top-2 text-[10px] text-gray-400">
            {isClient ? "⚡ CLIENT-SIDE" : "🌐 SERVER-SIDE"}
          </span>
        </div>
      </div>
    </header>

    <main className="max-w-7xl mx-auto p-8">
      <div className="flex justify-between items-baseline mb-8">
        <h2 className="text-3xl font-light">New Arrivals</h2>
        <span className="text-gray-400 text-sm">
          {products.length} items loaded
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
    </main>
  </div>
);
