export interface Product {
  id: number;
  name: string;
  category: string;
  price: number;
  description: string;
  imageColor: string;
}

export type Scenario = "static" | "dynamic" | "massive";
export type SortKey = "name-asc" | "price-asc" | "price-desc";

export interface BenchmarkQuery {
  scenario: Scenario;
  q: string;
  category: string;
  sort: SortKey;
  page: number;
}

export const categories = [
  "All",
  "Electronics",
  "Lifestyle",
  "Design",
  "Audio",
  "Home",
];
const colors = ["#f3f4f6", "#e5e7eb", "#fee2e2", "#fef3c7", "#dcfce7"];

const SCENARIO_SIZES: Record<Scenario, number> = {
  static: 48,
  dynamic: 2500,
  massive: 15000,
};

const DEFAULT_QUERY: BenchmarkQuery = {
  scenario: "dynamic",
  q: "",
  category: "All",
  sort: "name-asc",
  page: 1,
};

const compareBySort = (a: Product, b: Product, sort: SortKey): number => {
  if (sort === "price-asc") {
    return a.price - b.price;
  }

  if (sort === "price-desc") {
    return b.price - a.price;
  }

  return a.name.localeCompare(b.name);
};

const generateInventory = (length: number): Product[] => {
  return Array.from({ length }, (_, i) => ({
    id: i,
    name: `${categories[(i % (categories.length - 1)) + 1]} Item ${i + 1}`,
    category: categories[(i % (categories.length - 1)) + 1],
    price: ((i * 17) % 500) + 50,
    description: "Minimalist design meeting functional excellence.",
    imageColor: colors[i % colors.length],
  }));
};

const scenarioData: Record<Scenario, Product[]> = {
  static: generateInventory(SCENARIO_SIZES.static),
  dynamic: generateInventory(SCENARIO_SIZES.dynamic),
  massive: generateInventory(SCENARIO_SIZES.massive),
};

export const getInventory = (scenario: Scenario): Product[] => {
  return scenarioData[scenario];
};

export const normalizeQuery = (
  raw?: Partial<Record<string, string>>,
): BenchmarkQuery => {
  const scenario = raw?.scenario;
  const sort = raw?.sort;
  const page = Number(raw?.page || DEFAULT_QUERY.page);
  const category = raw?.category || DEFAULT_QUERY.category;

  const safeScenario: Scenario =
    scenario === "static" || scenario === "dynamic" || scenario === "massive"
      ? scenario
      : DEFAULT_QUERY.scenario;

  const safeSort: SortKey =
    sort === "name-asc" || sort === "price-asc" || sort === "price-desc"
      ? sort
      : DEFAULT_QUERY.sort;

  return {
    scenario: safeScenario,
    q: raw?.q || DEFAULT_QUERY.q,
    category: categories.includes(category) ? category : DEFAULT_QUERY.category,
    sort: safeSort,
    page:
      Number.isFinite(page) && page > 0 ? Math.floor(page) : DEFAULT_QUERY.page,
  };
};

export const filterAndSortProducts = (
  products: Product[],
  query: BenchmarkQuery,
): Product[] => {
  const q = query.q.toLowerCase();

  return products
    .filter((product) => {
      const matchesQuery = product.name.toLowerCase().includes(q);
      const matchesCategory =
        query.category === "All" || product.category === query.category;
      return matchesQuery && matchesCategory;
    })
    .sort((a, b) => compareBySort(a, b, query.sort));
};

export const paginateProducts = (
  products: Product[],
  page: number,
  pageSize: number,
) => {
  const safePageSize = Math.max(1, pageSize);
  const totalPages = Math.max(1, Math.ceil(products.length / safePageSize));
  const safePage = Math.min(Math.max(page, 1), totalPages);
  const start = (safePage - 1) * safePageSize;

  return {
    page: safePage,
    totalPages,
    items: products.slice(start, start + safePageSize),
  };
};
