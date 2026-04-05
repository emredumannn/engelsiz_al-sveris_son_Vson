import { getProducts, Product } from '@/lib/api';
import ProductCard from '@/components/ProductCard';

// Opt out of caching for now to always see fresh data, or use revalidate
export const dynamic = 'force-dynamic';

export default async function Home() {
  let products: Product[] = [];
  try {
    products = await getProducts();
  } catch (error) {
    console.error("Failed to fetch products:", error);
    // In a real app, you might want to show a friendly error message component
  }

  return (
    <main className="container mx-auto py-8 px-4">
      <header className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Ürünler</h1>
        <p className="text-gray-600">Engelsiz alışveriş deneyimi için tüm ürünlerimiz.</p>
      </header>

      {products.length > 0 ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {products.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      ) : (
        <div className="text-center py-12 bg-gray-50 rounded-lg border border-gray-200">
          <p className="text-gray-500 text-lg">Henyüz listelenecek ürün yok veya sunucuya ulaşılamıyor.</p>
          <p className="text-sm text-gray-400 mt-2">Lütfen daha sonra tekrar deneyiniz.</p>
        </div>
      )}
    </main>
  );
}
