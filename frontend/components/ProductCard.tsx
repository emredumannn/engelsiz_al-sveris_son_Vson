import React from 'react';
import Link from 'next/link';
import { Product } from '@/lib/api';

interface ProductCardProps {
    product: Product;
}

const ProductCard: React.FC<ProductCardProps> = ({ product }) => {
    return (
        <div className="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition-shadow p-4 flex flex-col h-full">
            {/* Image Placeholder */}
            <div className="h-48 bg-gray-100 rounded-md mb-4 flex items-center justify-center overflow-hidden">
                {product.image_url ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img src={product.image_url} alt={product.name} className="object-cover h-full w-full" />
                ) : (
                    <span className="text-gray-400 text-sm">Görsel Yok</span>
                )}
            </div>

            <h2 className="text-xl font-semibold text-gray-800 mb-2 line-clamp-2">{product.name}</h2>

            <div className="mt-auto flex justify-between items-center">
                <span className="text-lg font-bold text-green-700">
                    {product.price} {product.currency}
                </span>
                <Link
                    href={product.barcode ? `/products/${product.barcode}` : '#'}
                    className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition-colors focus:ring-2 focus:ring-blue-500 focus:outline-none"
                    aria-label={`${product.name} detaylarını gör`}
                >
                    İncele
                </Link>
            </div>
        </div>
    );
};

export default ProductCard;
