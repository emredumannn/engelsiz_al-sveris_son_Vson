import Link from 'next/link';
import { ShoppingCart } from 'lucide-react';

const Navbar = () => {
    return (
        <nav className="bg-slate-900 text-white p-4 shadow-md">
            <div className="container mx-auto flex justify-between items-center">
                <Link href="/" className="text-2xl font-bold hover:text-slate-300 transition-colors">
                    Engelsiz Alışveriş
                </Link>
                <div className="flex items-center space-x-4">
                    <Link href="/cart" className="flex items-center hover:text-slate-300 transition-colors" aria-label="Sepete Git">
                        <ShoppingCart className="w-6 h-6 mr-2" />
                        <span className="hidden sm:inline">Sepetim</span>
                    </Link>
                </div>
            </div>
        </nav>
    );
};

export default Navbar;
