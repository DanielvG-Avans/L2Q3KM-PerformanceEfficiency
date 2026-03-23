export interface Product {
  id: number;
  name: string;
  category: string;
  price: number;
  description: string;
  imageColor: string;
}

const categories = ["Electronics", "Lifestyle", "Design", "Audio", "Home"];
const colors = ["#f3f4f6", "#e5e7eb", "#fee2e2", "#fef3c7", "#dcfce7"];

export const getInventory = (): Product[] => {
  return Array.from({ length: 2500 }, (_, i) => ({
    id: i,
    name: `${categories[i % categories.length]} Item ${i + 1}`,
    category: categories[i % categories.length],
    price: ((i * 17) % 500) + 50, // Voorspelbaar: altijd dezelfde prijs voor hetzelfde ID
    description: "Minimalist design meeting functional excellence.",
    imageColor: colors[i % colors.length],
  }));
};
