import { getProductByBarcode } from '@/lib/api';
import Link from 'next/link';

// Use this for proper type support in Next.js 15+ if needed, but for now simple props working
type Props = {
    params: Promise<{ barcode: string }>
}

export default async function ProductDetail({ params }: Props) {
    const { barcode } = await params;

    let product = null;
    let error = null;

    try {
        product = await getProductByBarcode(barcode);
    } catch (err) {
        console.error("Product fetch failed:", err);
        error = "Ürün bulunamadı veya bir hata oluştu.";
    }

    if (error || !product) {
        return (
            <div className="container mx-auto py-12 px-4 text-center">
                <h1 className="text-2xl font-bold text-red-600 mb-4">Hata</h1>
                <p className="text-gray-600 mb-6">{error || "Ürün verisi alınamadı."}</p>
                <Link href="/" className="text-blue-600 hover:underline">
                    &larr; Ana Sayfaya Dön
                </Link>
            </div>
        );
    }

    return (
        <div className="container mx-auto py-8 px-4">
            <Link href="/" className="text-blue-600 hover:underline mb-6 inline-block">
                &larr; Ürünlere Dön
            </Link>

            <div className="bg-white rounded-xl shadow-lg overflow-hidden border border-gray-100">
                <div className="md:flex">
                    {/* Image Section */}
                    <div className="md:w-1/2 p-4 bg-gray-50 flex items-center justify-center min-h-[400px]">
                        {product.image_url ? (
                            // eslint-disable-next-line @next/next/no-img-element
                            <img
                                src={product.image_url}
                                alt={product.name}
                                className="max-h-[400px] w-auto object-contain rounded-lg shadow-sm"
                            />
                        ) : (
                            <div className="text-center text-gray-400">
                                <span className="block text-6xl mb-2">📷</span>
                                <span>Görsel Yok</span>
                            </div>
                        )}
                    </div>

                    {/* Details Section */}
                    <div className="md:w-1/2 p-8 flex flex-col justify-between">
                        <div>
                            <div className="flex items-center justify-between mb-2">
                                <span className="text-sm font-medium text-blue-600 bg-blue-50 px-3 py-1 rounded-full">
                                    Barkod: {product.barcode}
                                </span>
                            </div>

                            <h1 className="text-3xl font-extrabold text-gray-900 mb-4">{product.name}</h1>

                            <div className="prose prose-lg text-gray-600 mb-6">
                                <p>{product.description || "Açıklama bulunmuyor."}</p>
                            </div>

                            {/* OCR Text Display - If available */}
                            {/* This is a specific feature for visually impaired users to read raw text on product */}
                            {product.ocr_text && (
                                <details className="mb-6 p-4 bg-yellow-50 rounded-lg border border-yellow-100 open:ring-2 ring-yellow-200">
                                    <summary className="font-semibold text-yellow-800 cursor-pointer">
                                        Ürün Üzerindeki Yazılar (OCR)
                                    </summary>
                                    <p className="mt-2 text-sm text-yellow-900 whitespace-pre-wrap">

                                        {product.ocr_text}
                                    </p>
                                </details>
                            )}
                        </div>

                        <div className="mt-8 border-t pt-6">
                            <div className="flex items-center justify-between mb-6">
                                <span className="text-gray-500">Fiyat</span>
                                <span className="text-4xl font-bold text-green-700">
                                    {product.price} <span className="text-2xl">{product.currency}</span>
                                </span>
                            </div>

                            <button className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 px-6 rounded-xl transition transform hover:scale-[1.02] active:scale-[0.98] shadow-lg flex items-center justify-center gap-3">
                                <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                                </svg>
                                Sepete Ekle
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
