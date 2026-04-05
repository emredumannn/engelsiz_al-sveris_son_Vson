import Link from 'next/link';

export default function CartPage() {
    return (
        <div className="container mx-auto py-12 px-4 text-center">
            <div className="max-w-md mx-auto bg-white p-8 rounded-xl shadow-md">
                <div className="text-6xl mb-4">🛒</div>
                <h1 className="text-2xl font-bold text-gray-900 mb-2">Sepetiniz Boş</h1>
                <p className="text-gray-600 mb-6">Henüz sepetinize ürün eklemediniz.</p>
                <Link href="/" className="inline-block bg-blue-600 text-white font-medium px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors">
                    Alışverişe Başla
                </Link>
            </div>
        </div>
    );
}
