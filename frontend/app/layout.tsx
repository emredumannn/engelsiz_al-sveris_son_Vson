import type { Metadata } from "next";
import "./globals.css";
import Navbar from "@/components/Navbar";

export const metadata: Metadata = {
  title: "Engelsiz Alışveriş",
  description: "Görme engelli bireyler için erişilebilir alışveriş platformu.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="tr">
      <body
        className="bg-gray-50 min-h-screen font-sans antialiased"
      >
        <Navbar />
        {children}
      </body>
    </html>
  );
}
