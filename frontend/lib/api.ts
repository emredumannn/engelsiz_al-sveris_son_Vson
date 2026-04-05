import axios from 'axios';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api/v1';

const api = axios.create({
    baseURL: API_URL,
    headers: {
        'Content-Type': 'application/json',
    },
});

export interface Product {
    id: number;
    barcode?: string;
    name: string;
    description?: string;
    price: number;
    currency: string;
    image_url?: string;
    ocr_text?: string;
}

export const getProducts = async (skip = 0, limit = 100) => {
    const response = await api.get<Product[]>(`/products/?skip=${skip}&limit=${limit}`);
    return response.data;
};

export const getProductByBarcode = async (barcode: string) => {
    const response = await api.get<Product>(`/products/${barcode}`);
    return response.data;
};

export default api;
