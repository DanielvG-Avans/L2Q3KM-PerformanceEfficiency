import { normalizeQuery } from "@/data/mockData";
import { CSRClientPage } from "@/components/CSRClientPage";

export const dynamic = "force-dynamic";

const toSingleValue = (value?: string | string[]) => {
  if (Array.isArray(value)) {
    return value[0] || "";
  }

  return value || "";
};

export default function CSRPage({
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
  const initialQuery = normalizeQuery({
    scenario: toSingleValue(searchParams.scenario),
    q: toSingleValue(searchParams.q),
    category: toSingleValue(searchParams.category),
    sort: toSingleValue(searchParams.sort),
    page: toSingleValue(searchParams.page),
  });

  return <CSRClientPage initialQuery={initialQuery} />;
}
