import { getInventory } from "@/data/mockData";
import { StoreFront } from "@/components/StoreFront";

export default async function SSRPage({
  searchParams,
}: {
  searchParams: { q?: string };
}) {
  const query = searchParams.q || "";
  const allProducts = getInventory();

  const filtered = allProducts.filter((p) =>
    p.name.toLowerCase().includes(query.toLowerCase()),
  );

  return (
    <>
      {/* Client-side form voor de search om de URL te updaten */}
      <StoreFront products={filtered} isClient={false} />
      <script
        dangerouslySetInnerHTML={{
          __html: `
        document.querySelector('input').oninput = (e) => {
          const url = new URL(window.location);
          url.searchParams.set('q', e.target.value);
          window.history.replaceState({}, '', url);
          window.location.reload(); // Simuleer pure SSR roundtrip
        }
      `,
        }}
      />
    </>
  );
}
