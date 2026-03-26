import {
  filterAndSortProducts,
  getInventory,
  normalizeQuery,
  paginateProducts,
} from "@/data/mockData";
import { StoreFront } from "@/components/StoreFront";

const PAGE_SIZE = 40;

const toSingleValue = (value?: string | string[]) => {
  if (Array.isArray(value)) {
    return value[0] || "";
  }

  return value || "";
};

export default async function SSRPage({
  searchParams,
}: {
  searchParams: {
    scenario?: string | string[];
    q?: string | string[];
    category?: string | string[];
    sort?: string | string[];
    page?: string | string[];
  };
}) {
  const query = normalizeQuery({
    scenario: toSingleValue(searchParams.scenario),
    q: toSingleValue(searchParams.q),
    category: toSingleValue(searchParams.category),
    sort: toSingleValue(searchParams.sort),
    page: toSingleValue(searchParams.page),
  });
  const allProducts = getInventory(query.scenario);
  const filtered = filterAndSortProducts(allProducts, query);
  const paged = paginateProducts(filtered, query.page, PAGE_SIZE);

  return (
    <StoreFront
      products={paged.items}
      query={query}
      totalItems={filtered.length}
      page={paged.page}
      totalPages={paged.totalPages}
      basePath="/ssr"
      isClient={false}
    />
  );
}
